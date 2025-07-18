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
  getTargetByIdHandler,
} from "../controllers/nimbusCore";
import authMiddleware from "../middleware/authMiddleware";
//this should just use apiKey for auth uless admin is needed then use authMiddleware
const router = express.Router();

// POST /api/nimbus/forms/loadform
router.post("/forms/loadform", loadFormHandler);

// GET /api/nimbus/templates/portals
router.get("/templates/portals", loadPortalTemplateTreeHandler);

router.get("/templates/types", getAllProtosTargetTypesHandler);

//TemplatesTargets Route 
// ✅ Dynamic Target Resolver Route
router.get("/templates/targets/:type/:id", getTargetByIdHandler);


export default router;
