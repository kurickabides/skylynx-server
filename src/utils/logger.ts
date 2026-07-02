// ================================================
// ✅ Utility: logger (Winston + DB hook)
// Description: Structured logs to console and SystemLogs table
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: utils/logger.ts
// ================================================
import winston from "winston";
import mssql from "mssql";
import { poolPromise } from "../config/db";

export const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || "info",
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [new winston.transports.Console()],
});

// Minimal DB log helper for critical events
export async function logToSystem(
  level: "info" | "error" | "warn",
  message: string,
  meta?: any
) {
  try {
    const pool = await poolPromise;
    await pool
      .request()
      .input("Level", mssql.NVarChar(20), level)
      .input("Message", mssql.NVarChar(mssql.MAX), message)
      .input(
        "MetaJson",
        mssql.NVarChar(mssql.MAX),
        meta ? JSON.stringify(meta) : null
      )
      .execute("Protos.AppendSystemLog"); // create this SP to insert into SystemLogs
  } catch {
    // swallow to avoid recursive logging failures
  }
}

// Patch logger to also push important entries to DB
const originalInfo = logger.info.bind(logger);
logger.info = ((msg: any, meta?: any) => {
  logToSystem(
    "info",
    typeof msg === "string" ? msg : JSON.stringify(msg),
    meta
  );
  return originalInfo(msg, meta);
}) as any;

const originalError = logger.error.bind(logger);
logger.error = ((msg: any, meta?: any) => {
  logToSystem(
    "error",
    typeof msg === "string" ? msg : JSON.stringify(msg),
    meta
  );
  return originalError(msg, meta);
}) as any;
