"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const portalModel_1 = __importDefault(require("../services/portalModel"));
// ✅ Create a new portal
const create = async (req, res) => {
    try {
        const { portalName, description, ownerId } = req.body;
        if (!portalName || !ownerId) {
            return res
                .status(400)
                .json({ error: "Portal Name and Owner ID are required" });
        }
        const newPortalId = await portalModel_1.default.createPortal(portalName, description, ownerId);
        res
            .status(201)
            .json({ message: "Portal created successfully", newPortalId });
    }
    catch (error) {
        console.error("❌ Error creating portal:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
};
// ✅ Get all portals
const getAll = async (req, res) => {
    try {
        const portals = await portalModel_1.default.getAllPortals();
        res.json(portals);
    }
    catch (error) {
        console.error("❌ Error fetching portals:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
};
// ✅ Get a single portal
const getById = async (req, res) => {
    try {
        const portalId = req.params.id;
        const portal = await portalModel_1.default.getPortalById(portalId);
        if (!portal) {
            return res.status(404).json({ error: "Portal not found" });
        }
        res.json(portal);
    }
    catch (error) {
        console.error("❌ Error fetching portal:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
};
// ✅ Update a portal
const update = async (req, res) => {
    try {
        const portalId = req.params.id;
        const { portalName, description } = req.body;
        if (!portalName) {
            return res.status(400).json({ error: "Portal Name is required" });
        }
        await portalModel_1.default.updatePortal(portalId, portalName, description);
        res.json({ message: "Portal updated successfully" });
    }
    catch (error) {
        console.error("❌ Error updating portal:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
};
// ✅ Delete a portal
const remove = async (req, res) => {
    try {
        const portalId = req.params.id;
        await portalModel_1.default.deletePortal(portalId);
        res.json({ message: "Portal deleted successfully" });
    }
    catch (error) {
        console.error("❌ Error deleting portal:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
};
// ✅ Export with named module pattern
const portalController = {
    create,
    getAll,
    getById,
    update,
    remove,
};
exports.default = portalController;
