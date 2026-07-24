// ================================================
// ✅ Service: serverDatabaseService
// Description: Handles SQL Server configuration summaries and connection tests
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: services/serverDatabaseService.ts
// ================================================

import sql from "mssql";
import fs from "fs";
import path from "path";

export interface ServerDatabaseConfig {
  provider: "sqlserver";
  host: string;
  port: number;
  username: string;
  password?: string;
  database: string;
  role: "core" | "portal";
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
  databases?: string[];
}

export interface ServerDatabaseInstallResult extends ServerDatabaseTestResult {
  installed: boolean;
  schemaFiles: string[];
  seedFiles: string[];
  batchesExecuted: number;
  installLogPath?: string;
}

export type ServerDatabaseTarget =
  | "primaryCore"
  | "primaryPortal"
  | "backupCore"
  | "backupPortal";

const requiredCoreTables = [
  "AspNetUsers",
  "AspNetRoles",
  "Portals",
  "API_KEYS",
  "ProtosTemplate",
  "DyFormViewModelDefinition",
];

const requiredPortalTables = [
  "ANNOUNCEMENTS",
  "CUSTOM_FORMS",
  "PAGE_VARIABLES",
  "PORTAL_PAGES",
];

function toPort(value: unknown, fallback = 1433): number {
  const parsed = parseInt(String(value || fallback), 10);
  return Number.isFinite(parsed) ? parsed : fallback;
}

function cleanConfig(config: Partial<ServerDatabaseConfig>): ServerDatabaseConfig {
  return {
    provider: "sqlserver",
    host: String(config.host || ""),
    port: toPort(config.port),
    username: String(config.username || ""),
    password: config.password,
    database: String(config.database || ""),
    role: config.role === "portal" ? "portal" : "core",
  };
}

function primaryCoreConfig(): ServerDatabaseConfig {
  return {
    provider: "sqlserver",
    host: process.env.DB_HOST || "127.0.0.1",
    port: toPort(process.env.DB_PORT),
    username: process.env.DB_USER || "",
    password: process.env.DB_PASSWORD || "",
    database: process.env.DB_NAME || "skylynxnet_coredb",
    role: "core",
  };
}

function primaryPortalConfig(): ServerDatabaseConfig {
  return {
    provider: "sqlserver",
    host: process.env.DB_PORTAL_HOST || process.env.DB_HOST || "127.0.0.1",
    port: toPort(process.env.DB_PORTAL_PORT || process.env.DB_PORT),
    username: process.env.DB_PORTAL_USER || process.env.DB_USER || "",
    password: process.env.DB_PORTAL_PASSWORD || process.env.DB_PASSWORD || "",
    database: process.env.DB_PORTAL_NAME || "skylynx_portal_template",
    role: "portal",
  };
}

function backupCoreConfig(): ServerDatabaseConfig {
  return {
    provider: "sqlserver",
    host: process.env.DB_BACKUP_HOST || "",
    port: toPort(process.env.DB_BACKUP_PORT),
    username: process.env.DB_BACKUP_USER || "",
    password: process.env.DB_BACKUP_PASSWORD || "",
    database: process.env.DB_BACKUP_NAME || "skylynxnet_coredb_backup",
    role: "core",
  };
}

function backupPortalConfig(): ServerDatabaseConfig {
  return {
    provider: "sqlserver",
    host: process.env.DB_BACKUP_PORTAL_HOST || process.env.DB_BACKUP_HOST || "",
    port: toPort(process.env.DB_BACKUP_PORTAL_PORT || process.env.DB_BACKUP_PORT),
    username: process.env.DB_BACKUP_PORTAL_USER || process.env.DB_BACKUP_USER || "",
    password: process.env.DB_BACKUP_PORTAL_PASSWORD || process.env.DB_BACKUP_PASSWORD || "",
    database: process.env.DB_BACKUP_PORTAL_NAME || "skylynx_portal_template_backup",
    role: "portal",
  };
}

function configForTarget(target: ServerDatabaseTarget): ServerDatabaseConfig {
  switch (target) {
    case "primaryPortal":
      return primaryPortalConfig();
    case "backupCore":
      return backupCoreConfig();
    case "backupPortal":
      return backupPortalConfig();
    case "primaryCore":
    default:
      return primaryCoreConfig();
  }
}

function requiredTablesFor(role: "core" | "portal") {
  return role === "portal" ? requiredPortalTables : requiredCoreTables;
}

function defaultDatabaseNameFor(role: "core" | "portal") {
  return role === "portal" ? "skylynx_portal_template" : "skylynxnet_coredb";
}

function quoteDatabaseName(database: string): string {
  return `[${database.replace(/]/g, "]]")}]`;
}

function dataRoot() {
  const candidates = [
    path.join(process.cwd(), "src", "data"),
    path.join(process.cwd(), "dist", "data"),
  ];
  const found = candidates.find((candidate) => fs.existsSync(candidate));
  if (!found) throw new Error("SQL install data folder was not found.");
  return found;
}

function adminRoot() {
  const configured = process.env.SKYLYNX_ADMIN_DIR || path.join(process.cwd(), "admin");
  fs.mkdirSync(configured, { recursive: true });
  return configured;
}

function installLogRoot() {
  const logRoot = path.join(adminRoot(), "install-logs");
  fs.mkdirSync(logRoot, { recursive: true });
  return logRoot;
}

function safeLogName(value: string) {
  return value.replace(/[^A-Za-z0-9_.-]+/g, "_").slice(0, 80);
}

function createInstallLogger(config: ServerDatabaseConfig) {
  const timestamp = new Date().toISOString().replace(/[:.]/g, "-");
  const logPath = path.join(
    installLogRoot(),
    `${timestamp}_${config.role}_${safeLogName(config.database)}.log`
  );
  const write = (message: string) => {
    fs.appendFileSync(logPath, `[${new Date().toISOString()}] ${message}\n`, "utf8");
  };
  return { logPath, write };
}

function readOrderFile(folder: string, fileName: string) {
  const orderPath = path.join(folder, fileName);
  return fs
    .readFileSync(orderPath, "utf8")
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter(Boolean);
}

function rewriteSqlForInstall(sqlText: string, role: "core" | "portal", database: string) {
  const defaultName = defaultDatabaseNameFor(role);
  const escapedDefault = defaultName.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  return sqlText
    .replace(new RegExp(`\\[${escapedDefault}\\]`, "g"), quoteDatabaseName(database))
    .replace(new RegExp(`N'${escapedDefault}'`, "g"), `N'${database.replace(/'/g, "''")}'`)
    .replace(new RegExp(`'${escapedDefault}'`, "g"), `'${database.replace(/'/g, "''")}'`)
    .replace(new RegExp(`\\b${escapedDefault}\\.dbo\\.`, "gi"), `${quoteDatabaseName(database)}.dbo.`)
    .replace(/\bUNIQUE\s+CLUSTERED\b/gi, "UNIQUE NONCLUSTERED");
}

function splitBatches(sqlText: string) {
  return sqlText
    .split(/^\s*GO\s*;?\s*$/gim)
    .map((batch) => batch.trim())
    .filter(Boolean);
}

const skippedLegacyViewNames = [
  "vw_DyForm_ActiveDomainsUsed",
  "vw_DyForm_CompleteFieldMap",
  "vw_DyForm_FieldExpressions",
  "vw_DyForm_FieldRules",
  "vw_DyForm_UnusedTypesOrDomains",
  "vw_PortalModules",
];

function skippedLegacyViewName(batch: string): string | null {
  const match = batch.match(/\bCREATE\s+VIEW\s+(?:\[dbo\]\.)?\[?([A-Za-z0-9_]+)\]?\s+AS\b/i);
  if (!match) return null;
  return skippedLegacyViewNames.includes(match[1]) ? match[1] : null;
}

const skippedLegacyProcedureNames = [
  "AssignModuleToPortal",
  "GetAllDyFormDFormDomainss",
  "GetAllDyFormDFormDomainValuess",
  "GetAllDyFormDFormFieldRules",
  "GetAllDyFormDFormFields",
  "GetAllDyFormDForms",
  "GetAllDyFormDFormSections",
  "GenerateApiKey",
  "GetModuleIDbyKey",
  "GetModulesByPortal",
  "GetPortalIDbyKey",
  "GetUserIDbyKey",
  "RemoveModuleFromPortal",
  "UpdateUserProviderProfileDataField",
];

function skippedLegacyProcedureName(batch: string): string | null {
  const match = batch.match(/\bCREATE\s+(?:OR\s+ALTER\s+)?PROCEDURE\s+(?:(?:\[?dbo\]?)\.)?\[?([A-Za-z0-9_]+)\]?/i);
  if (!match) return null;
  return skippedLegacyProcedureNames.includes(match[1]) ? match[1] : null;
}

function createdViewName(batch: string): string | null {
  const match = batch.match(/\bCREATE\s+VIEW\s+(?:\[dbo\]\.)?\[?([A-Za-z0-9_]+)\]?\s+AS\b/i);
  return match ? match[1] : null;
}

function orderViewBatches(batches: string[]) {
  const pivotIndex = batches.findIndex(
    (batch) => createdViewName(batch) === "vw_UserProfileFieldPivot"
  );
  if (pivotIndex < 0) return batches;

  const pivotBatch = batches[pivotIndex];
  const remaining = batches.filter((_batch, index) => index !== pivotIndex);
  const firstProfileDependency = remaining.findIndex((batch) =>
    /\bvw_UserProfileFieldPivot\b/i.test(batch)
  );
  if (firstProfileDependency < 0) return remaining.concat(pivotBatch);

  return [
    ...remaining.slice(0, firstProfileDependency),
    pivotBatch,
    ...remaining.slice(firstProfileDependency),
  ];
}

function sqlErrorDetails(error: any) {
  const messages = [
    error?.message,
    ...(error?.precedingErrors || []).map((item: any) => item?.message),
    ...(error?.originalError?.info?.message ? [error.originalError.info.message] : []),
  ].filter(Boolean);
  return Array.from(new Set(messages)).join(" | ") || "SQL batch failed.";
}

async function connectToServer(config: ServerDatabaseConfig): Promise<sql.ConnectionPool> {
  return sql.connect({
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
}

async function connectToDatabase(config: ServerDatabaseConfig): Promise<sql.ConnectionPool> {
  return sql.connect({
    user: config.username,
    password: config.password,
    server: config.host,
    port: config.port,
    database: config.database,
    options: {
      encrypt: false,
      trustServerCertificate: true,
    },
  });
}

async function testConnection(
  config: ServerDatabaseConfig
): Promise<ServerDatabaseTestResult> {
  config = cleanConfig(config);
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
    pool = await connectToServer(config);

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

      for (const tableName of requiredTablesFor(config.role)) {
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
      requiredTablesFor(config.role).every((tableName) => requiredTables[tableName]);

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
        ? `Connected successfully. ${config.role === "portal" ? "Portal" : "Core"} database appears installed.`
        : `Connected successfully, but required ${config.role} tables are missing.`,
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

async function listDatabases(config: ServerDatabaseConfig): Promise<string[]> {
  config = cleanConfig(config);
  if (!config.host || !config.username) {
    throw new Error("Missing SQL Server host or username.");
  }

  let pool: sql.ConnectionPool | null = null;
  try {
    pool = await connectToServer(config);
    const result = await pool.request().query(`
      SELECT name
      FROM sys.databases
      WHERE database_id > 4
      ORDER BY name
    `);
    return result.recordset.map((row) => row.name);
  } finally {
    if (pool) await pool.close();
  }
}

async function createDatabase(config: ServerDatabaseConfig): Promise<ServerDatabaseTestResult> {
  config = cleanConfig(config);
  if (!config.host || !config.username) {
    throw new Error("Missing SQL Server host or username.");
  }
  if (!/^[A-Za-z0-9_ -]{1,128}$/.test(config.database)) {
    throw new Error("Database name can only contain letters, numbers, spaces, underscores, and hyphens.");
  }

  let pool: sql.ConnectionPool | null = null;
  try {
    pool = await connectToServer(config);
    const exists = await pool
      .request()
      .input("DatabaseName", sql.NVarChar(128), config.database)
      .query("SELECT DB_ID(@DatabaseName) AS databaseId");
    if (!exists.recordset[0]?.databaseId) {
      await pool.request().query(`CREATE DATABASE ${quoteDatabaseName(config.database)}`);
    }
  } finally {
    if (pool) await pool.close();
  }

  return testConnection(config);
}

async function installDatabase(config: ServerDatabaseConfig): Promise<ServerDatabaseInstallResult> {
  config = cleanConfig(config);
  const before = await testConnection(config);
  if (!before.databaseExists) {
    throw new Error("Target database does not exist. Create it before running install.");
  }
  if (before.tableCount > 0) {
    throw new Error("Install can only run on an empty database.");
  }

  const installFolder = path.join(dataRoot(), config.role);
  const seedFolder = path.join(installFolder, "seed");
  const schemaFiles = readOrderFile(installFolder, "install_order.txt").filter(
    (fileName) => fileName !== "00_database.sql"
  );
  const seedFiles = fs.existsSync(seedFolder)
    ? readOrderFile(seedFolder, "seed_order.txt")
    : [];

  let pool: sql.ConnectionPool | null = null;
  let transaction: sql.Transaction | null = null;
  let batchesExecuted = 0;
  let currentFile = "";
  let currentBatch = 0;
  const logger = createInstallLogger(config);
  logger.write(`Install started for ${config.role} database ${config.database} on ${config.host}:${config.port}.`);
  logger.write(`Schema files: ${schemaFiles.join(", ")}`);
  logger.write(`Seed files: ${seedFiles.join(", ") || "none"}`);
  try {
    pool = await connectToDatabase(config);
    transaction = new sql.Transaction(pool);
    await transaction.begin(sql.ISOLATION_LEVEL.SERIALIZABLE);
    logger.write("Transaction started.");

    for (const fileName of schemaFiles) {
      currentFile = fileName;
      currentBatch = 0;
      const filePath = path.join(installFolder, fileName);
      const sqlText = rewriteSqlForInstall(
        fs.readFileSync(filePath, "utf8"),
        config.role,
        config.database
      );
      const batches =
        fileName === "08_views.sql"
          ? orderViewBatches(splitBatches(sqlText))
          : splitBatches(sqlText);
      for (const batch of batches) {
        currentBatch += 1;
        const skippedView = skippedLegacyViewName(batch);
        if (skippedView) {
          logger.write(`Skipping ${currentFile} batch ${currentBatch}: legacy view ${skippedView} does not match current DyForm schema.`);
          continue;
        }
        const skippedProcedure = skippedLegacyProcedureName(batch);
        if (skippedProcedure) {
          logger.write(`Skipping ${currentFile} batch ${currentBatch}: legacy procedure ${skippedProcedure} references removed schema objects.`);
          continue;
        }
        logger.write(`Executing ${currentFile} batch ${currentBatch}.`);
        await new sql.Request(transaction).batch(batch);
        batchesExecuted += 1;
      }
    }

    for (const fileName of seedFiles) {
      currentFile = path.join("seed", fileName);
      currentBatch = 0;
      const filePath = path.join(seedFolder, fileName);
      const sqlText = rewriteSqlForInstall(
        fs.readFileSync(filePath, "utf8"),
        config.role,
        config.database
      );
      for (const batch of splitBatches(sqlText)) {
        currentBatch += 1;
        logger.write(`Executing ${currentFile} batch ${currentBatch}.`);
        await new sql.Request(transaction).batch(batch);
        batchesExecuted += 1;
      }
    }
    await transaction.commit();
    logger.write(`Transaction committed. Batches executed: ${batchesExecuted}.`);
  } catch (error: any) {
    const details = sqlErrorDetails(error);
    logger.write(
      `ERROR in ${currentFile || "unknown file"} batch ${currentBatch || 0}: ${
        details
      }`
    );
    if (transaction) {
      try {
        await transaction.rollback();
        logger.write("Transaction rolled back.");
      } catch (rollbackError: any) {
        logger.write(`ROLLBACK FAILED: ${rollbackError.message || "Rollback failed."}`);
      }
    }
    throw new Error(
      `Install failed in ${currentFile || "unknown file"} batch ${currentBatch || 0}: ${
        details
      }. Log: ${logger.logPath}`
    );
  } finally {
    if (pool) await pool.close();
    logger.write("SQL connection closed.");
  }

  const after = await testConnection(config);
  return {
    ...after,
    installed: after.ok,
    schemaFiles,
    seedFiles,
    batchesExecuted,
    installLogPath: logger.logPath,
    message: after.ok
      ? `${config.role === "portal" ? "Portal" : "Core"} database installed successfully.`
      : after.message,
  };
}

export default {
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
};
