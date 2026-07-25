"use strict";
// ================================================
// ✅ Route: userRoutes
// Description: User management endpoints
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: routes/userRoutes.ts
// ================================================
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const users_1 = __importDefault(require("../controllers/users"));
const authMiddleware_1 = __importDefault(require("../middleware/authMiddleware"));
const router = express_1.default.Router();
// ✅ Get all users
router.get("/", authMiddleware_1.default.authenticate, authMiddleware_1.default.authorize("Admin"), users_1.default.getAll);
// ✅ Get profile
router.get("/profile", authMiddleware_1.default.authenticate, authMiddleware_1.default.authorize("USER"), users_1.default.getProfile);
// ✅ Get user by ID
router.get("/:id", authMiddleware_1.default.authenticate, authMiddleware_1.default.authorize("Admin"), users_1.default.getById);
// ✅ Create user
router.post("/", authMiddleware_1.default.authenticate, users_1.default.create);
// ✅ Assign role to user (Admin only)
router.post("/roles/:id", authMiddleware_1.default.authenticate, authMiddleware_1.default.authorize("Admin"), users_1.default.assignRole);
// ✅ Get roles for a user
router.get("/roles/:id", authMiddleware_1.default.authenticate, users_1.default.getRoles);
exports.default = router;
