"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const JWT_SECRET = process.env.JWT_SECRET || "changeme";
const hashPassword = async (password) => {
    return bcryptjs_1.default.hash(password, 10);
};
const comparePasswords = async (plain, hash) => {
    return bcryptjs_1.default.compare(plain, hash);
};
const generateToken = (userId, roles) => {
    return jsonwebtoken_1.default.sign({ id: userId, roles }, JWT_SECRET, { expiresIn: "1h" });
};
// ✅ Export as object for consistent usage across modules
const authModel = {
    hashPassword,
    comparePasswords,
    generateToken,
};
exports.default = authModel;
