"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const db_1 = require("../config/db");
const createPortal = async (portalName, description, ownerId) => {
    try {
        const pool = await db_1.poolPromise;
        const result = await pool
            .request()
            .input("PortalName", db_1.sql.NVarChar, portalName)
            .input("Description", db_1.sql.NVarChar, description)
            .input("OwnerID", db_1.sql.UniqueIdentifier, ownerId)
            .output("NewPortalID", db_1.sql.UniqueIdentifier)
            .execute("CreatePortal");
        return result.output.NewPortalID;
    }
    catch (error) {
        console.error("❌ Error creating portal:", error);
        throw error;
    }
};
const getAllPortals = async () => {
    try {
        const pool = await db_1.poolPromise;
        const result = await pool.request().execute("GetAllPortals");
        return result.recordset;
    }
    catch (error) {
        console.error("❌ Error fetching portals:", error);
        throw error;
    }
};
const getPortalById = async (portalId) => {
    try {
        const pool = await db_1.poolPromise;
        const result = await pool
            .request()
            .input("PortalID", db_1.sql.UniqueIdentifier, portalId)
            .execute("GetPortalById");
        return result.recordset.length > 0 ? result.recordset[0] : null;
    }
    catch (error) {
        console.error("❌ Error fetching portal:", error);
        throw error;
    }
};
const updatePortal = async (portalId, portalName, description) => {
    try {
        const pool = await db_1.poolPromise;
        await pool
            .request()
            .input("PortalID", db_1.sql.UniqueIdentifier, portalId)
            .input("PortalName", db_1.sql.NVarChar, portalName)
            .input("Description", db_1.sql.NVarChar, description)
            .execute("UpdatePortal");
        return { message: "Portal updated successfully" };
    }
    catch (error) {
        console.error("❌ Error updating portal:", error);
        throw error;
    }
};
const deletePortal = async (portalId) => {
    try {
        const pool = await db_1.poolPromise;
        await pool
            .request()
            .input("PortalID", db_1.sql.UniqueIdentifier, portalId)
            .execute("DeletePortal");
        return { message: "Portal deleted successfully" };
    }
    catch (error) {
        console.error("❌ Error deleting portal:", error);
        throw error;
    }
};
// ✅ PortalModel
const PortalModel = {
    createPortal,
    getAllPortals,
    getPortalById,
    updatePortal,
    deletePortal,
};
exports.default = PortalModel;
