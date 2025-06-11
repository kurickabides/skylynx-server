import { Request, Response, NextFunction } from "express";
import { poolPromise, sql } from "../config/db";

const authenticateAPI = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const rawApiKey = req.headers["skyx-api-key"] as string;

  if (!rawApiKey) {
    console.warn("❌ Missing skyx-api-key header");
    return res.status(400).json({ error: "Missing skyx-api-key header" });
  }

  try {
    const pool = await poolPromise;

    // 🔍 Step 1: Look up hashed key and portal from view
    const keyResult = await pool
      .request()
      .input("ApiKeyID", sql.NVarChar(256), rawApiKey).query(`
        SELECT KeyHash, PortalName 
        FROM vw_ActiveAPIKeys 
        WHERE ApiKeyID = @ApiKeyID
      `);

    const keyRecord = keyResult.recordset?.[0];

    if (!keyRecord) {
      console.warn("❌ API key not found in view");
      return res.status(403).json({ error: "Invalid API key" });
    }

    const { KeyHash, PortalName } = keyRecord;

    // 🔐 Step 2: Validate via SP
    const validateResult = await pool
      .request()
      .input("ApiKey", sql.NVarChar(256), KeyHash)
      .execute("ValidateApiKey");

    if (!validateResult.recordset?.[0]) {
      console.warn("❌ API key hash is invalid according to SP");
      return res.status(403).json({ error: "API key validation failed" });
    }

    console.log("✅ API key authenticated:", PortalName);
    (req as any).portalName = PortalName;
    next();
  } catch (error: any) {
    console.error("❌ API Key Auth Error:", error.message || error);
    res.status(500).json({
      error: "API key validation error",
      details: error.message || "Unknown error",
    });
  }
};

export default authenticateAPI;
