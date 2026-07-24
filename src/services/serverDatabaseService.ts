// ================================================
// ✅ Service: serverDatabaseService
// Description: Handles SQL Server configuration summaries and connection tests
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: services/serverDatabaseService.ts
// ================================================

import sql from "mssql";

export interface ServerDatabaseConfig {
  provider: "sqlserver";
  host: string;
  port: number;
  username: string;
  password?: string;
  database: string;
}

export interface ServerDatabaseTestResult {
  ok: boolean;
  provider: "sqlserver";
  host: string;
  port: number;
  database: string;
  connectedAt: string;
  serverName?: string;
  sqlVersion?: string;
  databaseExists: boolean;
  tableCount: number;
  requiredTables: Record<string, boolean>;
  message: string;
}

const requiredCoreTables = [
  "AspNetUsers",
  "AspNetRoles",
  "Portals",
  "API_KEYS",
  "ProtosTemplate",
  "DyFormViewModelDefinition",
];

function primaryConfig(): ServerDatabaseConfig {
  return {
    provider: "sqlserver",
    host: process.env.DB_HOST || "127.0.0.1",
    port: parseInt(process.env.DB_PORT || "1433", 10),
    username: process.env.DB_USER || "",
    password: process.env.DB_PASSWORD || "",
    database: process.env.DB_NAME || "skylynxnet_coredb",
  };
}

function backupConfig(): ServerDatabaseConfig {
  return {
    provider: "sqlserver",
    host: process.env.DB_BACKUP_HOST || "",
    port: parseInt(process.env.DB_BACKUP_PORT || "1433", 10),
    username: process.env.DB_BACKUP_USER || "",
    password: process.env.DB_BACKUP_PASSWORD || "",
    database: process.env.DB_BACKUP_NAME || "skylynxnet_coredb_backup",
  };
}

async function testConnection(
  config: ServerDatabaseConfig
): Promise<ServerDatabaseTestResult> {
  const connectedAt = new Date().toISOString();

  if (!config.host || !config.username) {
    return {
      ok: false,
      provider: "sqlserver",
      host: config.host,
      port: config.port,
      database: config.database,
      connectedAt,
      databaseExists: false,
      tableCount: 0,
      requiredTables: {},
      message: "Missing SQL Server host or username.",
    };
  }

  let pool: sql.ConnectionPool | null = null;
  try {
    pool = await sql.connect({
      user: config.username,
      password: config.password,
      server: config.host,
      port: config.port,
      database: "master",
      options: {
        encrypt: false,
        trustServerCertificate: true,
      },
    });

    const serverInfo = await pool.request().query(`
      SELECT @@SERVERNAME AS serverName, @@VERSION AS sqlVersion
    `);

    const dbResult = await pool
      .request()
      .input("DatabaseName", sql.NVarChar(256), config.database)
      .query("SELECT DB_ID(@DatabaseName) AS databaseId");

    const databaseExists = Boolean(dbResult.recordset[0]?.databaseId);
    let tableCount = 0;
    const requiredTables: Record<string, boolean> = {};

    if (databaseExists) {
      const tableResult = await pool
        .request()
        .input("DatabaseName", sql.NVarChar(256), config.database)
        .query(`
          DECLARE @sql NVARCHAR(MAX) =
            N'SELECT COUNT(*) AS tableCount FROM ' + QUOTENAME(@DatabaseName) + N'.sys.tables WHERE is_ms_shipped = 0';
          EXEC sp_executesql @sql;
        `);
      tableCount = Number(tableResult.recordset[0]?.tableCount || 0);

      for (const tableName of requiredCoreTables) {
        const existsResult = await pool
          .request()
          .input("DatabaseName", sql.NVarChar(256), config.database)
          .input("TableName", sql.NVarChar(256), tableName)
          .query(`
            DECLARE @sql NVARCHAR(MAX) =
              N'SELECT CASE WHEN EXISTS (
                  SELECT 1 FROM ' + QUOTENAME(@DatabaseName) + N'.sys.tables t
                  JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.schemas s ON s.schema_id = t.schema_id
                  WHERE s.name = N''dbo'' AND t.name = @TableName
                ) THEN 1 ELSE 0 END AS existsFlag';
            EXEC sp_executesql @sql, N'@TableName NVARCHAR(256)', @TableName;
          `);
        requiredTables[tableName] = Boolean(existsResult.recordset[0]?.existsFlag);
      }
    }

    const hasRequiredTables =
      databaseExists &&
      requiredCoreTables.every((tableName) => requiredTables[tableName]);

    return {
      ok: databaseExists && tableCount > 0 && hasRequiredTables,
      provider: "sqlserver",
      host: config.host,
      port: config.port,
      database: config.database,
      connectedAt,
      serverName: serverInfo.recordset[0]?.serverName,
      sqlVersion: serverInfo.recordset[0]?.sqlVersion,
      databaseExists,
      tableCount,
      requiredTables,
      message: !databaseExists
        ? "Connected to SQL Server, but the target database does not exist."
        : tableCount === 0
        ? "Connected to SQL Server, but the database has no user tables."
        : hasRequiredTables
        ? "Connected successfully. Core database appears installed."
        : "Connected successfully, but required core tables are missing.",
    };
  } catch (error: any) {
    return {
      ok: false,
      provider: "sqlserver",
      host: config.host,
      port: config.port,
      database: config.database,
      connectedAt,
      databaseExists: false,
      tableCount: 0,
      requiredTables: {},
      message: error.message || "SQL Server connection failed.",
    };
  } finally {
    if (pool) await pool.close();
  }
}

export default {
  primaryConfig,
  backupConfig,
  testConnection,
};
