import fs from "fs";
import os from "os";
import path from "path";
import jwt from "jsonwebtoken";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

describe("serverAdminService", () => {
  const oldEnv = process.env;
  let tempDir: string;

  async function loadService() {
    vi.resetModules();
    return (await import("../src/services/serverAdminService")).default;
  }

  beforeEach(() => {
    tempDir = fs.mkdtempSync(path.join(os.tmpdir(), "skylynx-admin-test-"));
    process.env = {
      ...oldEnv,
      SKYLYNX_ADMIN_DIR: tempDir,
      SERVER_JWT_SECRET: "test-secret",
    };
  });

  afterEach(() => {
    process.env = oldEnv;
    fs.rmSync(tempDir, { recursive: true, force: true });
  });

  it("reports unconfigured status before setup", async () => {
    const service = await loadService();

    expect(service.getStatus()).toMatchObject({
      configured: false,
      adminDir: tempDir,
      adminFile: path.join(tempDir, "server-admin.json"),
    });
  });

  it("creates an admin record with a hashed password and rejects duplicate setup", async () => {
    const service = await loadService();

    const result = await service.setup("Admin", "long-password");
    const raw = fs.readFileSync(path.join(tempDir, "server-admin.json"), "utf8");
    const stored = JSON.parse(raw);

    expect(result).toEqual({
      configured: true,
      username: "Admin",
      roles: ["SERVER_ADMIN"],
    });
    expect(stored.passwordHash).not.toBe("long-password");
    expect(stored.passwordHash).toMatch(/^\$2/);
    await expect(service.setup("Admin2", "long-password")).rejects.toThrow(
      "already configured"
    );
  });

  it("validates setup inputs", async () => {
    const service = await loadService();

    await expect(service.setup("", "long-password")).rejects.toThrow(
      "Username is required"
    );
    await expect(service.setup("admin", "short")).rejects.toThrow(
      "Password must be at least 10 characters"
    );
  });

  it("logs in with valid credentials and rejects invalid credentials", async () => {
    const service = await loadService();
    await service.setup("Admin", "long-password");

    const login = await service.login("admin", "long-password");

    expect(login.username).toBe("Admin");
    expect(login.roles).toEqual(["SERVER_ADMIN"]);
    expect(service.verifyToken(login.token)).toMatchObject({
      username: "Admin",
      roles: ["SERVER_ADMIN"],
      scope: "skylynx-server-admin",
    });
    await expect(service.login("admin", "wrong-password")).rejects.toThrow(
      "Invalid server admin credentials"
    );
  });

  it("rejects tokens with the wrong server admin scope", async () => {
    const service = await loadService();
    const token = jwt.sign({ scope: "portal-api" }, "test-secret");

    expect(() => service.verifyToken(token)).toThrow("Invalid server admin token scope");
  });
});
