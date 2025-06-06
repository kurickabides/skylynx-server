import express from "express";
import portalController from "../controllers/portals";
import authMiddleware from "../middleware/authMiddleware";

const router = express.Router();

// ✅ Get all portals (authenticated users)
router.get("/", authMiddleware.authenticate, portalController.getAll);

// ✅ Get portal by ID
router.get("/:id", authMiddleware.authenticate, portalController.getById);

// ✅ Create new portal
router.post("/", authMiddleware.authenticate, portalController.create);

// ✅ Update portal
router.put("/:id", authMiddleware.authenticate, portalController.update);

// ✅ Delete portal
router.delete("/:id", authMiddleware.authenticate, portalController.remove);

export default router;
