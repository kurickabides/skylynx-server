// ================================================
// ✅ Repository: protosRepository
// Description: Fetches Protos Template Tree for a Portal + Target lookups
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: protosRepository.ts
// ================================================

import { sql, poolPromise } from "../../../config/db";
import {
  PortalTemplateTree,
  TemplateType,
} from "../../../entities/protos/types";
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
// ================================================
// ✅ Function: getAllProtosTargetTypes
// Description: Loads all records from ProtosTargetType table
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// ================================================
export async function getAllProtosTargetTypes(): Promise<TemplateType[]> {
  try {
    const pool = await poolPromise;
    const result = await pool.request().execute("GetAllProtosTargetType");
    return result.recordset;
  } catch (error) {
    console.error("❌ Failed to load ProtosTargetTypes:", error);
    throw error;
  }
  
}

// ================================================
// ✅ Target Object Lookups by ID
// Description: Each function loads a specific target type via SP
// ================================================

export async function getPortalById(id: string) {
  const pool = await poolPromise;
  const result = await pool
    .request()
    .input("PortalID", sql.UniqueIdentifier, id)
    .execute("GetPortalById");
  return result.recordset[0];
}

export async function getLayoutById(id: string) {
  const pool = await poolPromise;
  const result = await pool
    .request()
    .input("LayoutID", sql.UniqueIdentifier, id)
    .execute("GetLayoutById");
  return result.recordset[0];
}

export async function getPageById(id: string) {
  const pool = await poolPromise;
  const result = await pool
    .request()
    .input("PageID", sql.UniqueIdentifier, id)
    .execute("GetPageDefinitionById");
  return result.recordset[0];
}

export async function getModuleById(id: string) {
  const pool = await poolPromise;
  const result = await pool
    .request()
    .input("ModuleID", sql.UniqueIdentifier, id)
    .execute("GetModuleById");
  return result.recordset[0];
}

export async function getDataModelById(id: string) {
  const pool = await poolPromise;
  const result = await pool
    .request()
    .input("DataModelID", sql.UniqueIdentifier, id)
    .execute("GetProtosDataModelById");
  return result.recordset[0];
}

export async function getDyFormById(id: string) {
  const pool = await poolPromise;
  const result = await pool
    .request()
    .input("FormID", sql.UniqueIdentifier, id)
    .execute("GetDyFormByID");
  return result.recordset[0];
}

export async function getDyFormVMById(id: string) {
  const pool = await poolPromise;
  const result = await pool
    .request()
    .input("ViewModelDefinitionID", sql.UniqueIdentifier, id)
    .execute("GetDyFormViewModelDefinitionById");
  return result.recordset[0];
}

export async function getThemeById(id: string) {
  const pool = await poolPromise;
  const result = await pool
    .request()
    .input("ThemeDefinitionID", sql.UniqueIdentifier, id)
    .execute("GetThemeDefinitionById");
  return result.recordset[0];
}
