// ================================================
// ✅ Middleware: authenticateAPI
// Description: Validates API key + portal name from headers
// ================================================

import { Request, Response, NextFunction } from "express";
import { poolPromise, sql } from "../config/db";

const authenticateAPI = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const portalName = req.headers["skyx-portal-id"] as string;
  const rawApiKey = req.headers["skyx-api-key"] as string;

  console.log("🔍 Incoming Headers:");
  console.log(" - skyx-portal-id:", portalName);
  console.log(" - skyx-api-key:", rawApiKey);

  if (!portalName || !rawApiKey) {
    console.warn("❌ Missing one or both required headers");
    return res.status(400).json({
      error: "Missing skyx-portal-id or skyx-api-key header",
    });
  }

  try {
    const pool = await poolPromise;
    console.log("📨 Executing ValidateOwnerApiKey with inputs:");
    console.log(" - PlainApiKey:", rawApiKey);
    console.log(" - PortalName:", portalName);

    const result = await pool
      .request()
      .input("PlainApiKey", sql.NVarChar(sql.MAX), rawApiKey)
      .input("PortalName", sql.NVarChar(100), portalName)
      .execute("ValidateOwnerApiKey");

    console.log("✅ Stored Procedure Result:");
    console.log(result.recordset);

    const isValid = result.recordset?.[0]?.IsValid === true;

    if (!isValid) {
      console.warn("❌ Validation failed:", result.recordset);
      return res.status(403).json({ error: "Invalid portal credentials" });
    }

    (req as any).portalName = portalName;
    next();
  } catch (error: any) {
    console.error("❌ API Key Validation Error:", error);
    const message =
      error?.originalError?.info?.message || error.message || "Unknown error";
    res.status(500).json({
      error: "API key validation failed",
      details: message,
    });
  }
};

export default authenticateAPI;
