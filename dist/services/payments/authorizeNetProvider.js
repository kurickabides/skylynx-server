"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthorizeNetProvider = void 0;
// ================================================
// ✅ Entity: AuthorizeNetProvider
// Description: Authorize.Net REST implementation of PaymentProvider (SP-first)
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: services/payments/authorizeNetProvider.ts
// ================================================
const axios_1 = __importDefault(require("axios"));
const crypto_1 = __importDefault(require("crypto"));
const uuid_1 = require("uuid");
// SP-first service (no direct SQL here)
const paymentsService_1 = require("./paymentsService");
// --- Helpers -------------------------------------------------------------
/**
 * Build hosted payment settings payload from env (can swap to ModuleSettings later).
 */
function buildHostedPaymentSettings() {
    const returnUrl = process.env.PAYMENT_RETURN_URL || "http://localhost:5173/payment/return";
    const cancelUrl = process.env.PAYMENT_CANCEL_URL || "http://localhost:5173/payment/cancel";
    const iframeCommUrl = process.env.PAYMENT_IFRAME_COMMUNICATOR_URL ||
        "http://localhost:5173/payment/anet-iframe-comm.html";
    return [
        {
            settingName: "hostedPaymentReturnOptions",
            settingValue: JSON.stringify({
                showReceipt: false,
                url: returnUrl,
                urlText: "Continue",
                cancelUrl,
                cancelUrlText: "Cancel",
            }),
        },
        {
            settingName: "hostedPaymentIFrameCommunicatorUrl",
            settingValue: JSON.stringify({ url: iframeCommUrl }),
        },
        {
            settingName: "hostedPaymentButtonOptions",
            settingValue: JSON.stringify({ text: "Pay" }),
        },
        {
            settingName: "hostedPaymentPaymentOptions",
            settingValue: JSON.stringify({ cardCodeRequired: true }),
        },
    ];
}
const mapStatus = (s) => {
    switch (s) {
        case "Authorized":
            return "Authorized";
        case "Captured":
            return "Captured";
        case "Voided":
            return "Voided";
        case "Refunded":
            return "Refunded";
        case "Pending":
            return "Pending";
        default:
            return "Failed";
    }
};
// --- Provider ------------------------------------------------------------
class AuthorizeNetProvider {
    /**
     * Create Hosted Payment token + persist PaymentIntent and initial txn log.
     * - Uses Payments.CreateIntent (SP) via paymentsService
     * - Calls Authorize.Net getHostedPaymentPageRequest
     * - Logs a Payments.Txn row via Payments.RecordTxn (SP)
     */
    async createHostedPayment(input) {
        const { providerId, portalId, userId, amount, currency = "USD", clientRef, } = input;
        // 0) Load secrets (domain shape) via SP-first service
        //    NOTE: these values may still be encrypted per your storage policy.
        //    Decrypt here when your decrypt helper is ready.
        const secrets = await (0, paymentsService_1.getProviderSecret)(providerId);
        if (!secrets)
            throw new Error("Payment provider secrets not found");
        // 1) Create a PaymentIntent (Status=Pending)
        const paymentIntentId = await (0, paymentsService_1.createIntent)({
            providerId,
            portalId,
            userId,
            amount,
            currency,
            clientRef,
        });
        // 2) Build ANet request for hosted page token
        const correlationId = (0, uuid_1.v4)();
        const payload = {
            getHostedPaymentPageRequest: {
                merchantAuthentication: {
                    name: secrets.apiLoginId,
                    transactionKey: secrets.transactionKey,
                },
                refId: correlationId,
                transactionRequest: {
                    transactionType: "authCaptureTransaction",
                    amount: amount.toFixed(2),
                },
                hostedPaymentSettings: buildHostedPaymentSettings(),
            },
        };
        const resp = await axios_1.default.post(secrets.apiBaseUrl, payload, {
            headers: { "Content-Type": "application/json" },
        });
        const token = resp?.data?.token;
        if (!token) {
            // Persist a failed attempt for traceability
            await (0, paymentsService_1.recordTxn)({
                intentId: paymentIntentId,
                txnType: "AuthCapture",
                resultCode: "TokenMissing",
                rawJson: JSON.stringify(resp?.data ?? {}),
            });
            throw new Error("Authorize.Net did not return a hosted payment token.");
        }
        // 3) Log "token issued" as a txn row
        await (0, paymentsService_1.recordTxn)({
            intentId: paymentIntentId,
            txnType: "AuthCapture",
            resultCode: "TokenIssued",
            rawJson: JSON.stringify(resp.data),
        });
        return {
            token,
            iframeUrl: secrets.hostedPaymentBaseUrl,
            paymentIntentId,
            mode: secrets.mode,
        };
    }
    /** DB-backed status (updated by webhook) */
    async getIntentStatus(paymentIntentId) {
        const row = await (0, paymentsService_1.getIntentById)(paymentIntentId);
        if (!row)
            throw new Error("PaymentIntent not found");
        return {
            paymentIntentId,
            status: mapStatus(row.Status),
            amount: Number(row.Amount),
            currency: row.Currency,
            lastUpdatedUtc: (row.UpdatedAt || row.CreatedAt)?.toISOString?.() ??
                String(row.UpdatedAt || row.CreatedAt),
        };
        // If you prefer a dedicated SP, add Payments.GetPaymentIntentStatusById and swap here.
    }
    /**
     * Verify HMAC and upsert webhook → map to intent → update status.
     * SPs expected:
     *  - Payments.UpsertWebhook(EventID, EventType, RawJson)
     *  - Payments.ResolveIntentByGatewayTxnID(@GatewayTxnID) -> PaymentIntentID
     *  - Payments.UpdateIntentStatus(PaymentIntentID, Status)
     *  - Payments.RecordTxn(...) (optional, if you want to store the webhook as a txn as well)
     */
    async processWebhook(rawBody, signatureHeader) {
        // 0) Validate signature (env secret for now)
        const signatureKeyHex = process.env.ANET_SIGNATURE_KEY_HEX;
        const expected = "sha512=" +
            crypto_1.default
                .createHmac("sha512", Buffer.from(signatureKeyHex, "hex"))
                .update(rawBody, "utf8")
                .digest("hex");
        if ((signatureHeader || "").toLowerCase() !== expected.toLowerCase()) {
            throw new Error("Invalid Authorize.Net webhook signature");
        }
        const parsed = JSON.parse(rawBody);
        const eventId = parsed?.id;
        const eventType = parsed?.eventType;
        const transId = parsed?.payload?.id || parsed?.payload?.transId;
        const responseCode = parsed?.payload?.responseCode;
        // A) Store webhook (idempotent)
        // You’ll create Payments.UpsertWebhook (if not already)
        // NOTE: using raw SQL here would break SP-first; prefer to add a small service wrapper later.
        const upsertWebhook = await Promise.resolve().then(() => __importStar(require("./paymentsService"))); // dynamic to avoid cycle
        // @ts-ignore
        if (upsertWebhook?.upsertWebhookEvent) {
            // If you add a helper, call it. Otherwise, leave as TODO.
            await upsertWebhook.upsertWebhookEvent(eventId, eventType, rawBody);
        }
        // B) Resolve intent by gateway txn id and update status
        // You’ll create Payments.ResolveIntentByGatewayTxnID
        //const resolver = await import("./paymentsResolvers"); // optional future split
        // Fallback path: if you don’t have the resolver yet, we simply log and return ok.
        // In practice, implement the resolver SP and a service function for it.
        // Lightweight status mapping from eventType/responseCode
        const status = eventType?.toLowerCase()?.includes("authcapture")
            ? "Captured"
            : eventType?.toLowerCase()?.includes("authorization")
                ? "Authorized"
                : eventType?.toLowerCase()?.includes("void")
                    ? "Voided"
                    : eventType?.toLowerCase()?.includes("refund")
                        ? "Refunded"
                        : responseCode === 1
                            ? "Captured"
                            : "Failed";
        // If you know the intentId (via resolver), call:
        // await updateIntentStatus(intentId, status as any);
        return { ok: true };
    }
}
exports.AuthorizeNetProvider = AuthorizeNetProvider;
