const express = require("express");
const {
  getRoles,
  createRoleController,
  assignRoleToUser,
} = require("../controllers/roles");
const authMiddleware = require("../middleware/authMiddleware");
const roleMiddleware = require("../middleware/roleMiddleware");

const router = express.Router();

// ✅ Get all roles
router.get("/", authMiddleware, getRoles);

// ✅ Create a new role (Admin only)
router.post("/", authMiddleware, roleMiddleware("Admin"), createRoleController);

// ✅ Assign a role to a user (Admin only)
router.post(
  "/assign",
  authMiddleware,
  roleMiddleware("Admin"),
  assignRoleToUser
);

module.exports = router;
