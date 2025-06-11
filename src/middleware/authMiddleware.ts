import jwt from "jsonwebtoken";
import { Response, NextFunction } from "express";
import { AuthenticatedRequest } from "./types";
import userModel from "../services/userModel";

const JWT_SECRET = process.env.JWT_SECRET || "NULL";

/**
 * ✅ JWT Authentication Middleware
 */
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

/**
 * ✅ Role Authorization Middleware using GetUserRoles SP
 */
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

      const userRoles = await userModel.getUserRoles(req.user.id);
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

const authMiddleware = {
  authenticate,
  authorize,
};

export default authMiddleware;
