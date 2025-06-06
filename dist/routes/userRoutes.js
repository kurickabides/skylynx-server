"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const users_1 = __importDefault(require("../controllers/users")); // 👈 default import
const authMiddleware_1 = __importDefault(require("../middleware/authMiddleware"));
const router = express_1.default.Router();
// ✅ Get all users
router.get("/", authMiddleware_1.default.authenticate, users_1.default.getAll);
// ✅ Get user by ID
router.get("/:id", authMiddleware_1.default.authenticate, users_1.default.getById);
// ✅ Create user
router.post("/", authMiddleware_1.default.authenticate, users_1.default.create);
// ✅ Assign role
router.post("/:id/assign-role", authMiddleware_1.default.authenticate, users_1.default.assignRole);
// ✅ Get user roles
router.get("/:id/roles", authMiddleware_1.default.authenticate, users_1.default.getRoles);
exports.default = router;
