"use strict";
// ================================================
// ✅ Middleware: serverAdminMiddleware
// Description: Authenticates local server admin bearer tokens
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: middleware/serverAdminMiddleware.ts
// ================================================
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.authenticateServerAdmin = authenticateServerAdmin;
const serverAdminService_1 = __importDefault(require("../services/serverAdminService"));
function authenticateServerAdmin(req, res, next) {
    const authHeader = req.header("Authorization");
    if (!authHeader) {
        return res.status(401).json({ error: "Missing server admin token." });
    }
    try {
        const token = authHeader.replace("Bearer ", "");
        const payload = serverAdminService_1.default.verifyToken(token);
        if (!payload.roles?.includes("SERVER_ADMIN")) {
            return res.status(403).json({ error: "Server admin role required." });
        }
        req.serverAdmin = payload;
        next();
    }
    catch {
        return res.status(401).json({ error: "Invalid server admin token." });
    }
}
