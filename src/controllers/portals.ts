import { Request, Response } from "express";
import PortalModel from "../services/portalModel";

// ✅ Create a new portal
const create = async (req: Request, res: Response) => {
  try {
    const { portalName, description, ownerId } = req.body;
    if (!portalName || !ownerId) {
      return res
        .status(400)
        .json({ error: "Portal Name and Owner ID are required" });
    }

    const newPortalId = await PortalModel.createPortal(
      portalName,
      description,
      ownerId
    );
    res
      .status(201)
      .json({ message: "Portal created successfully", newPortalId });
  } catch (error) {
    console.error("❌ Error creating portal:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// ✅ Get all portals
const getAll = async (req: Request, res: Response) => {
  try {
    const portals = await PortalModel.getAllPortals();
    res.json(portals);
  } catch (error) {
    console.error("❌ Error fetching portals:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// ✅ Get a single portal
const getById = async (req: Request, res: Response) => {
  try {
    const portalId = req.params.id;
    const portal = await PortalModel.getPortalById(portalId);

    if (!portal) {
      return res.status(404).json({ error: "Portal not found" });
    }

    res.json(portal);
  } catch (error) {
    console.error("❌ Error fetching portal:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

const getPortalsByUser = async (req: Request, res: Response) => {
  try {

    const { userID } = req.body;

    if (!userID) {
      return res.status(400).json({ error: "Missing userID in request body." });
    }
    const portals = await PortalModel.getPortalsByUserID(userID);
    res.json({ portals });
  } catch (err) {
    console.error("Error in getPortalsByUser:", err);
    res.status(500).json({ error: "Failed to retrieve portals." });
  }
};

// ✅ Update a portal
const update = async (req: Request, res: Response) => {
  try {
    const portalId = req.params.id;
    const { portalName, description } = req.body;

    if (!portalName) {
      return res.status(400).json({ error: "Portal Name is required" });
    }

    await PortalModel.updatePortal(portalId, portalName, description);
    res.json({ message: "Portal updated successfully" });
  } catch (error) {
    console.error("❌ Error updating portal:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// ✅ Delete a portal
const remove = async (req: Request, res: Response) => {
  try {
    const portalId = req.params.id;
    await PortalModel.deletePortal(portalId);
    res.json({ message: "Portal deleted successfully" });
  } catch (error) {
    console.error("❌ Error deleting portal:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// ✅ Export with named module pattern
const portalController = {
  create,
  getAll,
  getById,
  getPortalsByUser,
  update,
  remove,
};

export default portalController;
