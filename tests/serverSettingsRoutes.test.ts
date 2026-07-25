import express from "express";
import request from "supertest";
import { beforeEach, describe, expect, it, vi } from "vitest";

const getStatus = vi.fn();
const primaryCoreConfig = vi.fn();
const primaryPortalConfig = vi.fn();
const backupCoreConfig = vi.fn();
const backupPortalConfig = vi.fn();
const configForTarget = vi.fn();
const cleanConfig = vi.fn((config) => config);
const testConnection = vi.fn();
const listDatabases = vi.fn();
const createDatabase = vi.fn();
const installDatabase = vi.fn();

vi.mock("../src/services/serverAdminService", () => ({
  default: {
    getStatus,
    verifyToken: vi.fn((token: string) => {
      if (token !== "valid-token") throw new Error("invalid");
      return {
        sub: "server-owner",
        username: "admin",
        roles: ["SERVER_ADMIN"],
        scope: "skylynx-server-admin",
      };
    }),
  },
}));

vi.mock("../src/services/serverDatabaseService", () => ({
  default: {
    primaryCoreConfig,
    primaryPortalConfig,
    backupCoreConfig,
    backupPortalConfig,
    configForTarget,
    cleanConfig,
    testConnection,
    listDatabases,
    createDatabase,
    installDatabase,
  },
}));

async function makeApp() {
  const serverSettingsRoutes = (await import("../src/routes/serverSettingsRoutes")).default;
  const app = express();
  app.use(express.json());
  app.use("/api/server/settings", serverSettingsRoutes);
  return app;
}

function auth(requestBuilder: request.Test) {
  return requestBuilder.set("Authorization", "Bearer valid-token");
}

describe("server settings routes", () => {
  beforeEach(() => {
    process.env.DB_PASSWORD = "core-pass";
    process.env.DB_PORTAL_PASSWORD = "";
    process.env.DB_BACKUP_PASSWORD = "";
    process.env.DB_BACKUP_PORTAL_PASSWORD = "backup-portal-pass";
    getStatus.mockReturnValue({
      configured: true,
      adminDir: "admin",
      adminFile: "admin/server-admin.json",
    });
    primaryCoreConfig.mockReturnValue({
      provider: "sqlserver",
      host: "db",
      port: 1433,
      username: "sa",
      password: "core-pass",
      database: "core",
      role: "core",
    });
    primaryPortalConfig.mockReturnValue({
      provider: "sqlserver",
      host: "db",
      port: 1433,
      username: "sa",
      password: "portal-pass",
      database: "portal",
      role: "portal",
    });
    backupCoreConfig.mockReturnValue({
      provider: "sqlserver",
      host: "backup",
      port: 1433,
      username: "sa",
      password: "",
      database: "core_backup",
      role: "core",
    });
    backupPortalConfig.mockReturnValue({
      provider: "sqlserver",
      host: "backup",
      port: 1433,
      username: "sa",
      password: "backup-portal-pass",
      database: "portal_backup",
      role: "portal",
    });
    configForTarget.mockReturnValue(primaryCoreConfig());
  });

  it("rejects settings status without a server admin token", async () => {
    const response = await request(await makeApp()).get("/api/server/settings/status");

    expect(response.status).toBe(401);
    expect(response.body.error).toBe("Missing server admin token.");
  });

  it("returns settings status for an authenticated server admin", async () => {
    const response = await auth(
      request(await makeApp()).get("/api/server/settings/status")
    );

    expect(response.status).toBe(200);
    expect(response.body).toEqual({
      configured: true,
      adminDir: "admin",
      databaseProvider: "sqlserver",
      settingsPath: "/server/settings",
    });
  });

  it("returns database summaries without raw passwords", async () => {
    const response = await auth(
      request(await makeApp()).get("/api/server/settings/database")
    );

    expect(response.status).toBe(200);
    expect(response.body.primaryCore.password).toBeUndefined();
    expect(response.body.primaryPortal.password).toBeUndefined();
    expect(response.body.backupCore.password).toBeUndefined();
    expect(response.body.backupPortal.password).toBeUndefined();
    expect(response.body.primaryCore.passwordConfigured).toBe(true);
    expect(response.body.backupCore.passwordConfigured).toBe(false);
    expect(response.body.backupPortal.passwordConfigured).toBe(true);
  });

  it("tests a selected database target with merged request settings", async () => {
    testConnection.mockResolvedValue({
      ok: true,
      database: "chosen",
      message: "ok",
    });

    const response = await auth(
      request(await makeApp())
        .post("/api/server/settings/database/test")
        .send({ target: "backupPortal", database: "chosen", password: "typed" })
    );

    expect(response.status).toBe(200);
    expect(configForTarget).toHaveBeenCalledWith("backupPortal");
    expect(cleanConfig).toHaveBeenCalledWith(
      expect.objectContaining({ database: "chosen", password: "typed" })
    );
    expect(testConnection).toHaveBeenCalled();
    expect(response.body.ok).toBe(true);
  });

  it("lists databases and maps service errors to HTTP 400", async () => {
    listDatabases.mockResolvedValueOnce(["core", "portal"]);
    let response = await auth(
      request(await makeApp()).post("/api/server/settings/database/list").send({})
    );

    expect(response.status).toBe(200);
    expect(response.body.databases).toEqual(["core", "portal"]);

    listDatabases.mockRejectedValueOnce(new Error("server failed"));
    response = await auth(
      request(await makeApp()).post("/api/server/settings/database/list").send({})
    );

    expect(response.status).toBe(400);
    expect(response.body.error).toBe("server failed");
  });

  it("creates and installs databases through the service", async () => {
    createDatabase.mockResolvedValue({ ok: false, databaseExists: true });
    installDatabase.mockResolvedValue({ ok: true, installed: true });

    const createResponse = await auth(
      request(await makeApp()).post("/api/server/settings/database/create").send({})
    );
    const installResponse = await auth(
      request(await makeApp()).post("/api/server/settings/database/install").send({})
    );

    expect(createResponse.status).toBe(201);
    expect(installResponse.status).toBe(201);
    expect(createDatabase).toHaveBeenCalled();
    expect(installDatabase).toHaveBeenCalled();
  });
});
