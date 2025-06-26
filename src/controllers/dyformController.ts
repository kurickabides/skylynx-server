// ================================================
// ✅ Controller: dyformController
// Description: Handles DyForm view model requests via factory
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: dyformController.ts
// ================================================

import { Request, Response } from "express";
import { buildDyFormViewModel } from "../services/dyform/factories/dyformFactory";
import { ViewModelName } from "../entities/dyform/types";

export async function getDyFormViewModel(req: Request, res: Response) {
  const { viewModelName } = req.params;
  const { userId } = req.body;

  if (!userId) {
    return res.status(400).json({ error: "Missing required field: userId" });
  }

  // 🔍 Validate and convert viewModelName string to ViewModelName enum
  const enumKey = Object.values(ViewModelName).find((v) => v === viewModelName);
  if (!enumKey) {
    return res
      .status(400)
      .json({ error: `Unsupported ViewModelName: ${viewModelName}` });
  }

  try {
    const result = await buildDyFormViewModel(enumKey as ViewModelName, userId);
    res.json(result);
  } catch (err: any) {
    console.error("❌ DyForm load error:", err);
    res.status(500).json({ error: err.message });
  }
}
