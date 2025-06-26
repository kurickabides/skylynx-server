// ================================================
// ✅ Route: dyformRoutes
// Description: DyForm ViewModel endpoints
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: dyformRoutes.ts
// ================================================

import express from "express";
import { getDyFormViewModel } from "../controllers/dyformController";

const router = express.Router();

// Route: GET /api/dyform/viewmodel/:viewModelName
router.get("/viewmodel/:viewModelName", getDyFormViewModel);

export default router;
