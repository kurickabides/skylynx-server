import { poolPromise, sql } from "../config/db";

const createPortal = async (
  portalName: string,
  description: string,
  ownerId: string
): Promise<string> => {
  try {
    const pool = await poolPromise;
    const result = await pool
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

const getPortalById = async (portalId: string) => {
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

const updatePortal = async (
  portalId: string,
  portalName: string,
  description: string
) => {
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

const deletePortal = async (portalId: string) => {
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
const getPortalsByUserID = async (userID: string) => {
  try {
    const pool = await poolPromise;
    const result = await pool
      .request()
      .input("UserID", sql.NVarChar(128), userID)
      .execute("skylynxnet_coredb.dbo.GetPortalsByUserID");

    return result.recordset;
  } catch (error) {
    console.error("❌ Error getting portals by user ID:", error);
    throw error;
  }
};
// ✅ PortalModel
const PortalModel = {
  createPortal,
  getAllPortals,
  getPortalsByUserID,
  getPortalById,
  updatePortal,
  deletePortal,
};

export default PortalModel;
