// ================================================
// ✅ Route: serverSettingsRoutes
// Description: Protected local server settings endpoints
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: routes/serverSettingsRoutes.ts
// ================================================

import express from "express";
import { authenticateServerAdmin } from "../middleware/serverAdminMiddleware";
import serverAdminService from "../services/serverAdminService";
import serverDatabaseService from "../services/serverDatabaseService";

const router = express.Router();

router.get("/status", authenticateServerAdmin, (_req, res) => {
  const status = serverAdminService.getStatus();
  res.json({
    configured: status.configured,
    adminDir: status.adminDir,
    databaseProvider: "sqlserver",
    settingsPath: "/server/settings",
  });
});

router.get("/database", authenticateServerAdmin, (_req, res) => {
  res.json({
    provider: "sqlserver",
    primaryCore: {
      ...serverDatabaseService.primaryCoreConfig(),
      password: undefined,
      passwordConfigured: Boolean(process.env.DB_PASSWORD),
    },
    primaryPortal: {
      ...serverDatabaseService.primaryPortalConfig(),
      password: undefined,
      passwordConfigured: Boolean(process.env.DB_PORTAL_PASSWORD || process.env.DB_PASSWORD),
    },
    backupCore: {
      ...serverDatabaseService.backupCoreConfig(),
      password: undefined,
      passwordConfigured: Boolean(process.env.DB_BACKUP_PASSWORD),
    },
    backupPortal: {
      ...serverDatabaseService.backupPortalConfig(),
      password: undefined,
      passwordConfigured: Boolean(process.env.DB_BACKUP_PORTAL_PASSWORD || process.env.DB_BACKUP_PASSWORD),
    },
  });
});

router.post("/database/test-primary", authenticateServerAdmin, async (_req, res) => {
  const result = await serverDatabaseService.testConnection(
    serverDatabaseService.primaryCoreConfig()
  );
  res.status(result.ok ? 200 : 200).json(result);
});

router.post("/database/test-backup", authenticateServerAdmin, async (_req, res) => {
  const result = await serverDatabaseService.testConnection(
    serverDatabaseService.backupCoreConfig()
  );
  res.status(200).json(result);
});

router.post("/database/test", authenticateServerAdmin, async (req, res) => {
  const target = req.body.target || "primaryCore";
  const result = await serverDatabaseService.testConnection(
    serverDatabaseService.cleanConfig({
      ...serverDatabaseService.configForTarget(target),
      ...req.body,
    })
  );
  res.status(200).json(result);
});

router.post("/database/list", authenticateServerAdmin, async (req, res) => {
  try {
    const target = req.body.target || "primaryCore";
    const databases = await serverDatabaseService.listDatabases(
      serverDatabaseService.cleanConfig({
        ...serverDatabaseService.configForTarget(target),
        ...req.body,
      })
    );
    res.json({ databases });
  } catch (error: any) {
    res.status(400).json({ error: error.message || "Failed to list databases." });
  }
});

router.post("/database/create", authenticateServerAdmin, async (req, res) => {
  try {
    const target = req.body.target || "primaryCore";
    const result = await serverDatabaseService.createDatabase(
      serverDatabaseService.cleanConfig({
        ...serverDatabaseService.configForTarget(target),
        ...req.body,
      })
    );
    res.status(201).json(result);
  } catch (error: any) {
    res.status(400).json({ error: error.message || "Failed to create database." });
  }
});

router.post("/database/install", authenticateServerAdmin, async (req, res) => {
  try {
    const target = req.body.target || "primaryCore";
    const result = await serverDatabaseService.installDatabase(
      serverDatabaseService.cleanConfig({
        ...serverDatabaseService.configForTarget(target),
        ...req.body,
      })
    );
    res.status(201).json(result);
  } catch (error: any) {
    res.status(400).json({ error: error.message || "Failed to install database." });
  }
});

export default router;
