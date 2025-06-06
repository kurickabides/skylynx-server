import express from "express";
import userController from "../controllers/users";
import authMiddleware from "../middleware/authMiddleware";

const router = express.Router();

// ✅ Test route with Admin authentication
router.get(
  "/roles/test/:id",
  authMiddleware.authenticate,
  authMiddleware.authorize("Admin"),
  (req, res) => {
    const { id } = req.params;
    res.json({
      message: "🔐 Auth passed. Admin access confirmed.",
      userId: id,
    });
  }
);

// ✅ Get all users
router.get("/", authMiddleware.authenticate, userController.getAll);

// ✅ Get user by ID
router.get("/:id", authMiddleware.authenticate, userController.getById);

// ✅ Create user
router.post("/", authMiddleware.authenticate, userController.create);

// ✅ Assign role to user (Admin only)
router.post(
  "/roles/:id",
  authMiddleware.authenticate,
  authMiddleware.authorize("Admin"),
  userController.assignRole
);

// ✅ Get roles for a user
router.get("/roles/:id", authMiddleware.authenticate, userController.getRoles);

export default router;
