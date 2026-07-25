"use strict";
// ================================================
// ✅ Controller: serverAuthController
// Description: Handles local server admin setup, login, and session status
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: controllers/serverAuth.ts
// ================================================
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const serverAdminService_1 = __importDefault(require("../services/serverAdminService"));
const status = (_req, res) => {
    const { configured } = serverAdminService_1.default.getStatus();
    res.json({ configured });
};
const setup = async (req, res) => {
    try {
        const { username, password } = req.body;
        const result = await serverAdminService_1.default.setup(username, password);
        res.status(201).json(result);
    }
    catch (error) {
        const message = error.message || "Failed to configure server admin.";
        const statusCode = message.includes("already configured") ? 409 : 400;
        res.status(statusCode).json({ error: message });
    }
};
const login = async (req, res) => {
    try {
        const { username, password } = req.body;
        const result = await serverAdminService_1.default.login(username, password);
        res.json(result);
    }
    catch {
        res.status(401).json({ error: "Invalid server admin credentials." });
    }
};
const me = (req, res) => {
    res.json({ admin: req.serverAdmin });
};
exports.default = {
    status,
    setup,
    login,
    me,
};
