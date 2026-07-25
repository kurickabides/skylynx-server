"use strict";
// ================================================
// ✅ Middleware: authorizeNetRaw
// Description: Captures raw Authorize.Net webhook bodies for HMAC verification
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: middleware/authorizeNetRaw.ts
// ================================================
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.authorizeNetRaw = void 0;
const express_1 = __importDefault(require("express"));
// For HMAC signature verification
exports.authorizeNetRaw = express_1.default.raw({ type: "*/*" });
