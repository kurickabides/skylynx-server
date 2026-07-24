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
    host: process.env.DB_HOST || "",
    port: process.env.DB_PORT || "1433",
    coreDatabase: process.env.DB_NAME || "skylynxnet_coredb",
    portalDatabase: "skylynx_portal_template",
    username: process.env.DB_USER || "",
    passwordConfigured: Boolean(process.env.DB_PASSWORD),
    backupHost: process.env.DB_BACKUP_HOST || "",
    backupPort: process.env.DB_BACKUP_PORT || "",
    backupCoreDatabase: process.env.DB_BACKUP_NAME || "",
    backupUsername: process.env.DB_BACKUP_USER || "",
    backupPasswordConfigured: Boolean(process.env.DB_BACKUP_PASSWORD),
  });
});

router.post("/database/test-primary", authenticateServerAdmin, async (_req, res) => {
  const result = await serverDatabaseService.testConnection(
    serverDatabaseService.primaryConfig()
  );
  res.status(result.ok ? 200 : 200).json(result);
});

router.post("/database/test-backup", authenticateServerAdmin, async (_req, res) => {
  const result = await serverDatabaseService.testConnection(
    serverDatabaseService.backupConfig()
  );
  res.status(200).json(result);
});

export default router;
