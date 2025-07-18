// ================================================
// ✅ Handler: loadFormHandler
// Description: Entry point for /api/nimbus/forms/loadform
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename:controllers/nimbusCore.ts
// ================================================

import { Request, Response } from "express";
import {
  getSkylynxPortalTemplateTree,
  getAllProtosTargetTypes,
  getLayoutById,
  getPageById,
  getModuleById,
  getDataModelById,
  getDyFormById,
  getDyFormVMById,
  getThemeById,
} from "../services/protos/repository/protosRepository";
import PortalModel  from "../services/portalModel";
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
export const getAllProtosTargetTypesHandler = async (
  req: Request,
  res: Response
) => {
  try {
    const targetTypes = await getAllProtosTargetTypes();
    res.json(targetTypes);
  } catch (err) {
    console.error("❌ getAllProtosTargetTypesHandler Error:", err);
    res.status(500).json({ error: "Failed to load target types." });
  }
};

// ✅ Generic handler for any target by type + id
export const getTargetByIdHandler = async (req: Request, res: Response) => {
  try {
    const { type, id } = req.params;

    switch (type.toLowerCase()) {
      case "portal":
        return res.json(await PortalModel.getPortalById(id));
      case "layout":
        return res.json(await getLayoutById(id));
      case "page":
        return res.json(await getPageById(id));
      case "module":
        return res.json(await getModuleById(id));
      case "datamodel":
        return res.json(await getDataModelById(id));
      case "dyform":
        return res.json(await getDyFormById(id));
      case "viewmodel":
        return res.json(await getDyFormVMById(id));
      case "dyformvm":
        return res.json(await getDyFormVMById(id));
      case "theme":
        return res.json(await getThemeById(id));
      case "themecolors":
        return res.json(await getThemeById(id));
      default:
        return res.status(400).json({ error: `Unsupported type: ${type}` });
    }
  } catch (err) {
    console.error(`❌ getTargetByIdHandler Error:`, err);
    res.status(500).json({ error: `Failed to load target for type ${req.params.type}` });
  }
};

