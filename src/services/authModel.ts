// ================================================
// ✅ Service: authModel
// Description: Handles password hashing, password comparison, and JWT generation
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: services/authModel.ts
// ================================================

import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";

const JWT_SECRET = process.env.JWT_SECRET || "changeme";

const hashPassword = async (password: string): Promise<string> => {
  return bcrypt.hash(password, 10);
};

const comparePasswords = async (
  plain: string,
  hash: string
): Promise<boolean> => {
  return bcrypt.compare(plain, hash);
};

const generateToken = (userId: string, roles: string[]): string => {
  return jwt.sign({ id: userId, roles }, JWT_SECRET, { expiresIn: "1h" });
};

// ✅ Export as object for consistent usage across modules
const authModel = {
  hashPassword,
  comparePasswords,
  generateToken,
};

export default authModel;
