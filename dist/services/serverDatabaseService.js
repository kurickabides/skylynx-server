"use strict";
// ================================================
// ✅ Service: serverDatabaseService
// Description: Handles SQL Server configuration summaries and connection tests
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: services/serverDatabaseService.ts
// ================================================
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.serverDatabaseTestInternals = void 0;
const mssql_1 = __importDefault(require("mssql"));
const fs_1 = __importDefault(require("fs"));
const path_1 = __importDefault(require("path"));
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
function toPort(value, fallback = 1433) {
    const parsed = parseInt(String(value || fallback), 10);
    return Number.isFinite(parsed) ? parsed : fallback;
}
function cleanConfig(config) {
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
function primaryCoreConfig() {
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
function primaryPortalConfig() {
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
function backupCoreConfig() {
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
function backupPortalConfig() {
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
function configForTarget(target) {
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
function requiredTablesFor(role) {
    return role === "portal" ? requiredPortalTables : requiredCoreTables;
}
function defaultDatabaseNameFor(role) {
    return role === "portal" ? "skylynx_portal_template" : "skylynxnet_coredb";
}
function quoteDatabaseName(database) {
    return `[${database.replace(/]/g, "]]")}]`;
}
function dataRoot() {
    const candidates = [
        path_1.default.join(process.cwd(), "src", "data"),
        path_1.default.join(process.cwd(), "dist", "data"),
    ];
    const found = candidates.find((candidate) => fs_1.default.existsSync(candidate));
    if (!found)
        throw new Error("SQL install data folder was not found.");
    return found;
}
function adminRoot() {
    const configured = process.env.SKYLYNX_ADMIN_DIR || path_1.default.join(process.cwd(), "admin");
    fs_1.default.mkdirSync(configured, { recursive: true });
    return configured;
}
function installLogRoot() {
    const logRoot = path_1.default.join(adminRoot(), "install-logs");
    fs_1.default.mkdirSync(logRoot, { recursive: true });
    return logRoot;
}
function safeLogName(value) {
    return value.replace(/[^A-Za-z0-9_.-]+/g, "_").slice(0, 80);
}
function createInstallLogger(config) {
    const timestamp = new Date().toISOString().replace(/[:.]/g, "-");
    const logPath = path_1.default.join(installLogRoot(), `${timestamp}_${config.role}_${safeLogName(config.database)}.log`);
    const write = (message) => {
        fs_1.default.appendFileSync(logPath, `[${new Date().toISOString()}] ${message}\n`, "utf8");
    };
    return { logPath, write };
}
function readOrderFile(folder, fileName) {
    const orderPath = path_1.default.join(folder, fileName);
    return fs_1.default
        .readFileSync(orderPath, "utf8")
        .split(/\r?\n/)
        .map((line) => line.trim())
        .filter(Boolean);
}
function rewriteSqlForInstall(sqlText, role, database) {
    const defaultName = defaultDatabaseNameFor(role);
    const escapedDefault = defaultName.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    return sqlText
        .replace(new RegExp(`\\[${escapedDefault}\\]`, "g"), quoteDatabaseName(database))
        .replace(new RegExp(`N'${escapedDefault}'`, "g"), `N'${database.replace(/'/g, "''")}'`)
        .replace(new RegExp(`'${escapedDefault}'`, "g"), `'${database.replace(/'/g, "''")}'`)
        .replace(new RegExp(`\\b${escapedDefault}\\.dbo\\.`, "gi"), `${quoteDatabaseName(database)}.dbo.`)
        .replace(/\bUNIQUE\s+CLUSTERED\b/gi, "UNIQUE NONCLUSTERED");
}
function splitBatches(sqlText) {
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
function skippedLegacyViewName(batch) {
    const match = batch.match(/\bCREATE\s+VIEW\s+(?:(?:\[?dbo\]?)\.)?\[?([A-Za-z0-9_]+)\]?\s+AS\b/i);
    if (!match)
        return null;
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
function skippedLegacyProcedureName(batch) {
    const match = batch.match(/\bCREATE\s+(?:OR\s+ALTER\s+)?PROCEDURE\s+(?:(?:\[?dbo\]?)\.)?\[?([A-Za-z0-9_]+)\]?/i);
    if (!match)
        return null;
    return skippedLegacyProcedureNames.includes(match[1]) ? match[1] : null;
}
function createdViewName(batch) {
    const match = batch.match(/\bCREATE\s+VIEW\s+(?:\[dbo\]\.)?\[?([A-Za-z0-9_]+)\]?\s+AS\b/i);
    return match ? match[1] : null;
}
function orderViewBatches(batches) {
    const pivotIndex = batches.findIndex((batch) => createdViewName(batch) === "vw_UserProfileFieldPivot");
    if (pivotIndex < 0)
        return batches;
    const pivotBatch = batches[pivotIndex];
    const remaining = batches.filter((_batch, index) => index !== pivotIndex);
    const firstProfileDependency = remaining.findIndex((batch) => /\bvw_UserProfileFieldPivot\b/i.test(batch));
    if (firstProfileDependency < 0)
        return remaining.concat(pivotBatch);
    return [
        ...remaining.slice(0, firstProfileDependency),
        pivotBatch,
        ...remaining.slice(firstProfileDependency),
    ];
}
function sqlErrorDetails(error) {
    const messages = [
        error?.message,
        ...(error?.precedingErrors || []).map((item) => item?.message),
        ...(error?.originalError?.info?.message ? [error.originalError.info.message] : []),
    ].filter(Boolean);
    return Array.from(new Set(messages)).join(" | ") || "SQL batch failed.";
}
async function connectToServer(config) {
    return mssql_1.default.connect({
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
async function connectToDatabase(config) {
    return mssql_1.default.connect({
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
async function testConnection(config) {
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
    let pool = null;
    try {
        pool = await connectToServer(config);
        const serverInfo = await pool.request().query(`
      SELECT @@SERVERNAME AS serverName, @@VERSION AS sqlVersion
    `);
        const dbResult = await pool
            .request()
            .input("DatabaseName", mssql_1.default.NVarChar(256), config.database)
            .query("SELECT DB_ID(@DatabaseName) AS databaseId");
        const databaseExists = Boolean(dbResult.recordset[0]?.databaseId);
        let tableCount = 0;
        const requiredTables = {};
        if (databaseExists) {
            const tableResult = await pool
                .request()
                .input("DatabaseName", mssql_1.default.NVarChar(256), config.database)
                .query(`
          DECLARE @sql NVARCHAR(MAX) =
            N'SELECT COUNT(*) AS tableCount FROM ' + QUOTENAME(@DatabaseName) + N'.sys.tables WHERE is_ms_shipped = 0';
          EXEC sp_executesql @sql;
        `);
            tableCount = Number(tableResult.recordset[0]?.tableCount || 0);
            for (const tableName of requiredTablesFor(config.role)) {
                const existsResult = await pool
                    .request()
                    .input("DatabaseName", mssql_1.default.NVarChar(256), config.database)
                    .input("TableName", mssql_1.default.NVarChar(256), tableName)
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
        const hasRequiredTables = databaseExists &&
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
    }
    catch (error) {
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
    }
    finally {
        if (pool)
            await pool.close();
    }
}
async function listDatabases(config) {
    config = cleanConfig(config);
    if (!config.host || !config.username) {
        throw new Error("Missing SQL Server host or username.");
    }
    let pool = null;
    try {
        pool = await connectToServer(config);
        const result = await pool.request().query(`
      SELECT name
      FROM sys.databases
      WHERE database_id > 4
      ORDER BY name
    `);
        return result.recordset.map((row) => row.name);
    }
    finally {
        if (pool)
            await pool.close();
    }
}
async function createDatabase(config) {
    config = cleanConfig(config);
    if (!config.host || !config.username) {
        throw new Error("Missing SQL Server host or username.");
    }
    if (!/^[A-Za-z0-9_ -]{1,128}$/.test(config.database)) {
        throw new Error("Database name can only contain letters, numbers, spaces, underscores, and hyphens.");
    }
    let pool = null;
    try {
        pool = await connectToServer(config);
        const exists = await pool
            .request()
            .input("DatabaseName", mssql_1.default.NVarChar(128), config.database)
            .query("SELECT DB_ID(@DatabaseName) AS databaseId");
        if (!exists.recordset[0]?.databaseId) {
            await pool.request().query(`CREATE DATABASE ${quoteDatabaseName(config.database)}`);
        }
    }
    finally {
        if (pool)
            await pool.close();
    }
    return testConnection(config);
}
async function installDatabase(config) {
    config = cleanConfig(config);
    const before = await testConnection(config);
    if (!before.databaseExists) {
        throw new Error("Target database does not exist. Create it before running install.");
    }
    if (before.tableCount > 0) {
        throw new Error("Install can only run on an empty database.");
    }
    const installFolder = path_1.default.join(dataRoot(), config.role);
    const seedFolder = path_1.default.join(installFolder, "seed");
    const schemaFiles = readOrderFile(installFolder, "install_order.txt").filter((fileName) => fileName !== "00_database.sql");
    const seedFiles = fs_1.default.existsSync(seedFolder)
        ? readOrderFile(seedFolder, "seed_order.txt")
        : [];
    let pool = null;
    let transaction = null;
    let batchesExecuted = 0;
    let currentFile = "";
    let currentBatch = 0;
    const logger = createInstallLogger(config);
    logger.write(`Install started for ${config.role} database ${config.database} on ${config.host}:${config.port}.`);
    logger.write(`Schema files: ${schemaFiles.join(", ")}`);
    logger.write(`Seed files: ${seedFiles.join(", ") || "none"}`);
    try {
        pool = await connectToDatabase(config);
        transaction = new mssql_1.default.Transaction(pool);
        await transaction.begin(mssql_1.default.ISOLATION_LEVEL.SERIALIZABLE);
        logger.write("Transaction started.");
        for (const fileName of schemaFiles) {
            currentFile = fileName;
            currentBatch = 0;
            const filePath = path_1.default.join(installFolder, fileName);
            const sqlText = rewriteSqlForInstall(fs_1.default.readFileSync(filePath, "utf8"), config.role, config.database);
            const batches = fileName === "08_views.sql"
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
                await new mssql_1.default.Request(transaction).batch(batch);
                batchesExecuted += 1;
            }
        }
        for (const fileName of seedFiles) {
            currentFile = path_1.default.join("seed", fileName);
            currentBatch = 0;
            const filePath = path_1.default.join(seedFolder, fileName);
            const sqlText = rewriteSqlForInstall(fs_1.default.readFileSync(filePath, "utf8"), config.role, config.database);
            for (const batch of splitBatches(sqlText)) {
                currentBatch += 1;
                logger.write(`Executing ${currentFile} batch ${currentBatch}.`);
                await new mssql_1.default.Request(transaction).batch(batch);
                batchesExecuted += 1;
            }
        }
        await transaction.commit();
        logger.write(`Transaction committed. Batches executed: ${batchesExecuted}.`);
    }
    catch (error) {
        const details = sqlErrorDetails(error);
        logger.write(`ERROR in ${currentFile || "unknown file"} batch ${currentBatch || 0}: ${details}`);
        if (transaction) {
            try {
                await transaction.rollback();
                logger.write("Transaction rolled back.");
            }
            catch (rollbackError) {
                logger.write(`ROLLBACK FAILED: ${rollbackError.message || "Rollback failed."}`);
            }
        }
        throw new Error(`Install failed in ${currentFile || "unknown file"} batch ${currentBatch || 0}: ${details}. Log: ${logger.logPath}`);
    }
    finally {
        if (pool)
            await pool.close();
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
exports.default = {
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
exports.serverDatabaseTestInternals = {
    quoteDatabaseName,
    rewriteSqlForInstall,
    splitBatches,
    skippedLegacyViewName,
    skippedLegacyProcedureName,
    orderViewBatches,
};
