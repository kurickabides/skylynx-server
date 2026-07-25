"use strict";
// ================================================
// ✅ Service: serverAdminService
// Description: Handles local server admin persistence and token management
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: services/serverAdminService.ts
// ================================================
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const fs_1 = __importDefault(require("fs"));
const path_1 = __importDefault(require("path"));
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const ADMIN_DIR = process.env.SKYLYNX_ADMIN_DIR || path_1.default.join(process.cwd(), "admin");
const ADMIN_FILE = path_1.default.join(ADMIN_DIR, "server-admin.json");
const SERVER_JWT_SECRET = process.env.SERVER_JWT_SECRET || process.env.JWT_SECRET || "changeme-server-admin";
function ensureAdminDir() {
    fs_1.default.mkdirSync(ADMIN_DIR, { recursive: true });
}
function readAdmin() {
    if (!fs_1.default.existsSync(ADMIN_FILE))
        return null;
    const raw = fs_1.default.readFileSync(ADMIN_FILE, "utf8");
    return JSON.parse(raw);
}
function writeAdmin(record) {
    ensureAdminDir();
    fs_1.default.writeFileSync(ADMIN_FILE, JSON.stringify(record, null, 2) + "\n", {
        encoding: "utf8",
        mode: 0o600,
    });
}
function getStatus() {
    return {
        configured: Boolean(readAdmin()),
        adminDir: ADMIN_DIR,
        adminFile: ADMIN_FILE,
    };
}
async function setup(username, password) {
    if (readAdmin()) {
        throw new Error("Server admin is already configured.");
    }
    const cleanUsername = String(username || "").trim();
    if (!cleanUsername)
        throw new Error("Username is required.");
    if (!password || password.length < 10) {
        throw new Error("Password must be at least 10 characters.");
    }
    const record = {
        adminId: "server-owner",
        username: cleanUsername,
        passwordHash: await bcryptjs_1.default.hash(password, 12),
        roles: ["SERVER_ADMIN"],
        createdAt: new Date().toISOString(),
        lastLoginAt: null,
        passwordVersion: 1,
    };
    writeAdmin(record);
    return { configured: true, username: record.username, roles: record.roles };
}
async function login(username, password) {
    const record = readAdmin();
    if (!record)
        throw new Error("Server admin is not configured.");
    const matchesUsername = record.username.toLowerCase() === String(username || "").trim().toLowerCase();
    const matchesPassword = await bcryptjs_1.default.compare(password || "", record.passwordHash);
    if (!matchesUsername || !matchesPassword) {
        throw new Error("Invalid server admin credentials.");
    }
    record.lastLoginAt = new Date().toISOString();
    writeAdmin(record);
    const payload = {
        sub: record.adminId,
        username: record.username,
        roles: record.roles,
        scope: "skylynx-server-admin",
    };
    const token = jsonwebtoken_1.default.sign(payload, SERVER_JWT_SECRET, { expiresIn: "4h" });
    return { token, username: record.username, roles: record.roles };
}
function verifyToken(token) {
    const decoded = jsonwebtoken_1.default.verify(token, SERVER_JWT_SECRET);
    if (decoded.scope !== "skylynx-server-admin") {
        throw new Error("Invalid server admin token scope.");
    }
    return decoded;
}
exports.default = {
    getStatus,
    setup,
    login,
    verifyToken,
};
