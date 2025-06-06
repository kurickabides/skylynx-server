"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const auth_1 = __importDefault(require("../controllers/auth"));
const router = express_1.default.Router();
// Debugging - Log route loading
console.log("✅ Auth Routes Loaded");
// Define Routes
router.post("/signup", auth_1.default.signup);
router.post("/login", auth_1.default.login);
exports.default = router;
