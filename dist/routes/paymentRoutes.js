"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
// ================================================
// ✅ Route: /api/payments (Authorize.Net facade)
// Description: Hosted token, status poll, webhook (HMAC)
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: routes/paymentRoutes.ts
// ================================================
const express_1 = require("express");
const authenticateAPI_1 = __importDefault(require("../middleware/authenticateAPI"));
const authorizeNetProvider_1 = require("../services/payments/authorizeNetProvider");
const logger_1 = require("../utils/logger");
const authorizeNetRaw_1 = require("../middleware/authorizeNetRaw");
const router = (0, express_1.Router)();
const provider = new authorizeNetProvider_1.AuthorizeNetProvider();
// Create hosted payment token
router.post("/authorizeNet/create-hosted-payment", authenticateAPI_1.default, async (req, res) => {
    try {
        const out = await provider.createHostedPayment(req.body);
        logger_1.logger.info("Hosted payment token issued", {
            paymentIntentId: out.paymentIntentId,
            mode: out.mode,
        });
        res.json(out);
    }
    catch (e) {
        logger_1.logger.error("Hosted payment token failed", {
            err: e.message,
            body: req.body,
        });
        res.status(500).json({ error: e.message });
    }
});
// Poll status
router.get("/authorizeNet/intent/:id/status", authenticateAPI_1.default, async (req, res) => {
    try {
        const out = await provider.getIntentStatus(req.params.id);
        res.json(out);
    }
    catch (e) {
        logger_1.logger.error("Get intent status failed", {
            err: e.message,
            id: req.params.id,
        });
        res.status(404).json({ error: e.message });
    }
});
// Webhook (HMAC only, raw body)
router.post("/authorizeNet/webhook", authorizeNetRaw_1.authorizeNetRaw, async (req, res) => {
    try {
        const sig = req.get("X-ANET-Signature") || "";
        // req.body is a Buffer because of express.raw
        await provider.processWebhook(req.body.toString("utf8"), sig);
        res.sendStatus(200);
    }
    catch (e) {
        logger_1.logger.error("Webhook processing failed", { err: e.message });
        res.sendStatus(400);
    }
});
exports.default = router;
