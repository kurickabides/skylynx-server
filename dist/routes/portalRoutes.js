"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const portals_1 = __importDefault(require("../controllers/portals"));
const authMiddleware_1 = __importDefault(require("../middleware/authMiddleware"));
const router = express_1.default.Router();
// ✅ Get all portals (authenticated users)
router.get("/", authMiddleware_1.default.authenticate, portals_1.default.getAll);
// ✅ Get portal by ID
router.get("/:id", authMiddleware_1.default.authenticate, portals_1.default.getById);
// ✅ Create new portal
router.post("/", authMiddleware_1.default.authenticate, portals_1.default.create);
// ✅ Update portal
router.put("/:id", authMiddleware_1.default.authenticate, portals_1.default.update);
// ✅ Delete portal
router.delete("/:id", authMiddleware_1.default.authenticate, portals_1.default.remove);
exports.default = router;
