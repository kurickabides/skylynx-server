import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

type QueryHandler = (query: string) => Promise<{ recordset: any[] }>;

const queryHandlers: QueryHandler[] = [];
const batchMock = vi.fn();
const closeMock = vi.fn();

vi.mock("mssql", () => {
  class MockRequest {
    input() {
      return this;
    }

    query(query: string) {
      const handler = queryHandlers.shift();
      if (!handler) throw new Error(`Unexpected SQL query: ${query}`);
      return handler(query);
    }

    batch(batch: string) {
      return batchMock(batch);
    }
  }

  class MockTransaction {
    begin = vi.fn();
    commit = vi.fn();
    rollback = vi.fn();
  }

  const sqlMock = {
    connect: vi.fn(async () => ({
      request: () => new MockRequest(),
      close: closeMock,
    })),
    ConnectionPool: vi.fn(),
    Request: MockRequest,
    Transaction: MockTransaction,
    ISOLATION_LEVEL: { SERIALIZABLE: "SERIALIZABLE" },
    NVarChar: vi.fn(),
  };

  return {
    default: sqlMock,
    ...sqlMock,
  };
});

describe("serverDatabaseService", () => {
  const oldEnv = process.env;

  beforeEach(() => {
    process.env = { ...oldEnv };
    queryHandlers.length = 0;
    batchMock.mockResolvedValue(undefined);
    closeMock.mockResolvedValue(undefined);
  });

  afterEach(() => {
    process.env = oldEnv;
  });

  it("builds database configs from environment with expected fallbacks", async () => {
    vi.resetModules();
    process.env.DB_HOST = "core-host";
    process.env.DB_PORT = "1500";
    process.env.DB_USER = "core-user";
    process.env.DB_PASSWORD = "core-pass";
    process.env.DB_NAME = "core-db";
    process.env.DB_PORTAL_NAME = "portal-db";
    process.env.DB_BACKUP_HOST = "backup-host";
    process.env.DB_BACKUP_USER = "backup-user";
    process.env.DB_BACKUP_PASSWORD = "backup-pass";
    process.env.DB_BACKUP_NAME = "backup-core-db";

    const service = (await import("../src/services/serverDatabaseService")).default;

    expect(service.primaryCoreConfig()).toMatchObject({
      host: "core-host",
      port: 1500,
      username: "core-user",
      password: "core-pass",
      database: "core-db",
      role: "core",
    });
    expect(service.primaryPortalConfig()).toMatchObject({
      host: "core-host",
      username: "core-user",
      password: "core-pass",
      database: "portal-db",
      role: "portal",
    });
    expect(service.backupPortalConfig()).toMatchObject({
      host: "backup-host",
      username: "backup-user",
      password: "backup-pass",
      database: "skylynx_portal_template_backup",
      role: "portal",
    });
  });

  it("normalizes config values", async () => {
    const service = (await import("../src/services/serverDatabaseService")).default;

    expect(
      service.cleanConfig({
        host: "db",
        port: "not-a-number" as any,
        username: "sa",
        database: "core",
        role: "portal",
      })
    ).toMatchObject({
      provider: "sqlserver",
      host: "db",
      port: 1433,
      username: "sa",
      database: "core",
      role: "portal",
    });
  });

  it("rewrites default database names, batches SQL, and detects deferred objects", async () => {
    const { serverDatabaseTestInternals } = await import(
      "../src/services/serverDatabaseService"
    );

    const rewritten = serverDatabaseTestInternals.rewriteSqlForInstall(
      "SELECT * FROM [skylynxnet_coredb].dbo.Portals; SELECT N'skylynxnet_coredb'; CREATE UNIQUE CLUSTERED INDEX IX ON dbo.T(C);",
      "core",
      "fresh_core"
    );

    expect(rewritten).toContain("[fresh_core].dbo.Portals");
    expect(rewritten).toContain("N'fresh_core'");
    expect(rewritten).toContain("UNIQUE NONCLUSTERED INDEX");
    expect(serverDatabaseTestInternals.quoteDatabaseName("a]b")).toBe("[a]]b]");
    expect(serverDatabaseTestInternals.splitBatches("SELECT 1\nGO\nSELECT 2")).toEqual([
      "SELECT 1",
      "SELECT 2",
    ]);
    expect(
      serverDatabaseTestInternals.skippedLegacyViewName(
        "CREATE VIEW dbo.vw_PortalModules AS SELECT 1"
      )
    ).toBe("vw_PortalModules");
    expect(
      serverDatabaseTestInternals.skippedLegacyProcedureName(
        "CREATE PROCEDURE dbo.GenerateApiKey AS SELECT 1"
      )
    ).toBe("GenerateApiKey");
  });

  it("reports a missing SQL host or username without connecting", async () => {
    const service = (await import("../src/services/serverDatabaseService")).default;

    const result = await service.testConnection({
      provider: "sqlserver",
      host: "",
      port: 1433,
      username: "",
      database: "core",
      role: "core",
    });

    expect(result.ok).toBe(false);
    expect(result.message).toBe("Missing SQL Server host or username.");
  });

  it("returns installed status when required core tables exist", async () => {
    const service = (await import("../src/services/serverDatabaseService")).default;
    queryHandlers.push(
      async () => ({ recordset: [{ serverName: "sql", sqlVersion: "version" }] }),
      async () => ({ recordset: [{ databaseId: 5 }] }),
      async () => ({ recordset: [{ tableCount: 10 }] }),
      async () => ({ recordset: [{ existsFlag: 1 }] }),
      async () => ({ recordset: [{ existsFlag: 1 }] }),
      async () => ({ recordset: [{ existsFlag: 1 }] }),
      async () => ({ recordset: [{ existsFlag: 1 }] }),
      async () => ({ recordset: [{ existsFlag: 1 }] }),
      async () => ({ recordset: [{ existsFlag: 1 }] })
    );

    const result = await service.testConnection({
      provider: "sqlserver",
      host: "db",
      port: 1433,
      username: "sa",
      password: "pass",
      database: "core",
      role: "core",
    });

    expect(result.ok).toBe(true);
    expect(result.databaseExists).toBe(true);
    expect(result.tableCount).toBe(10);
    expect(result.message).toBe("Connected successfully. Core database appears installed.");
  });

  it("rejects unsafe database names before create", async () => {
    const service = (await import("../src/services/serverDatabaseService")).default;

    await expect(
      service.createDatabase({
        provider: "sqlserver",
        host: "db",
        port: 1433,
        username: "sa",
        password: "pass",
        database: "bad];DROP DATABASE real",
        role: "core",
      })
    ).rejects.toThrow("Database name can only contain");
  });

  it("rejects install when target database does not exist", async () => {
    const service = (await import("../src/services/serverDatabaseService")).default;
    queryHandlers.push(
      async () => ({ recordset: [{ serverName: "sql", sqlVersion: "version" }] }),
      async () => ({ recordset: [{ databaseId: null }] })
    );

    await expect(
      service.installDatabase({
        provider: "sqlserver",
        host: "db",
        port: 1433,
        username: "sa",
        password: "pass",
        database: "missing",
        role: "core",
      })
    ).rejects.toThrow("Target database does not exist");
  });
});
