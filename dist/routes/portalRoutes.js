"use strict";
// ================================================
// ✅ Route: portalRoutes
// Description: Portal management endpoints
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: routes/portalRoutes.ts
// ================================================
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const portals_1 = __importDefault(require("../controllers/portals"));
const router = express_1.default.Router();
// ✅ Get all portals (authenticated users)
router.get("/", portals_1.default.getAll);
// ✅ Get portal by ID
router.get("/:id", portals_1.default.getById);
// ✅ Create new portal
router.post("/", portals_1.default.create);
// ✅ Update portal
router.put("/:id", portals_1.default.update);
// ✅ Delete portal
router.delete("/:id", portals_1.default.remove);
router.post("/byuser", portals_1.default.getPortalsByUser);
router.post("/byapikey", portals_1.default.getPortalByAPIKey);
exports.default = router;
