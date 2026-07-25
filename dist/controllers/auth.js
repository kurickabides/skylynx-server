"use strict";
// ================================================
// ✅ Controller: authController
// Description: Handles user signup and login requests
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: controllers/auth.ts
// ================================================
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const authModel_1 = __importDefault(require("../services/authModel"));
const userModel_1 = __importDefault(require("../services/userModel"));
const { hashPassword, comparePasswords, generateToken } = authModel_1.default;
const { createUserSignUp } = userModel_1.default;
const signup = async (req, res) => {
    try {
        const { username, email, password, profileFields = [], } = req.body;
        if (!username || !email || !password) {
            return res
                .status(400)
                .json({ error: "Username, email, and password are required." });
        }
        const hashedPassword = await hashPassword(password);
        const userId = await createUserSignUp("SkyLynxLIVE", // PortalName
        null, // ProviderName (optional)
        username, email, hashedPassword, profileFields);
        return res.status(201).json({
            message: "User registered successfully",
            userId,
        });
    }
    catch (error) {
        console.error("❌ Signup Error:", error);
        return res.status(500).json({ error: "Internal Server Error" });
    }
};
const login = async (req, res) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            return res
                .status(400)
                .json({ error: "Email and password are required." });
        }
        const user = await userModel_1.default.validateUserByEmail(email);
        if (!user) {
            return res.status(401).json({ error: "Invalid email or password" });
        }
        const isMatch = await comparePasswords(password, user.PasswordHash);
        if (!isMatch) {
            return res.status(401).json({ error: "Invalid email or password" });
        }
        const userRoles = await userModel_1.default.getUserRoles(user.Id);
        const token = generateToken(user.Id, userRoles);
        return res.json({ message: "Login successful", token, roles: userRoles });
    }
    catch (error) {
        console.error("❌ Login Error:", error);
        return res.status(500).json({ error: "Internal Server Error" });
    }
};
const authController = {
    signup,
    login,
};
exports.default = authController;
