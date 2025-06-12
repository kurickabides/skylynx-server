import { Request, Response } from "express";
import authModel from "../services/authModel";
import userModel from "../services/userModel";
import {ProfileField} from "./types";

import { types } from "util";
const { hashPassword, comparePasswords, generateToken } = authModel;
const { createUserSignUp } = userModel;

const signup = async (req: Request, res: Response) => {
  try {
    const {
      username,
      email,
      password,
      profileFields = [],
    }: {
      username: string;
      email: string;
      password: string;
      profileFields: ProfileField[];
    } = req.body;

    if (!username || !email || !password) {
      return res
        .status(400)
        .json({ error: "Username, email, and password are required." });
    }

    const hashedPassword = await hashPassword(password);

    const userId = await createUserSignUp(
      "SkyLynxNet", // PortalName
      null, // ProviderName (optional)
      username,
      email,
      hashedPassword,
      profileFields
    );

    return res.status(201).json({
      message: "User registered successfully",
      userId,
    });
  } catch (error) {
    console.error("❌ Signup Error:", error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};


const login = async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res
        .status(400)
        .json({ error: "Email and password are required." });
    }

    const user = await userModel.validateUserByEmail(email);
    if (!user) {
      return res.status(401).json({ error: "Invalid email or password" });
    }

    const isMatch = await comparePasswords(password, user.PasswordHash);
    if (!isMatch) {
      return res.status(401).json({ error: "Invalid email or password" });
    }

    const userRoles = await userModel.getUserRoles(user.Id);
    const token = generateToken(user.Id, userRoles);

    return res.json({ message: "Login successful", token, roles: userRoles });
  } catch (error) {
    console.error("❌ Login Error:", error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};

const authController = {
  signup,
  login,
};

export default authController;
