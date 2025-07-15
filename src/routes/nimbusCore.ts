// ================================================
// ✅ File: routes/nimbusRoutes.ts
// Description: Express routes for NimbusCore template & form loading
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// ================================================

import express from "express";
import {
  loadFormHandler,
  loadPortalTemplateTreeHandler,
  getAllProtosTargetTypesHandler,
} from "../controllers/nimbusCore";

const router = express.Router();

// POST /api/nimbus/forms/loadform
router.post("/forms/loadform", loadFormHandler);

// GET /api/nimbus/templates/portals
router.get("/templates/portals", loadPortalTemplateTreeHandler);

router.get("/templates/types", getAllProtosTargetTypesHandler);

export default router;
