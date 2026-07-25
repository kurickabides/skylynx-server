"use strict";
// ================================================
// ✅ Route: Get Portal ViewModel Tree
// Path: /api/protos/portal-tree/:viewModelName
// ================================================
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const router = express_1.default.Router();
router.get("/portaltree/:viewModelName", async (req, res) => {
    try {
        const { viewModelName } = req.params;
        const tree = ''; //await getProtosTreeViewModelConfig(viewModelName);
        //res.json(tree);
    }
    catch (error) {
        console.error("❌ Error in /portaltree route:", error);
        res.status(500).json({ error: "Failed to load portal tree" });
    }
});
exports.default = router;
