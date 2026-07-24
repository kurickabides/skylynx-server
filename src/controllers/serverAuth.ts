// ================================================
// ✅ Controller: serverAuthController
// Description: Handles local server admin setup, login, and session status
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: controllers/serverAuth.ts
// ================================================

import { Request, Response } from "express";
import serverAdminService from "../services/serverAdminService";
import { ServerAdminRequest } from "../middleware/serverAdminMiddleware";

const status = (_req: Request, res: Response) => {
  const { configured } = serverAdminService.getStatus();
  res.json({ configured });
};

const setup = async (req: Request, res: Response) => {
  try {
    const { username, password } = req.body;
    const result = await serverAdminService.setup(username, password);
    res.status(201).json(result);
  } catch (error: any) {
    const message = error.message || "Failed to configure server admin.";
    const statusCode = message.includes("already configured") ? 409 : 400;
    res.status(statusCode).json({ error: message });
  }
};

const login = async (req: Request, res: Response) => {
  try {
    const { username, password } = req.body;
    const result = await serverAdminService.login(username, password);
    res.json(result);
  } catch {
    res.status(401).json({ error: "Invalid server admin credentials." });
  }
};

const me = (req: ServerAdminRequest, res: Response) => {
  res.json({ admin: req.serverAdmin });
};

export default {
  status,
  setup,
  login,
  me,
};
