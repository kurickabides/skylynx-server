// ================================================
// ✅ Service: serverAdminService
// Description: Handles local server admin persistence and token management
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: services/serverAdminService.ts
// ================================================

import fs from "fs";
import path from "path";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";

const ADMIN_DIR = process.env.SKYLYNX_ADMIN_DIR || path.join(process.cwd(), "admin");
const ADMIN_FILE = path.join(ADMIN_DIR, "server-admin.json");
const SERVER_JWT_SECRET =
  process.env.SERVER_JWT_SECRET || process.env.JWT_SECRET || "changeme-server-admin";

export interface ServerAdminRecord {
  adminId: string;
  username: string;
  passwordHash: string;
  roles: string[];
  createdAt: string;
  lastLoginAt: string | null;
  passwordVersion: number;
}

export interface ServerAdminTokenPayload {
  sub: string;
  username: string;
  roles: string[];
  scope: "skylynx-server-admin";
}

function ensureAdminDir() {
  fs.mkdirSync(ADMIN_DIR, { recursive: true });
}

function readAdmin(): ServerAdminRecord | null {
  if (!fs.existsSync(ADMIN_FILE)) return null;
  const raw = fs.readFileSync(ADMIN_FILE, "utf8");
  return JSON.parse(raw) as ServerAdminRecord;
}

function writeAdmin(record: ServerAdminRecord) {
  ensureAdminDir();
  fs.writeFileSync(ADMIN_FILE, JSON.stringify(record, null, 2) + "\n", {
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

async function setup(username: string, password: string) {
  if (readAdmin()) {
    throw new Error("Server admin is already configured.");
  }

  const cleanUsername = String(username || "").trim();
  if (!cleanUsername) throw new Error("Username is required.");
  if (!password || password.length < 10) {
    throw new Error("Password must be at least 10 characters.");
  }

  const record: ServerAdminRecord = {
    adminId: "server-owner",
    username: cleanUsername,
    passwordHash: await bcrypt.hash(password, 12),
    roles: ["SERVER_ADMIN"],
    createdAt: new Date().toISOString(),
    lastLoginAt: null,
    passwordVersion: 1,
  };

  writeAdmin(record);
  return { configured: true, username: record.username, roles: record.roles };
}

async function login(username: string, password: string) {
  const record = readAdmin();
  if (!record) throw new Error("Server admin is not configured.");

  const matchesUsername = record.username.toLowerCase() === String(username || "").trim().toLowerCase();
  const matchesPassword = await bcrypt.compare(password || "", record.passwordHash);
  if (!matchesUsername || !matchesPassword) {
    throw new Error("Invalid server admin credentials.");
  }

  record.lastLoginAt = new Date().toISOString();
  writeAdmin(record);

  const payload: ServerAdminTokenPayload = {
    sub: record.adminId,
    username: record.username,
    roles: record.roles,
    scope: "skylynx-server-admin",
  };

  const token = jwt.sign(payload, SERVER_JWT_SECRET, { expiresIn: "4h" });
  return { token, username: record.username, roles: record.roles };
}

function verifyToken(token: string): ServerAdminTokenPayload {
  const decoded = jwt.verify(token, SERVER_JWT_SECRET) as ServerAdminTokenPayload;
  if (decoded.scope !== "skylynx-server-admin") {
    throw new Error("Invalid server admin token scope.");
  }
  return decoded;
}

export default {
  getStatus,
  setup,
  login,
  verifyToken,
};
