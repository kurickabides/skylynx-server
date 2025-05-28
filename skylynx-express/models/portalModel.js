const { poolPromise, sql } = require("../config/db");

// ✅ Create a new portal using stored procedure
const createPortal = async (portalName, description, ownerId) => {
  try {
    const pool = await poolPromise;
    let result = await pool
      .request()
      .input("PortalName", sql.NVarChar, portalName)
      .input("Description", sql.NVarChar, description)
      .input("OwnerID", sql.UniqueIdentifier, ownerId)
      .output("NewPortalID", sql.UniqueIdentifier)
      .execute("CreatePortal");

    return result.output.NewPortalID;
  } catch (error) {
    console.error("❌ Error creating portal:", error);
    throw error;
  }
};

// ✅ Get all portals
const getAllPortals = async () => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().execute("GetAllPortals");
    return result.recordset;
  } catch (error) {
    console.error("❌ Error fetching portals:", error);
    throw error;
  }
};

// ✅ Get a portal by ID
const getPortalById = async (portalId) => {
  try {
    const pool = await poolPromise;
    const result = await pool
      .request()
      .input("PortalID", sql.UniqueIdentifier, portalId)
      .execute("GetPortalById");

    return result.recordset.length > 0 ? result.recordset[0] : null;
  } catch (error) {
    console.error("❌ Error fetching portal:", error);
    throw error;
  }
};

// ✅ Update a portal
const updatePortal = async (portalId, portalName, description) => {
  try {
    const pool = await poolPromise;
    await pool
      .request()
      .input("PortalID", sql.UniqueIdentifier, portalId)
      .input("PortalName", sql.NVarChar, portalName)
      .input("Description", sql.NVarChar, description)
      .execute("UpdatePortal");

    return { message: "Portal updated successfully" };
  } catch (error) {
    console.error("❌ Error updating portal:", error);
    throw error;
  }
};

// ✅ Delete a portal
const deletePortal = async (portalId) => {
  try {
    const pool = await poolPromise;
    await pool
      .request()
      .input("PortalID", sql.UniqueIdentifier, portalId)
      .execute("DeletePortal");

    return { message: "Portal deleted successfully" };
  } catch (error) {
    console.error("❌ Error deleting portal:", error);
    throw error;
  }
};

module.exports = {
  createPortal,
  getAllPortals,
  getPortalById,
  updatePortal,
  deletePortal,
};
