"use strict";
// ================================================
// ✅ Route: serverSettingsRoutes
// Description: Protected local server settings endpoints
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: routes/serverSettingsRoutes.ts
// ================================================
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const serverAdminMiddleware_1 = require("../middleware/serverAdminMiddleware");
const serverAdminService_1 = __importDefault(require("../services/serverAdminService"));
const serverDatabaseService_1 = __importDefault(require("../services/serverDatabaseService"));
const router = express_1.default.Router();
router.get("/status", serverAdminMiddleware_1.authenticateServerAdmin, (_req, res) => {
    const status = serverAdminService_1.default.getStatus();
    res.json({
        configured: status.configured,
        adminDir: status.adminDir,
        databaseProvider: "sqlserver",
        settingsPath: "/server/settings",
    });
});
router.get("/database", serverAdminMiddleware_1.authenticateServerAdmin, (_req, res) => {
    res.json({
        provider: "sqlserver",
        primaryCore: {
            ...serverDatabaseService_1.default.primaryCoreConfig(),
            password: undefined,
            passwordConfigured: Boolean(process.env.DB_PASSWORD),
        },
        primaryPortal: {
            ...serverDatabaseService_1.default.primaryPortalConfig(),
            password: undefined,
            passwordConfigured: Boolean(process.env.DB_PORTAL_PASSWORD || process.env.DB_PASSWORD),
        },
        backupCore: {
            ...serverDatabaseService_1.default.backupCoreConfig(),
            password: undefined,
            passwordConfigured: Boolean(process.env.DB_BACKUP_PASSWORD),
        },
        backupPortal: {
            ...serverDatabaseService_1.default.backupPortalConfig(),
            password: undefined,
            passwordConfigured: Boolean(process.env.DB_BACKUP_PORTAL_PASSWORD || process.env.DB_BACKUP_PASSWORD),
        },
    });
});
router.post("/database/test-primary", serverAdminMiddleware_1.authenticateServerAdmin, async (_req, res) => {
    const result = await serverDatabaseService_1.default.testConnection(serverDatabaseService_1.default.primaryCoreConfig());
    res.status(result.ok ? 200 : 200).json(result);
});
router.post("/database/test-backup", serverAdminMiddleware_1.authenticateServerAdmin, async (_req, res) => {
    const result = await serverDatabaseService_1.default.testConnection(serverDatabaseService_1.default.backupCoreConfig());
    res.status(200).json(result);
});
router.post("/database/test", serverAdminMiddleware_1.authenticateServerAdmin, async (req, res) => {
    const target = req.body.target || "primaryCore";
    const result = await serverDatabaseService_1.default.testConnection(serverDatabaseService_1.default.cleanConfig({
        ...serverDatabaseService_1.default.configForTarget(target),
        ...req.body,
    }));
    res.status(200).json(result);
});
router.post("/database/list", serverAdminMiddleware_1.authenticateServerAdmin, async (req, res) => {
    try {
        const target = req.body.target || "primaryCore";
        const databases = await serverDatabaseService_1.default.listDatabases(serverDatabaseService_1.default.cleanConfig({
            ...serverDatabaseService_1.default.configForTarget(target),
            ...req.body,
        }));
        res.json({ databases });
    }
    catch (error) {
        res.status(400).json({ error: error.message || "Failed to list databases." });
    }
});
router.post("/database/create", serverAdminMiddleware_1.authenticateServerAdmin, async (req, res) => {
    try {
        const target = req.body.target || "primaryCore";
        const result = await serverDatabaseService_1.default.createDatabase(serverDatabaseService_1.default.cleanConfig({
            ...serverDatabaseService_1.default.configForTarget(target),
            ...req.body,
        }));
        res.status(201).json(result);
    }
    catch (error) {
        res.status(400).json({ error: error.message || "Failed to create database." });
    }
});
router.post("/database/install", serverAdminMiddleware_1.authenticateServerAdmin, async (req, res) => {
    try {
        const target = req.body.target || "primaryCore";
        const result = await serverDatabaseService_1.default.installDatabase(serverDatabaseService_1.default.cleanConfig({
            ...serverDatabaseService_1.default.configForTarget(target),
            ...req.body,
        }));
        res.status(201).json(result);
    }
    catch (error) {
        res.status(400).json({ error: error.message || "Failed to install database." });
    }
});
exports.default = router;
