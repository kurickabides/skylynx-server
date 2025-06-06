"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const db_1 = require("../config/db");
const JWT_SECRET = process.env.JWT_SECRET || "your_jwt_secret";
// 🔐 Token Authentication Middleware
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
// 🔐 Role Authorization Middleware
const authorize = (requiredRoles) => {
    return async (req, res, next) => {
        try {
            if (!req.user?.id) {
                return res
                    .status(403)
                    .json({ error: "Access denied. No user found in request." });
            }
            const userId = req.user.id;
            const pool = await db_1.poolPromise;
            const result = await pool.request().input("UserId", db_1.sql.NVarChar, userId)
                .query(`
          SELECT r.Name FROM AspNetUserRoles ur 
          JOIN AspNetRoles r ON ur.RoleId = r.Id 
          WHERE ur.UserId = @UserId
        `);
            const userRoles = result.recordset.map((row) => row.Name);
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
// ✅ Export as a named module
const authMiddleware = {
    authenticate,
    authorize,
};
exports.default = authMiddleware;
