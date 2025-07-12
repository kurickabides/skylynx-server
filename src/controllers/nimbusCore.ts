// ================================================
// ✅ Handler: loadFormHandler
// Description: Entry point for /api/nimbus/forms/loadform
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename:controllers/nimbusCore.ts
// ================================================

import { Request, Response } from "express";
import { getSkylynxPortalTemplateTree } from "../services/protos/repository/protosRepository";
import { mapRequestToParams } from "../services/mappers/paramMapper";
import { LoadPortalFormRequest } from "../entities/dyform/types";
import { NimbusCoreFactory } from "../services/nimbusCore/factory/nimbusCoreFactory";

export const  loadFormHandler = async (req: Request, res: Response) => {
  try {
    const {
      templateName,
      portalName,
      moduleName,
      params = [],
    }: LoadPortalFormRequest = req.body;

    const paramMap = mapRequestToParams(params);
    const config = await NimbusCoreFactory.loadFormFromPortal(
      portalName,
      paramMap
    );

    res.json("result"); // 🔧 Implemented separately
  } catch (err) {
    console.error("❌ loadFormHandler Error:", err);
    res.status(500).json({ error: "Failed to load portal form." });
  }
};

// ================================================
// ✅ Handler: loadPortalTemplateTreeHandler
// Description: Entry point for /api/nimbus/templates/portals
// ================================================

export const loadPortalTemplateTreeHandler = async (
  req: Request,
  res: Response
) => {
  try {
    const portalName = req.portalName as string;
    const portalId = req.portalId as string;
    if (!portalName) {
      return res.status(400).json({ error: "Missing portal context" });
    }

    const tree = await getSkylynxPortalTemplateTree(portalName);
    res.json(tree);
  } catch (err) {
    console.error("❌ loadPortalTemplateTreeHandler Error:", err);
    res.status(500).json({ error: "Failed to load portal template tree." });
  }
};
