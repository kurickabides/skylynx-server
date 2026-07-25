"use strict";
// ================================================
// ✅ Module: portalCache.ts
// Description: In-memory cache for portals, refreshed daily
// ================================================
Object.defineProperty(exports, "__esModule", { value: true });
exports.getCachedPortals = exports.loadPortals = void 0;
const db_1 = require("../config/db");
let cachedPortals = [];
let lastUpdated = 0;
const REFRESH_INTERVAL = 1000 * 60 * 60 * 24; // 24 hours
const loadPortals = async () => {
    const pool = await db_1.poolPromise;
    const result = await pool.request().execute("GetActivePortals");
    cachedPortals = result.recordset;
    lastUpdated = Date.now();
    console.log("🔄 Portal cache refreshed via GetActivePortals SP");
};
exports.loadPortals = loadPortals;
const getCachedPortals = async () => {
    if (Date.now() - lastUpdated > REFRESH_INTERVAL ||
        cachedPortals.length === 0) {
        await (0, exports.loadPortals)();
    }
    return cachedPortals;
};
exports.getCachedPortals = getCachedPortals;
