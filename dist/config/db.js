"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.poolPromise = exports.sql = void 0;
const sql = __importStar(require("mssql"));
exports.sql = sql;
// Define the configuration object
const config = {
    user: process.env.DB_USER || "NOT_SET",
    password: process.env.DB_PASSWORD || "NOT_SET",
    server: process.env.DB_HOST || "NOT_SET",
    port: parseInt(process.env.DB_PORT || "1433", 10),
    database: process.env.DB_NAME || "NOT_SET",
    options: {
        encrypt: false,
        trustServerCertificate: true,
    },
};
// Debugging Logs
console.log("🔹 Database Configuration:");
console.log(`DB_USER: ${config.user}`);
console.log(`DB_PASSWORD: ${config.password ? "*****" : "NOT SET"}`);
console.log(`DB_HOST: ${config.server}`);
console.log(`DB_PORT: ${config.port}`);
console.log(`DB_NAME: ${config.database}`);
// Create and export the pool promise
const poolPromise = new sql.ConnectionPool(config)
    .connect()
    .then((pool) => {
    console.log("✅ Connected to SQL Server");
    return pool;
})
    .catch((err) => {
    console.error("❌ Database Connection Failed!", err);
    throw new Error("Database connection failed: " + err.message);
});
exports.poolPromise = poolPromise;
