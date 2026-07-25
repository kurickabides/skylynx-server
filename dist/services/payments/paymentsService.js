"use strict";
// ================================================
// ✅ Service: paymentsService
// Description: SP-first service for Payments schema (no SDK yet)
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: services/payments/paymentsService.ts
// ================================================
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getModuleSettingByKey = getModuleSettingByKey;
exports.upsertModuleSetting = upsertModuleSetting;
exports.getProviderSecret = getProviderSecret;
exports.createIntent = createIntent;
exports.addTargetLink = addTargetLink;
exports.updateIntentStatus = updateIntentStatus;
exports.recordTxn = recordTxn;
exports.getIntentById = getIntentById;
exports.getTxnsByIntent = getTxnsByIntent;
exports.upsertWebhookEvent = upsertWebhookEvent;
exports.resolveIntentByGatewayTxnID = resolveIntentByGatewayTxnID;
exports.resolveActiveProviderForModule = resolveActiveProviderForModule;
const mssql_1 = __importDefault(require("mssql"));
const db_1 = require("../../config/db");
const as3 = (c) => (c || "USD").trim().toUpperCase().slice(0, 3);
/** Logs to SystemLogs (table write; consider wrapper SP later) */
async function logSystem(level, message) {
    const pool = await db_1.poolPromise;
    await pool
        .request()
        .input("LogType", mssql_1.default.NVarChar(50), level)
        .input("LogMessage", mssql_1.default.NVarChar(mssql_1.default.MAX), message)
        .query(`INSERT INTO dbo.SystemLogs (LogID, LogType, LogMessage, CreatedAt)
       VALUES (NEWID(), @LogType, @LogMessage, GETDATE());`);
}
// Given DB mode, derive ANet base URLs we’ll need later
function deriveAnetBaseUrls(mode) {
    if (mode === "production") {
        return {
            hostedPaymentBaseUrl: "https://accept.authorize.net/payment/payment",
            apiBaseUrl: "https://api2.authorize.net/xml/v1/request.api",
        };
    }
    return {
        hostedPaymentBaseUrl: "https://test.authorize.net/payment/payment",
        apiBaseUrl: "https://apitest.authorize.net/xml/v1/request.api",
    };
}
/** Map DB row → domain shape. (Decrypt later in one place if needed.) */
function mapToProviderSecrets(row) {
    const { hostedPaymentBaseUrl, apiBaseUrl } = deriveAnetBaseUrls(row.Mode);
    return {
        apiLoginId: row.ApiLoginID_enc,
        transactionKey: row.TransactionKey_enc,
        signatureKeyHex: row.SignatureKeyHex_enc,
        mode: row.Mode,
        hostedPaymentBaseUrl,
        apiBaseUrl,
    };
}
// ---- Public API --------------------------------------------------------------
/**
 * Resolve a module setting by KeyName for a specific module instance (PPM).
 * SP-first: dbo.GetModuleSettingByKey
 */
async function getModuleSettingByKey(portalPageModuleId, keyName, roleId) {
    const pool = await db_1.poolPromise;
    const req = pool.request();
    req.input("PortalPageModuleID", mssql_1.default.UniqueIdentifier, portalPageModuleId);
    req.input("KeyName", mssql_1.default.NVarChar(100), keyName);
    if (roleId)
        req.input("RoleID", mssql_1.default.NVarChar(128), roleId);
    const result = await req.execute("dbo.GetModuleSettingByKey");
    const row = result.recordset?.[0];
    if (!row)
        return null;
    return {
        keyName: row.KeyName ?? keyName,
        value: row.Value ?? null,
        roleId: row.RoleID ?? null,
        updatedAt: row.UpdatedAt ? new Date(row.UpdatedAt).toISOString() : null,
    };
}
/** Upsert a single module setting by KeyName (SP-first) */
async function upsertModuleSetting(portalPageModuleId, keyName, roleId, value) {
    const pool = await db_1.poolPromise;
    await pool
        .request()
        .input("PortalPageModuleID", mssql_1.default.UniqueIdentifier, portalPageModuleId)
        .input("KeyName", mssql_1.default.NVarChar(100), keyName)
        .input("RoleID", mssql_1.default.NVarChar(128), roleId)
        .input("Value", mssql_1.default.NVarChar(mssql_1.default.MAX), value)
        .execute("dbo.UpsertModuleSetting");
}
/** Fetch provider secrets (encrypted) for a ProviderID */
async function getProviderSecret(providerId) {
    const pool = await db_1.poolPromise;
    const result = await pool
        .request()
        .input("ProviderID", mssql_1.default.UniqueIdentifier, providerId)
        .execute("Payments.GetProviderSecret");
    const row = result.recordset?.[0];
    if (!row)
        return null;
    return mapToProviderSecrets(row);
}
/** Create an Intent and return its GUID (NEWID() inside SP) */
async function createIntent(input) {
    const pool = await db_1.poolPromise;
    const req = pool.request();
    // NOTE: Intent.UserID is UNIQUEIDENTIFIER in Payments schema.
    // Your AspNetUsers.Id is NVARCHAR(128). If you need a FK later, we’ll align types.
    const currency3 = as3(input.currency);
    const status = "Pending";
    req.output("PaymentIntentID", mssql_1.default.UniqueIdentifier);
    req.input("ProviderID", mssql_1.default.UniqueIdentifier, input.providerId);
    req.input("PortalID", mssql_1.default.UniqueIdentifier, input.portalId);
    req.input("UserID", mssql_1.default.UniqueIdentifier, input.userId);
    req.input("Amount", mssql_1.default.Decimal(18, 2), input.amount);
    req.input("Currency", mssql_1.default.Char(3), currency3);
    req.input("ClientRef", mssql_1.default.NVarChar(100), input.clientRef ?? null);
    req.input("Status", mssql_1.default.NVarChar(20), status);
    const result = await req.execute("Payments.CreateIntent");
    const intentId = result.output.PaymentIntentID;
    await logSystem("Info", `Payments.CreateIntent ok intentId=${intentId} provider=${input.providerId} amount=${input.amount} ${currency3}`);
    return intentId;
}
/** Link a domain object to an intent (pre/post transaction) */
async function addTargetLink(paymentIntentId, targetDomain, targetId) {
    const pool = await db_1.poolPromise;
    await pool
        .request()
        .input("PaymentIntentID", mssql_1.default.UniqueIdentifier, paymentIntentId)
        .input("TargetDomain", mssql_1.default.NVarChar(50), targetDomain)
        .input("TargetID", mssql_1.default.UniqueIdentifier, targetId)
        .execute("Payments.AddTargetLink");
    await logSystem("Info", `Payments.AddTargetLink ok intentId=${paymentIntentId} domain=${targetDomain} targetId=${targetId}`);
}
/** Update intent status via SP */
async function updateIntentStatus(paymentIntentId, status) {
    const pool = await db_1.poolPromise;
    await pool
        .request()
        .input("PaymentIntentID", mssql_1.default.UniqueIdentifier, paymentIntentId)
        .input("Status", mssql_1.default.NVarChar(20), status)
        .execute("Payments.UpdateIntentStatus");
    await logSystem("Info", `Payments.UpdateIntentStatus ok intentId=${paymentIntentId} status=${status}`);
}
/**
 * Record a transaction row for an intent (stores response metadata/json).
 * Returns the generated PaymentTxnID (NEWID() inside SP).
 */
async function recordTxn(args) {
    const pool = await db_1.poolPromise;
    const req = pool.request();
    req.output("PaymentTxnID", mssql_1.default.UniqueIdentifier);
    req.input("PaymentIntentID", mssql_1.default.UniqueIdentifier, args.intentId);
    req.input("TxnType", mssql_1.default.NVarChar(20), args.txnType);
    req.input("GatewayTxnID", mssql_1.default.NVarChar(100), args.gatewayTxnId ?? null);
    req.input("AuthCode", mssql_1.default.NVarChar(50), args.authCode ?? null);
    req.input("ResultCode", mssql_1.default.NVarChar(50), args.resultCode ?? null);
    req.input("RawJson", mssql_1.default.NVarChar(mssql_1.default.MAX), args.rawJson ?? null);
    const result = await req.execute("Payments.RecordTxn");
    const txnId = result.output.PaymentTxnID;
    await logSystem("Info", `Payments.RecordTxn ok intentId=${args.intentId} txnId=${txnId} type=${args.txnType}`);
    return txnId;
}
/** Read intent by ID */
async function getIntentById(paymentIntentId) {
    const pool = await db_1.poolPromise;
    const result = await pool
        .request()
        .input("PaymentIntentID", mssql_1.default.UniqueIdentifier, paymentIntentId)
        .execute("Payments.GetIntentById");
    return result.recordset?.[0] ?? null;
}
/** Read transactions for an intent */
async function getTxnsByIntent(paymentIntentId) {
    const pool = await db_1.poolPromise;
    const result = await pool
        .request()
        .input("PaymentIntentID", mssql_1.default.UniqueIdentifier, paymentIntentId)
        .execute("Payments.GetTxnsByIntent");
    return result.recordset ?? [];
}
/**
 * Webhook store (idempotent)
 * SP: Payments.UpsertWebhook(EventID, EventType, RawJson)
 */
async function upsertWebhookEvent(eventId, eventType, rawJson) {
    const pool = await db_1.poolPromise;
    await pool
        .request()
        .input("EventID", mssql_1.default.NVarChar(200), eventId)
        .input("EventType", mssql_1.default.NVarChar(100), eventType)
        .input("RawJson", mssql_1.default.NVarChar(mssql_1.default.MAX), rawJson)
        .execute("Payments.UpsertWebhook");
    await logSystem("Info", `Payments.UpsertWebhook ok eventId=${eventId} type=${eventType}`);
}
/**
 * Resolve Intent by Gateway Transaction ID
 * SP: Payments.ResolveIntentByGatewayTxnID(@GatewayTxnID) -> recordset with PaymentIntentID
 */
async function resolveIntentByGatewayTxnID(gatewayTxnId) {
    const pool = await db_1.poolPromise;
    const r = await pool
        .request()
        .input("GatewayTxnID", mssql_1.default.NVarChar(100), gatewayTxnId)
        .execute("Payments.ResolveIntentByGatewayTxnID");
    const row = r.recordset?.[0];
    const intentId = row?.PaymentIntentID;
    return intentId ?? null;
}
/**
 * Resolve active provider + secrets for a PaymentModule instance:
 * - Reads ModuleSetting: 'payments.defaultProviderId'
 * - Then loads ProviderSecret for that ProviderID
 */
async function resolveActiveProviderForModule(portalPageModuleId, roleId) {
    const setting = await getModuleSettingByKey(portalPageModuleId, "payments.defaultProviderId", roleId ?? null);
    const providerId = (setting?.value ?? "").trim();
    if (!providerId) {
        await logSystem("Error", `resolveActiveProviderForModule: missing payments.defaultProviderId for PPM=${portalPageModuleId}`);
        return null;
    }
    const secret = await getProviderSecret(providerId);
    if (!secret) {
        await logSystem("Error", `resolveActiveProviderForModule: secrets not found for ProviderID=${providerId}`);
        return null;
    }
    return { providerId, secret };
}
