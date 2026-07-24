// ================================================
// ✅ Utility: installProbe
// Description: Disposable installer probe for skylynx_install_probe only
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: scripts/installProbe.js
// ================================================

require("ts-node/register/transpile-only");
require("dotenv").config({ path: "local.env" });

const sql = require("mssql");
const serverDatabaseService = require("../src/services/serverDatabaseService").default;

const PROBE_DATABASE = "skylynx_install_probe";

async function recreateProbeDatabase(config) {
  const pool = await sql.connect({
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

  try {
    await pool.request().batch(`
      IF DB_ID(N'${PROBE_DATABASE}') IS NOT NULL
      BEGIN
        ALTER DATABASE [${PROBE_DATABASE}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
        DROP DATABASE [${PROBE_DATABASE}];
      END;
      CREATE DATABASE [${PROBE_DATABASE}];
    `);
  } finally {
    await pool.close();
  }
}

async function main() {
  const config = {
    ...serverDatabaseService.primaryCoreConfig(),
    database: PROBE_DATABASE,
    role: "core",
  };

  await recreateProbeDatabase(config);
  const result = await serverDatabaseService.installDatabase(config);
  console.log(JSON.stringify({
    ok: true,
    database: PROBE_DATABASE,
    batchesExecuted: result.batchesExecuted,
    message: result.message,
    log: result.installLogPath,
  }, null, 2));
}

main().catch((error) => {
  console.error(error.message || error);
  process.exit(1);
});
