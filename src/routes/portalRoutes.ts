import express from "express";
import portalController from "../controllers/portals";
import authMiddleware from "../middleware/authMiddleware";

const router = express.Router();

// ✅ Get all portals (authenticated users)
router.get("/", portalController.getAll);

// ✅ Get portal by ID
router.get("/:id", portalController.getById);

// ✅ Create new portal
router.post("/", portalController.create);

// ✅ Update portal
router.put("/:id",portalController.update);

// ✅ Delete portal
router.delete("/:id", portalController.remove);

router.post("/byuser",portalController.getPortalsByUser);

router.post("/byapikey", portalController.getPortalByAPIKey);

export default router;
