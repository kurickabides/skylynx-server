// ================================================
// ✅ Middleware: authorizeNetRaw
// Description: Captures raw Authorize.Net webhook bodies for HMAC verification
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: middleware/authorizeNetRaw.ts
// ================================================

import express from "express";

// For HMAC signature verification
export const authorizeNetRaw = express.raw({ type: "*/*" });
