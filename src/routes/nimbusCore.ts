// ================================================
// ✅ File: routes/nimbusRoutes.ts
// Description: Express routes for NimbusCore form loading
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// ================================================

import express from "express";
import { loadFormHandler } from "../controllers/nimbusCore";

const router = express.Router();

// POST /api/nimbus/loadform
router.post("/forms/loadform", loadFormHandler);

export default router;
