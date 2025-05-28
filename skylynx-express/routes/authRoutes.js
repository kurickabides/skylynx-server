const express = require("express");
const authController = require("../controllers/auth");

const router = express.Router();

// Debugging - Log route loading
console.log("✅ Auth Routes Loaded");

// Define Routes
router.post("/signup", authController.signup);
router.post("/login", authController.login);

module.exports = router;
