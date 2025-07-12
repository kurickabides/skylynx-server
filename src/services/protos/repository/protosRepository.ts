// ================================================
// ✅ Repository: protosRepository
// Description: Fetches Protos Template Tree for a Portal
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename:protosRepository.ts
// ================================================

import { sql, poolPromise } from "../../../config/db";
import { PortalTemplateTree } from "../../../entities/protos/types";
import { mapPortalTemplateTree } from "../../../services/mappers/skylynxPortalMapper";

// ================================================
// ✅ Function: getSkylynxPortalTemplateTree
// Description: Loads Protos Template Tree using PortalName
// ================================================
export async function getSkylynxPortalTemplateTree(
  portalName: string
): Promise<PortalTemplateTree> {
  try {
    const pool = await poolPromise;
    const result = await pool
      .request()
      .input("PortalName", sql.NVarChar, portalName)
      .execute("LoadSkylynxPortalTree");

    const recordset = result.recordset;
    return mapPortalTemplateTree(recordset);
  } catch (error) {
    console.error("❌ Failed to load SkylynxPortalTemplateTree:", error);
    throw error;
  }
}
