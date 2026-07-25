"use strict";
// ================================================
// ✅ Route: serverAuthRoutes
// Description: Local server admin authentication endpoints
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: routes/serverAuthRoutes.ts
// ================================================
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const serverAuth_1 = __importDefault(require("../controllers/serverAuth"));
const serverAdminMiddleware_1 = require("../middleware/serverAdminMiddleware");
const router = express_1.default.Router();
router.get("/status", serverAuth_1.default.status);
router.post("/setup", serverAuth_1.default.setup);
router.post("/login", serverAuth_1.default.login);
router.get("/me", serverAdminMiddleware_1.authenticateServerAdmin, serverAuth_1.default.me);
exports.default = router;
