// ================================================
// ✅ Route: Get Portal ViewModel Tree
// Path: /api/protos/portal-tree/:viewModelName
// ================================================

import express from "express";
import { getSkylynxPortalTemplateTree } from "../services/protos/repository/protosRepository";

const router = express.Router();

router.get("/portaltree/:viewModelName", async (req, res) => {
  try {
    const { viewModelName } = req.params;
    const tree = ''//await getProtosTreeViewModelConfig(viewModelName);
    //res.json(tree);
  } catch (error) {
    console.error("❌ Error in /portaltree route:", error);
    res.status(500).json({ error: "Failed to load portal tree" });
  }
});

export default router;
