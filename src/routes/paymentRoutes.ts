// ================================================
// ✅ Route: /api/payments (Authorize.Net facade)
// Description: Hosted token, status poll, webhook (HMAC)
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: routes/paymentRoutes.ts
// ================================================
import { Router, Request, Response } from "express";
import authenticateAPI from "../middleware/authenticateAPI";
import { AuthorizeNetProvider } from "../services/payments/authorizeNetProvider";
import { logger } from "../utils/logger";
import { authorizeNetRaw } from "../middleware/authorizeNetRaw";

const router = Router();
const provider = new AuthorizeNetProvider();

// Create hosted payment token
router.post(
  "/authorizeNet/create-hosted-payment",
  authenticateAPI,
  async (req: Request, res: Response) => {
    try {
      const out = await provider.createHostedPayment(req.body);
      logger.info("Hosted payment token issued", {
        paymentIntentId: out.paymentIntentId,
        mode: out.mode,
      });
      res.json(out);
    } catch (e: any) {
      logger.error("Hosted payment token failed", {
        err: e.message,
        body: req.body,
      });
      res.status(500).json({ error: e.message });
    }
  }
);

// Poll status
router.get(
  "/authorizeNet/intent/:id/status",
  authenticateAPI,
  async (req: Request, res: Response) => {
    try {
      const out = await provider.getIntentStatus(req.params.id);
      res.json(out);
    } catch (e: any) {
      logger.error("Get intent status failed", {
        err: e.message,
        id: req.params.id,
      });
      res.status(404).json({ error: e.message });
    }
  }
);

// Webhook (HMAC only, raw body)
router.post(
  "/authorizeNet/webhook",
  authorizeNetRaw,
  async (req: Request, res: Response) => {
    try {
      const sig = req.get("X-ANET-Signature") || "";
      // req.body is a Buffer because of express.raw
      await provider.processWebhook((req.body as Buffer).toString("utf8"), sig);
      res.sendStatus(200);
    } catch (e: any) {
      logger.error("Webhook processing failed", { err: e.message });
      res.sendStatus(400);
    }
  }
);

export default router;
