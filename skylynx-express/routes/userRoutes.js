const express = require("express");
const {
  getUsers,
  getUser,
  createUserController,
  assignRoleToUser,
  getUserRolesController,
} = require("../controllers/users");
const authMiddleware = require("../middleware/authMiddleware");
const roleMiddleware = require("../middleware/roleMiddleware");

const router = express.Router();

// ✅ Get all users (Requires authentication)
router.get("/", authMiddleware, roleMiddleware("Admin"), getUsers);

// ✅ Get a specific user by ID (Requires authentication)
router.get(
  "/:id",
  authMiddleware,
  roleMiddleware("Admin"),
  getUser
);

// ✅ Create a new user (Admin only)
router.post("/", authMiddleware, roleMiddleware("Admin"), createUserController);

// ✅ Get user roles (Admin and Manager can view)
router.get(
  "/:id/roles",
  authMiddleware,
  roleMiddleware("Admin"),
  getUserRolesController
);

// ✅ Assign role to a user (Admin only)
router.post(
  "/:id/roles",
  authMiddleware,
  roleMiddleware("Admin"),
  assignRoleToUser
);

module.exports = router;
