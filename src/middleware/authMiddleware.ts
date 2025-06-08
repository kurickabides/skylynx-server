import jwt from "jsonwebtoken";
import { Response, NextFunction } from "express";
import { poolPromise, sql } from "../config/db";
import { AuthenticatedRequest } from "./types";

const JWT_SECRET = process.env.JWT_SECRET || "NULL";

// 🔐 Token Authentication Middleware
const authenticate = (
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction
) => {
  const token = req.header("Authorization");

  if (!token) {
    return res.status(401).json({ error: "Access denied. No token provided." });
  }

  try {
    const decoded = jwt.verify(token.replace("Bearer ", ""), JWT_SECRET);
    req.user = decoded as AuthenticatedRequest["user"];
    next();
  } catch (err) {
    res.status(401).json({ error: "Invalid token." });
  }
};

// 🔐 Role Authorization Middleware
const authorize = (requiredRoles: string[] | string) => {
  return async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ) => {
    try {
      if (!req.user?.id) {
        return res
          .status(403)
          .json({ error: "Access denied. No user found in request." });
      }

      const userId = req.user.id;
      const pool = await poolPromise;

      const result = await pool.request().input("UserId", sql.NVarChar, userId)
        .query(`
          SELECT r.Name FROM AspNetUserRoles ur 
          JOIN AspNetRoles r ON ur.RoleId = r.Id 
          WHERE ur.UserId = @UserId
        `);

      const userRoles = result.recordset.map((row: any) => row.Name);
      const required = Array.isArray(requiredRoles)
        ? requiredRoles
        : [requiredRoles];

      const hasRole = userRoles.some((role: string) => required.includes(role));

      if (!hasRole) {
        return res
          .status(403)
          .json({ error: "Access denied. Insufficient role." });
      }

      next();
    } catch (error: any) {
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

export default authMiddleware;
