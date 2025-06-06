"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const userModel_1 = __importDefault(require("../services/userModel"));
const authModel_1 = __importDefault(require("../services/authModel"));
const { getUserRoles, validateUserByEmail, createUser } = userModel_1.default;
const { hashPassword, comparePasswords, generateToken } = authModel_1.default;
/**
 * ✅ Handles user registration
 */
const signup = async (req, res) => {
    try {
        const { username, email, password } = req.body;
        if (!username || !email || !password) {
            return res
                .status(400)
                .json({ error: "Username, email, and password are required." });
        }
        const existingUser = await validateUserByEmail(email);
        if (existingUser) {
            return res.status(409).json({ error: "Email already registered." });
        }
        const hashedPassword = await hashPassword(password);
        const userId = await createUser(username, email, hashedPassword);
        res.status(201).json({ message: "User registered successfully", userId });
    }
    catch (error) {
        console.error("❌ Signup Error:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
};
/**
 * ✅ Handles user authentication
 */
const login = async (req, res) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            return res
                .status(400)
                .json({ error: "Email and password are required." });
        }
        const user = await validateUserByEmail(email);
        if (!user) {
            return res.status(401).json({ error: "Invalid email or password" });
        }
        const isMatch = await comparePasswords(password, user.PasswordHash);
        if (!isMatch) {
            return res.status(401).json({ error: "Invalid email or password" });
        }
        const userRoles = await getUserRoles(user.Id);
        const token = generateToken(user.Id, userRoles);
        res.json({ message: "Login successful", token, roles: userRoles });
    }
    catch (error) {
        console.error("❌ Login Error:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
};
const authController = {
    signup,
    login,
};
exports.default = authController;
