// ================================================
// ✅ Middleware: roleMiddleware
// Description: Authorizes authenticated users by role
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: middleware/roleMiddleware.ts
// ================================================

  import { Request, Response, NextFunction } from "express";
  import userModel from "../services/userModel";
  import { AuthenticatedRequest } from "./types";

  const { getUserRoles } = userModel;

  // 🔐 Check Role Middleware
  const checkRole = (requiredRoles: string[] | string) => {
    return async (
      req: AuthenticatedRequest,
      res: Response,
      next: NextFunction
    ) => {
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
      } catch (error: any) {
        console.error("❌ Role Middleware Error:", error.message || error);
        res.status(500).json({ error: "Internal server error." });
      }
    };
  };

  // ✅ Export as module object for consistency
  const roleMiddleware = {
    checkRole,
  };

  export default roleMiddleware;
