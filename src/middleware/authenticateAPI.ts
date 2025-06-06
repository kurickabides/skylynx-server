// middleware/authenticateAPI.ts
import { Request, Response, NextFunction } from "express";
import crypto from "crypto";
import { poolPromise, sql } from "../config/db";

// Utility: Generate SHA-256 hash of a given string
function hashKey(input: string): string {
  return crypto.createHash("sha256").update(input).digest("hex");
}

// Middleware to authenticate requests based on x-portal-id and x-api-key headers
const authenticateAPI = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const portalId = req.headers["x-portal-id"] as string;
  const rawApiKey = req.headers["x-api-key"] as string;

  if (!portalId || !rawApiKey) {
    return res
      .status(400)
      .json({ error: "Missing x-portal-id or x-api-key header" });
  }

  const hashedKey = hashKey(rawApiKey);

  try {
    const pool = await poolPromise;
    const result = await pool
      .request()
      .input("PortalID", sql.UniqueIdentifier, portalId)
      .input("HashedKey", sql.NVarChar(256), hashedKey)
      .execute("ValidatePortalKey");

    if (result.recordset.length === 0) {
      return res.status(403).json({ error: "Invalid portal credentials" });
    }

    // Optional: Attach portal info to request object for later use
    (req as any).portal = result.recordset[0];
    next();
  } catch (error) {
    console.error("❌ API Key Validation Error:", error);
    res
      .status(500)
      .json({ error: "Internal Server Error during API validation" });
  }
};

export default authenticateAPI;
