import { Request, Response } from "express";
import userModel from "../services/userModel";
import authModel from "../services/authModel";

const { getUserRoles, validateUserByEmail, createUser } = userModel;
const { hashPassword, comparePasswords, generateToken } = authModel;

/**
 * ✅ Handles user registration
 */
const signup = async (req: Request, res: Response) => {
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
  } catch (error) {
    console.error("❌ Signup Error:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

/**
 * ✅ Handles user authentication
 */
const login = async (req: Request, res: Response) => {
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
  } catch (error) {
    console.error("❌ Login Error:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

const authController = {
  signup,
  login,
};

export default authController;
