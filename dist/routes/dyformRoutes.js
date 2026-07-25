"use strict";
// ================================================
// ✅ Route: dyformRoutes
// Description: DyForm ViewModel endpoints
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: dyformRoutes.ts
// ================================================
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const dyform_1 = require("../controllers/dyform");
const router = express_1.default.Router();
// Route: GET /api/dyform/viewmodel/:viewModelName
router.get("/viewmodel/:viewModelName", dyform_1.getDyFormViewModel);
exports.default = router;
