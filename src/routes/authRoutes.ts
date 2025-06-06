import express from "express";
import authController from "../controllers/auth";

const router = express.Router();

// Debugging - Log route loading
console.log("✅ Auth Routes Loaded");

// Define Routes
router.post("/signup", authController.signup);
router.post("/login", authController.login);

export default router;
