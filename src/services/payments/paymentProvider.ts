// ================================================
// ✅ Entity: PaymentProvider (Facade)
// Description: Provider-agnostic interface SkyLynx calls
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: services/payments/paymentProvider.ts
// ================================================
import {
  PaymentCreateIntentInput,
  HostedPaymentToken,
  PaymentIntentStatusResult,
  WebhookProcessResult,
} from "./types";

export interface PaymentProvider {
  createHostedPayment(
    input: PaymentCreateIntentInput
  ): Promise<HostedPaymentToken>;
  getIntentStatus(paymentIntentId: string): Promise<PaymentIntentStatusResult>;
  processWebhook(
    rawBody: string,
    signatureHeader: string
  ): Promise<WebhookProcessResult>;
}
