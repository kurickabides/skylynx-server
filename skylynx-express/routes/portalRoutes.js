const express = require("express");
const {
  createPortalController,
  getAllPortalsController,
  getPortalByIdController,
  updatePortalController,
  deletePortalController,
} = require("../controllers/portals");

const authMiddleware = require("../middleware/authMiddleware");
const roleMiddleware = require("../middleware/roleMiddleware");

const router = express.Router();

// ✅ Create a new portal (Admin Only)
router.post(
  "/",
  authMiddleware,
  roleMiddleware(["Admin"]),
  createPortalController
);

// ✅ Get all portals
router.get("/", authMiddleware, getAllPortalsController);

// ✅ Get a specific portal
router.get("/:id", authMiddleware, getPortalByIdController);

// ✅ Update a portal (Admin Only)
router.put(
  "/:id",
  authMiddleware,
  roleMiddleware(["Admin"]),
  updatePortalController
);

// ✅ Delete a portal (Admin Only)
router.delete(
  "/:id",
  authMiddleware,
  roleMiddleware(["Admin"]),
  deletePortalController
);

module.exports = router;
