"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const roles_1 = __importDefault(require("../controllers/roles"));
const authMiddleware_1 = __importDefault(require("../middleware/authMiddleware"));
const router = express_1.default.Router();
// ✅ Get all roles (authenticated users)
router.get("/", authMiddleware_1.default.authenticate, roles_1.default.getAll);
// ✅ Create a new role (Admin only)
router.post("/", authMiddleware_1.default.authenticate, authMiddleware_1.default.authorize("Admin"), roles_1.default.create);
// ✅ Assign a role to a user (Admin only)
router.post("/assign", authMiddleware_1.default.authenticate, authMiddleware_1.default.authorize("Admin"), roles_1.default.assignToUser);
exports.default = router;
