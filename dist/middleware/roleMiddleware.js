"use strict";
// ================================================
// ✅ Middleware: roleMiddleware
// Description: Authorizes authenticated users by role
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: middleware/roleMiddleware.ts
// ================================================
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const userModel_1 = __importDefault(require("../services/userModel"));
const { getUserRoles } = userModel_1.default;
// 🔐 Check Role Middleware
const checkRole = (requiredRoles) => {
    return async (req, res, next) => {
        try {
            const userId = req.user?.id;
            if (!userId) {
                return res
                    .status(403)
                    .json({ error: "Access denied. No user found in request." });
            }
            const rolesRequired = Array.isArray(requiredRoles)
                ? requiredRoles
                : [requiredRoles];
            console.log("🔍 Checking roles for user:", userId);
            const userRoles = await getUserRoles(userId);
            console.log("✅ User Roles:", userRoles);
            const hasRole = userRoles.some((role) => rolesRequired.includes(role));
            if (!hasRole) {
                return res
                    .status(403)
                    .json({ error: "Access denied. You do not have the required role." });
            }
            next();
        }
        catch (error) {
            console.error("❌ Role Middleware Error:", error.message || error);
            res.status(500).json({ error: "Internal server error." });
        }
    };
};
// ✅ Export as module object for consistency
const roleMiddleware = {
    checkRole,
};
exports.default = roleMiddleware;
