// ================================================
// ✅ Route: authRoutes
// Description: User authentication endpoints
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: routes/authRoutes.ts
// ================================================

import express from "express";
import authController from "../controllers/auth";

const router = express.Router();

// Debugging - Log route loading
console.log("✅ Auth Routes Loaded");

// Define Routes
router.post("/signup", authController.signup);
router.post("/login", authController.login);

export default router;
