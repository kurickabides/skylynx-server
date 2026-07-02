// ================================================
// ✅ Entity: Payment Types
// Description: Strong types for payment facade and intents/txns
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: services/payments/types.ts
// ================================================
export type PaymentMode = "sandbox" | "production";

export interface PaymentCreateIntentInput {
  portalId: string;
  userId: string;
  amount: number; // e.g., 49.99
  currency?: "USD"; // keep tight; expand later
  clientRef?: string; // external reference for idempotency/audit
  providerId: string; // DB Provider row (maps to sandbox/prod)
}

export interface HostedPaymentToken {
  token: string;
  iframeUrl: string;
  paymentIntentId: string;
  mode: PaymentMode;
}

export type PaymentIntentStatus =
  | "Pending"
  | "Authorized"
  | "Captured"
  | "Failed"
  | "Voided"
  | "Refunded";

export interface PaymentIntentStatusResult {
  paymentIntentId: string;
  status: PaymentIntentStatus;
  amount: number;
  currency: string;
  lastUpdatedUtc: string;
}

export interface WebhookProcessResult {
  ok: boolean;
}

export interface PaymentProviderSecrets {
  apiLoginId: string;
  transactionKey: string;
  signatureKeyHex: string;
  mode: PaymentMode;
  hostedPaymentBaseUrl: string; // iframe base url
  apiBaseUrl: string; // REST endpoint url
}
