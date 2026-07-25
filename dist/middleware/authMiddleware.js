"use strict";
// ================================================
// ✅ Middleware: authMiddleware
// Description: Validates JWTs and authorizes role-based access
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: middleware/authMiddleware.ts
// ================================================
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const userModel_1 = __importDefault(require("../services/userModel"));
const JWT_SECRET = process.env.JWT_SECRET || "NULL";
/**
 * ✅ JWT Authentication Middleware
 */
const authenticate = (req, res, next) => {
    const token = req.header("Authorization");
    if (!token) {
        return res.status(401).json({ error: "Access denied. No token provided." });
    }
    try {
        const decoded = jsonwebtoken_1.default.verify(token.replace("Bearer ", ""), JWT_SECRET);
        req.user = decoded;
        next();
    }
    catch (err) {
        res.status(401).json({ error: "Invalid token." });
    }
};
/**
 * ✅ Role Authorization Middleware using GetUserRoles SP
 */
const authorize = (requiredRoles) => {
    return async (req, res, next) => {
        try {
            if (!req.user?.id) {
                return res
                    .status(403)
                    .json({ error: "Access denied. No user found in request." });
            }
            const userRoles = await userModel_1.default.getUserRoles(req.user.id);
            const required = Array.isArray(requiredRoles)
                ? requiredRoles
                : [requiredRoles];
            const hasRole = userRoles.some((role) => required.includes(role));
            if (!hasRole) {
                return res
                    .status(403)
                    .json({ error: "Access denied. Insufficient role." });
            }
            next();
        }
        catch (error) {
            console.error("❌ Authorization Error:", error.message || error);
            res.status(500).json({ error: "Internal server error." });
        }
    };
};
const authMiddleware = {
    authenticate,
    authorize,
};
exports.default = authMiddleware;
