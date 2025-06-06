"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const userModel_1 = __importDefault(require("../services/userModel"));
const { getUserRoles } = userModel_1.default;
const checkPortalRoles = (requiredRoles) => {
    return async (req, res, next) => {
        try {
            const userId = req.user?.id;
            if (!userId) {
                return res
                    .status(403)
                    .json({ error: "Access denied. No user found in request." });
            }
            const normalizedRoles = Array.isArray(requiredRoles)
                ? requiredRoles
                : [requiredRoles];
            console.log("🔍 Checking portal roles for user:", userId);
            const userRoles = await getUserRoles(userId);
            console.log("✅ Portal User Roles:", userRoles);
            const hasAccess = userRoles.some((role) => normalizedRoles.includes(role));
            if (!hasAccess) {
                return res.status(403).json({
                    error: "Access denied. You do not have the required portal role.",
                });
            }
            next();
        }
        catch (error) {
            console.error("❌ PortalMiddleware Error:", error.message || error);
            res.status(500).json({ error: "Internal server error." });
        }
    };
};
const portalMiddleware = {
    checkPortalRoles,
};
exports.default = portalMiddleware;
