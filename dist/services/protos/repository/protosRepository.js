"use strict";
// ================================================
// ✅ Repository: protosRepository
// Description: Fetches Protos Template Tree for a Portal + Target lookups
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: protosRepository.ts
// ================================================
Object.defineProperty(exports, "__esModule", { value: true });
exports.getSkylynxPortalTemplateTree = getSkylynxPortalTemplateTree;
exports.getProtosTreeViewModelConfig = getProtosTreeViewModelConfig;
exports.getAllProtosTargetTypes = getAllProtosTargetTypes;
exports.getPortalById = getPortalById;
exports.getLayoutById = getLayoutById;
exports.getPageById = getPageById;
exports.getModuleById = getModuleById;
exports.getDataModelById = getDataModelById;
exports.getDyFormById = getDyFormById;
exports.getDyFormVMById = getDyFormVMById;
exports.getThemeById = getThemeById;
const db_1 = require("../../../config/db");
const skylynxPortalMapper_1 = require("../../../services/mappers/skylynxPortalMapper");
// ================================================
// ✅ Function: getSkylynxPortalTemplateTree
// Description: Loads Protos Template Tree using PortalName
// ================================================
async function getSkylynxPortalTemplateTree(portalName) {
    try {
        const pool = await db_1.poolPromise;
        const result = await pool
            .request()
            .input("PortalName", db_1.sql.NVarChar, portalName)
            .execute("LoadSkylynxPortalTree");
        const recordset = result.recordset;
        return (0, skylynxPortalMapper_1.mapPortalTemplateTree)(recordset);
    }
    catch (error) {
        console.error("❌ Failed to load SkylynxPortalTemplateTree:", error);
        throw error;
    }
}
async function getProtosTreeViewModelConfig(portalName) {
    return getSkylynxPortalTemplateTree(portalName);
}
// ================================================
// ✅ Function: getAllProtosTargetTypes
// Description: Loads all records from ProtosTargetType table
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// ================================================
async function getAllProtosTargetTypes() {
    try {
        const pool = await db_1.poolPromise;
        const result = await pool.request().execute("GetAllProtosTargetType");
        return result.recordset;
    }
    catch (error) {
        console.error("❌ Failed to load ProtosTargetTypes:", error);
        throw error;
    }
}
// ================================================
// ✅ Target Object Lookups by ID
// Description: Each function loads a specific target type via SP
// ================================================
async function getPortalById(id) {
    const pool = await db_1.poolPromise;
    const result = await pool
        .request()
        .input("PortalID", db_1.sql.UniqueIdentifier, id)
        .execute("GetPortalById");
    return result.recordset[0];
}
async function getLayoutById(id) {
    const pool = await db_1.poolPromise;
    const result = await pool
        .request()
        .input("LayoutID", db_1.sql.UniqueIdentifier, id)
        .execute("GetLayoutById");
    return result.recordset[0];
}
async function getPageById(id) {
    const pool = await db_1.poolPromise;
    const result = await pool
        .request()
        .input("PageID", db_1.sql.UniqueIdentifier, id)
        .execute("GetPageDefinitionById");
    return result.recordset[0];
}
async function getModuleById(id) {
    const pool = await db_1.poolPromise;
    const result = await pool
        .request()
        .input("ModuleID", db_1.sql.UniqueIdentifier, id)
        .execute("GetModuleById");
    return result.recordset[0];
}
async function getDataModelById(id) {
    const pool = await db_1.poolPromise;
    const result = await pool
        .request()
        .input("DataModelID", db_1.sql.UniqueIdentifier, id)
        .execute("GetProtosDataModelById");
    return result.recordset[0];
}
async function getDyFormById(id) {
    const pool = await db_1.poolPromise;
    const result = await pool
        .request()
        .input("FormID", db_1.sql.UniqueIdentifier, id)
        .execute("GetDyFormByID");
    return result.recordset[0];
}
async function getDyFormVMById(id) {
    const pool = await db_1.poolPromise;
    const result = await pool
        .request()
        .input("ViewModelDefinitionID", db_1.sql.UniqueIdentifier, id)
        .execute("GetDyFormViewModelDefinitionById");
    return result.recordset[0];
}
async function getThemeById(id) {
    const pool = await db_1.poolPromise;
    const result = await pool
        .request()
        .input("ThemeDefinitionID", db_1.sql.UniqueIdentifier, id)
        .execute("GetThemeDefinitionById");
    return result.recordset[0];
}
