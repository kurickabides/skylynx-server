"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.logger = void 0;
exports.logToSystem = logToSystem;
// ================================================
// ✅ Utility: logger (Winston + DB hook)
// Description: Structured logs to console and SystemLogs table
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: utils/logger.ts
// ================================================
const winston_1 = __importDefault(require("winston"));
const mssql_1 = __importDefault(require("mssql"));
const db_1 = require("../config/db");
exports.logger = winston_1.default.createLogger({
    level: process.env.LOG_LEVEL || "info",
    format: winston_1.default.format.combine(winston_1.default.format.timestamp(), winston_1.default.format.json()),
    transports: [new winston_1.default.transports.Console()],
});
// Minimal DB log helper for critical events
async function logToSystem(level, message, meta) {
    try {
        const pool = await db_1.poolPromise;
        await pool
            .request()
            .input("Level", mssql_1.default.NVarChar(20), level)
            .input("Message", mssql_1.default.NVarChar(mssql_1.default.MAX), message)
            .input("MetaJson", mssql_1.default.NVarChar(mssql_1.default.MAX), meta ? JSON.stringify(meta) : null)
            .execute("Protos.AppendSystemLog"); // create this SP to insert into SystemLogs
    }
    catch {
        // swallow to avoid recursive logging failures
    }
}
// Patch logger to also push important entries to DB
const originalInfo = exports.logger.info.bind(exports.logger);
exports.logger.info = ((msg, meta) => {
    logToSystem("info", typeof msg === "string" ? msg : JSON.stringify(msg), meta);
    return originalInfo(msg, meta);
});
const originalError = exports.logger.error.bind(exports.logger);
exports.logger.error = ((msg, meta) => {
    logToSystem("error", typeof msg === "string" ? msg : JSON.stringify(msg), meta);
    return originalError(msg, meta);
});
