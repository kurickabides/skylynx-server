import { Response, NextFunction } from "express";
import { AuthenticatedRequest } from "./types";
import userModel from "../services/userModel";

const { getUserRoles } = userModel;

const checkPortalRoles = (requiredRoles: string[] | string) => {
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

      const normalizedRoles = Array.isArray(requiredRoles)
        ? requiredRoles
        : [requiredRoles];

      console.log("🔍 Checking portal roles for user:", userId);
      const userRoles = await getUserRoles(userId);
      console.log("✅ Portal User Roles:", userRoles);

      const hasAccess = userRoles.some((role) =>
        normalizedRoles.includes(role)
      );

      if (!hasAccess) {
        return res.status(403).json({
          error: "Access denied. You do not have the required portal role.",
        });
      }

      next();
    } catch (error: any) {
      console.error("❌ PortalMiddleware Error:", error.message || error);
      res.status(500).json({ error: "Internal server error." });
    }
  };
};

const portalMiddleware = {
  checkPortalRoles,
};

export default portalMiddleware;
