import express from "express";
import userController from "../controllers/users"; // 👈 default import
import authMiddleware from "../middleware/authMiddleware";

const router = express.Router();

// ✅ Get all users
router.get("/", authMiddleware.authenticate, userController.getAll);

// ✅ Get user by ID
router.get("/:id", authMiddleware.authenticate, userController.getById);

// ✅ Create user
router.post("/", authMiddleware.authenticate, userController.create);

// ✅ Assign role
router.post("/:id/assign-role", authMiddleware.authenticate, userController.assignRole);

// ✅ Get user roles
router.get("/:id/roles", authMiddleware.authenticate, userController.getRoles);

export default router;
