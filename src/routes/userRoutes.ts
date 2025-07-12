import express from "express";
import userController from "../controllers/users";
import authMiddleware from "../middleware/authMiddleware";

const router = express.Router();

// ✅ Get all users
router.get(
  "/",
  authMiddleware.authenticate,
  authMiddleware.authorize("Admin"),
  userController.getAll
);

// ✅ Get profile
router.get(
  "/profile",
  authMiddleware.authenticate,
  authMiddleware.authorize("USER"),
  userController.getProfile
);
// ✅ Get user by ID
router.get("/:id", authMiddleware.authenticate, authMiddleware.authorize("Admin"), userController.getById);

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
