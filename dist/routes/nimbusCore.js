"use strict";
// ================================================
// ✅ File: routes/nimbusRoutes.ts
// Description: Express routes for NimbusCore template & form loading
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// ================================================
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const nimbusCore_1 = require("../controllers/nimbusCore");
//this should just use apiKey for auth uless admin is needed then use authMiddleware
const router = express_1.default.Router();
// POST /api/nimbus/forms/loadform
router.post("/forms/loadform", nimbusCore_1.loadFormHandler);
// GET /api/nimbus/templates/portals
router.get("/templates/portals", nimbusCore_1.loadPortalTemplateTreeHandler);
router.get("/templates/types", nimbusCore_1.getAllProtosTargetTypesHandler);
//TemplatesTargets Route 
// ✅ Dynamic Target Resolver Route
router.get("/templates/targets/:type/:id", nimbusCore_1.getTargetByIdHandler);
exports.default = router;
