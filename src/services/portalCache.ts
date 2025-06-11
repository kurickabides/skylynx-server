// ================================================
// ✅ Module: portalCache.ts
// Description: In-memory cache for portals, refreshed daily
// ================================================

import { poolPromise, sql } from "../config/db";

let cachedPortals: any[] = [];
let lastUpdated: number = 0;
const REFRESH_INTERVAL = 1000 * 60 * 60 * 24; // 24 hours

export const loadPortals = async () => {
  const pool = await poolPromise;
  const result = await pool.request().execute("GetActivePortals");
  cachedPortals = result.recordset;
  lastUpdated = Date.now();
  console.log("🔄 Portal cache refreshed via GetActivePortals SP");
};
export const getCachedPortals = async (): Promise<any[]> => {
  if (
    Date.now() - lastUpdated > REFRESH_INTERVAL ||
    cachedPortals.length === 0
  ) {
    await loadPortals();
  }
  return cachedPortals;
};
