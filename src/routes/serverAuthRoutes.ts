// ================================================
// ✅ Route: serverAuthRoutes
// Description: Local server admin authentication endpoints
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: routes/serverAuthRoutes.ts
// ================================================

import express from "express";
import serverAuthController from "../controllers/serverAuth";
import { authenticateServerAdmin } from "../middleware/serverAdminMiddleware";

const router = express.Router();

router.get("/status", serverAuthController.status);
router.post("/setup", serverAuthController.setup);
router.post("/login", serverAuthController.login);
router.get("/me", authenticateServerAdmin, serverAuthController.me);

export default router;
