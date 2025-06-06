import express from "express";
import roleController from "../controllers/roles";
import authMiddleware from "../middleware/authMiddleware";

const router = express.Router();

// ✅ Get all roles (authenticated users)
router.get("/", authMiddleware.authenticate, roleController.getAll);

// ✅ Create a new role (Admin only)
router.post(
  "/",
  authMiddleware.authenticate,
  authMiddleware.authorize("Admin"),
  roleController.create
);

// ✅ Assign a role to a user (Admin only)
router.post(
  "/assign",
  authMiddleware.authenticate,
  authMiddleware.authorize("Admin"),
  roleController.assignToUser
);

export default router;
