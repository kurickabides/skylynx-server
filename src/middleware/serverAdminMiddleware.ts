// ================================================
// ✅ Middleware: serverAdminMiddleware
// Description: Authenticates local server admin bearer tokens
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: middleware/serverAdminMiddleware.ts
// ================================================

import { Request, Response, NextFunction } from "express";
import serverAdminService, {
  ServerAdminTokenPayload,
} from "../services/serverAdminService";

export interface ServerAdminRequest extends Request {
  serverAdmin?: ServerAdminTokenPayload;
}

export function authenticateServerAdmin(
  req: ServerAdminRequest,
  res: Response,
  next: NextFunction
) {
  const authHeader = req.header("Authorization");
  if (!authHeader) {
    return res.status(401).json({ error: "Missing server admin token." });
  }

  try {
    const token = authHeader.replace("Bearer ", "");
    const payload = serverAdminService.verifyToken(token);
    if (!payload.roles?.includes("SERVER_ADMIN")) {
      return res.status(403).json({ error: "Server admin role required." });
    }
    req.serverAdmin = payload;
    next();
  } catch {
    return res.status(401).json({ error: "Invalid server admin token." });
  }
}
