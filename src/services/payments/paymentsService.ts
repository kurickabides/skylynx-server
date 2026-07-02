// ================================================
// ✅ Service: paymentsService
// Description: SP-first service for Payments schema (no SDK yet)
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: services/payments/paymentsService.ts
// ================================================

import sql from "mssql";
import { poolPromise } from "../../config/db";

// Strong types (kept in services/payments/types.ts)
import {
  PaymentCreateIntentInput,
  PaymentProviderSecrets,
  PaymentMode,
} from "./types";

// ---- Local helpers / internal DB row types -------------------------
type Guid = string;

/**
 * Shape expected from Payments.GetProviderSecret
 * (Encrypted values are returned; decrypt at the provider layer later if needed.)
 */
interface ProviderSecretRow {
  ProviderID: Guid;
  ApiLoginID_enc: string;
  TransactionKey_enc: string;
  SignatureKeyHex_enc: string;
  Mode: PaymentMode; // 'sandbox' | 'production'
  UpdatedAt: Date;
}

const as3 = (c?: string) => (c || "USD").trim().toUpperCase().slice(0, 3);

/** Logs to SystemLogs (table write; consider wrapper SP later) */
async function logSystem(level: "Info" | "Warning" | "Error", message: string) {
  const pool = await poolPromise;
  await pool
    .request()
    .input("LogType", sql.NVarChar(50), level)
    .input("LogMessage", sql.NVarChar(sql.MAX), message)
    .query(
      `INSERT INTO dbo.SystemLogs (LogID, LogType, LogMessage, CreatedAt)
       VALUES (NEWID(), @LogType, @LogMessage, GETDATE());`
    );
}

// Given DB mode, derive ANet base URLs we’ll need later
function deriveAnetBaseUrls(
  mode: PaymentMode
): Pick<PaymentProviderSecrets, "hostedPaymentBaseUrl" | "apiBaseUrl"> {
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
function mapToProviderSecrets(row: ProviderSecretRow): PaymentProviderSecrets {
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
export async function getModuleSettingByKey(
  portalPageModuleId: Guid,
  keyName: string,
  roleId?: string | null
): Promise<{
  keyName: string;
  value: string | null;
  roleId: string | null;
  updatedAt: string | null;
} | null> {
  const pool = await poolPromise;
  const req = pool.request();
  req.input("PortalPageModuleID", sql.UniqueIdentifier, portalPageModuleId);
  req.input("KeyName", sql.NVarChar(100), keyName);
  if (roleId) req.input("RoleID", sql.NVarChar(128), roleId);

  const result = await req.execute("dbo.GetModuleSettingByKey");
  const row = result.recordset?.[0];
  if (!row) return null;

  return {
    keyName: row.KeyName ?? keyName,
    value: row.Value ?? null,
    roleId: row.RoleID ?? null,
    updatedAt: row.UpdatedAt ? new Date(row.UpdatedAt).toISOString() : null,
  };
}

/** Upsert a single module setting by KeyName (SP-first) */
export async function upsertModuleSetting(
  portalPageModuleId: Guid,
  keyName: string,
  roleId: string,
  value: string
): Promise<void> {
  const pool = await poolPromise;
  await pool
    .request()
    .input("PortalPageModuleID", sql.UniqueIdentifier, portalPageModuleId)
    .input("KeyName", sql.NVarChar(100), keyName)
    .input("RoleID", sql.NVarChar(128), roleId)
    .input("Value", sql.NVarChar(sql.MAX), value)
    .execute("dbo.UpsertModuleSetting");
}

/** Fetch provider secrets (encrypted) for a ProviderID */
export async function getProviderSecret(
  providerId: Guid
): Promise<PaymentProviderSecrets | null> {
  const pool = await poolPromise;
  const result = await pool
    .request()
    .input("ProviderID", sql.UniqueIdentifier, providerId)
    .execute("Payments.GetProviderSecret");

  const row = result.recordset?.[0] as ProviderSecretRow | undefined;
  if (!row) return null;

  return mapToProviderSecrets(row);
}

/** Create an Intent and return its GUID (NEWID() inside SP) */
export async function createIntent(
  input: PaymentCreateIntentInput
): Promise<Guid> {
  const pool = await poolPromise;
  const req = pool.request();

  // NOTE: Intent.UserID is UNIQUEIDENTIFIER in Payments schema.
  // Your AspNetUsers.Id is NVARCHAR(128). If you need a FK later, we’ll align types.
  const currency3 = as3(input.currency);
  const status = "Pending";

  req.output("PaymentIntentID", sql.UniqueIdentifier);
  req.input("ProviderID", sql.UniqueIdentifier, input.providerId);
  req.input("PortalID", sql.UniqueIdentifier, input.portalId);
  req.input("UserID", sql.UniqueIdentifier, input.userId);
  req.input("Amount", sql.Decimal(18, 2), input.amount);
  req.input("Currency", sql.Char(3), currency3);
  req.input("ClientRef", sql.NVarChar(100), input.clientRef ?? null);
  req.input("Status", sql.NVarChar(20), status);

  const result = await req.execute("Payments.CreateIntent");
  const intentId: Guid = result.output.PaymentIntentID as string;

  await logSystem(
    "Info",
    `Payments.CreateIntent ok intentId=${intentId} provider=${input.providerId} amount=${input.amount} ${currency3}`
  );
  return intentId;
}

/** Link a domain object to an intent (pre/post transaction) */
export async function addTargetLink(
  paymentIntentId: Guid,
  targetDomain: string,
  targetId: Guid
): Promise<void> {
  const pool = await poolPromise;
  await pool
    .request()
    .input("PaymentIntentID", sql.UniqueIdentifier, paymentIntentId)
    .input("TargetDomain", sql.NVarChar(50), targetDomain)
    .input("TargetID", sql.UniqueIdentifier, targetId)
    .execute("Payments.AddTargetLink");

  await logSystem(
    "Info",
    `Payments.AddTargetLink ok intentId=${paymentIntentId} domain=${targetDomain} targetId=${targetId}`
  );
}

/** Update intent status via SP */
export async function updateIntentStatus(
  paymentIntentId: Guid,
  status:
    | "Pending"
    | "Authorized"
    | "Captured"
    | "Failed"
    | "Voided"
    | "Refunded"
): Promise<void> {
  const pool = await poolPromise;
  await pool
    .request()
    .input("PaymentIntentID", sql.UniqueIdentifier, paymentIntentId)
    .input("Status", sql.NVarChar(20), status)
    .execute("Payments.UpdateIntentStatus");

  await logSystem(
    "Info",
    `Payments.UpdateIntentStatus ok intentId=${paymentIntentId} status=${status}`
  );
}

/**
 * Record a transaction row for an intent (stores response metadata/json).
 * Returns the generated PaymentTxnID (NEWID() inside SP).
 */
export async function recordTxn(args: {
  intentId: Guid;
  txnType: "AuthOnly" | "AuthCapture" | "Void" | "Refund" | "TokenIssued";
  gatewayTxnId?: string;
  authCode?: string;
  resultCode?: string;
  rawJson?: string;
}): Promise<Guid> {
  const pool = await poolPromise;
  const req = pool.request();

  req.output("PaymentTxnID", sql.UniqueIdentifier);
  req.input("PaymentIntentID", sql.UniqueIdentifier, args.intentId);
  req.input("TxnType", sql.NVarChar(20), args.txnType);
  req.input("GatewayTxnID", sql.NVarChar(100), args.gatewayTxnId ?? null);
  req.input("AuthCode", sql.NVarChar(50), args.authCode ?? null);
  req.input("ResultCode", sql.NVarChar(50), args.resultCode ?? null);
  req.input("RawJson", sql.NVarChar(sql.MAX), args.rawJson ?? null);

  const result = await req.execute("Payments.RecordTxn");
  const txnId: Guid = result.output.PaymentTxnID as string;

  await logSystem(
    "Info",
    `Payments.RecordTxn ok intentId=${args.intentId} txnId=${txnId} type=${args.txnType}`
  );
  return txnId;
}

/** Read intent by ID */
export async function getIntentById(paymentIntentId: Guid) {
  const pool = await poolPromise;
  const result = await pool
    .request()
    .input("PaymentIntentID", sql.UniqueIdentifier, paymentIntentId)
    .execute("Payments.GetIntentById");
  return result.recordset?.[0] ?? null;
}

/** Read transactions for an intent */
export async function getTxnsByIntent(paymentIntentId: Guid) {
  const pool = await poolPromise;
  const result = await pool
    .request()
    .input("PaymentIntentID", sql.UniqueIdentifier, paymentIntentId)
    .execute("Payments.GetTxnsByIntent");
  return result.recordset ?? [];
}

/**
 * Webhook store (idempotent)
 * SP: Payments.UpsertWebhook(EventID, EventType, RawJson)
 */
export async function upsertWebhookEvent(
  eventId: string,
  eventType: string,
  rawJson: string
): Promise<void> {
  const pool = await poolPromise;
  await pool
    .request()
    .input("EventID", sql.NVarChar(200), eventId)
    .input("EventType", sql.NVarChar(100), eventType)
    .input("RawJson", sql.NVarChar(sql.MAX), rawJson)
    .execute("Payments.UpsertWebhook");

  await logSystem(
    "Info",
    `Payments.UpsertWebhook ok eventId=${eventId} type=${eventType}`
  );
}

/**
 * Resolve Intent by Gateway Transaction ID
 * SP: Payments.ResolveIntentByGatewayTxnID(@GatewayTxnID) -> recordset with PaymentIntentID
 */
export async function resolveIntentByGatewayTxnID(
  gatewayTxnId: string
): Promise<Guid | null> {
  const pool = await poolPromise;
  const r = await pool
    .request()
    .input("GatewayTxnID", sql.NVarChar(100), gatewayTxnId)
    .execute("Payments.ResolveIntentByGatewayTxnID");

  const row = r.recordset?.[0];
  const intentId: Guid | undefined = row?.PaymentIntentID;
  return intentId ?? null;
}

/**
 * Resolve active provider + secrets for a PaymentModule instance:
 * - Reads ModuleSetting: 'payments.defaultProviderId'
 * - Then loads ProviderSecret for that ProviderID
 */
export async function resolveActiveProviderForModule(
  portalPageModuleId: Guid,
  roleId?: string | null
): Promise<{ providerId: Guid; secret: PaymentProviderSecrets } | null> {
  const setting = await getModuleSettingByKey(
    portalPageModuleId,
    "payments.defaultProviderId",
    roleId ?? null
  );

  const providerId = (setting?.value ?? "").trim();
  if (!providerId) {
    await logSystem(
      "Error",
      `resolveActiveProviderForModule: missing payments.defaultProviderId for PPM=${portalPageModuleId}`
    );
    return null;
  }

  const secret = await getProviderSecret(providerId);
  if (!secret) {
    await logSystem(
      "Error",
      `resolveActiveProviderForModule: secrets not found for ProviderID=${providerId}`
    );
    return null;
  }

  return { providerId, secret };
}
