"use strict";
// ================================================
// ✅ Middleware: authenticateAPI
// Description: Validates portal API keys and attaches portal context
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: middleware/authenticateAPI.ts
// ================================================
Object.defineProperty(exports, "__esModule", { value: true });
const db_1 = require("../config/db");
const authenticateAPI = async (req, res, next) => {
    const rawApiKey = req.headers["skyx-api-key"];
    if (!rawApiKey) {
        console.warn("❌ Missing skyx-api-key header");
        return res.status(400).json({ error: "Missing skyx-api-key header" });
    }
    try {
        const pool = await db_1.poolPromise;
        // 🔍 Step 1: Look up hashed key and portal from view
        const keyResult = await pool
            .request()
            .input("ApiKeyID", db_1.sql.NVarChar(256), rawApiKey).query(`
        SELECT KeyHash, PortalName,PortalID
        FROM vw_ActiveAPIKeys 
        WHERE ApiKeyID = @ApiKeyID
      `);
        const keyRecord = keyResult.recordset?.[0];
        if (!keyRecord) {
            console.warn("❌ API key not found in view");
            return res.status(403).json({ error: "Invalid API key" });
        }
        const { KeyHash, PortalName, PortalID } = keyRecord;
        // 🔐 Step 2: Validate via SP
        const validateResult = await pool
            .request()
            .input("ApiKey", db_1.sql.NVarChar(256), KeyHash)
            .execute("ValidateApiKey");
        if (!validateResult.recordset?.[0]) {
            console.warn("❌ API key hash is invalid according to SP");
            return res.status(403).json({ error: "API key validation failed" });
        }
        req.apiKey = rawApiKey;
        req.portalName = PortalName;
        req.portalId = PortalID;
        console.log(`✅ API key authenticated: Key=${rawApiKey} | PortalName=${PortalName} | PortalID=${PortalID}`);
        next();
    }
    catch (error) {
        console.error("❌ API Key Auth Error:", error.message || error);
        res.status(500).json({
            error: "API key validation error",
            details: error.message || "Unknown error",
        });
    }
};
exports.default = authenticateAPI;
