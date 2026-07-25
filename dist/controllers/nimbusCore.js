"use strict";
// ================================================
// ✅ Handler: loadFormHandler
// Description: Entry point for /api/nimbus/forms/loadform
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename:controllers/nimbusCore.ts
// ================================================
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getTargetByIdHandler = exports.getAllProtosTargetTypesHandler = exports.loadPortalTemplateTreeHandler = exports.loadFormHandler = void 0;
const protosRepository_1 = require("../services/protos/repository/protosRepository");
const portalModel_1 = __importDefault(require("../services/portalModel"));
const paramMapper_1 = require("../services/mappers/paramMapper");
const nimbusCoreFactory_1 = require("../services/nimbusCore/factory/nimbusCoreFactory");
const loadFormHandler = async (req, res) => {
    try {
        const { templateName, portalName, moduleName, params = [], } = req.body;
        const paramMap = (0, paramMapper_1.mapRequestToParams)(params);
        const config = await nimbusCoreFactory_1.NimbusCoreFactory.loadFormFromPortal(portalName, paramMap);
        res.json("result"); // 🔧 Implemented separately
    }
    catch (err) {
        console.error("❌ loadFormHandler Error:", err);
        res.status(500).json({ error: "Failed to load portal form." });
    }
};
exports.loadFormHandler = loadFormHandler;
// ================================================
// ✅ Handler: loadPortalTemplateTreeHandler
// Description: Entry point for /api/nimbus/templates/portals
// ================================================
const loadPortalTemplateTreeHandler = async (req, res) => {
    try {
        const portalName = req.portalName;
        const portalId = req.portalId;
        if (!portalName) {
            return res.status(400).json({ error: "Missing portal context" });
        }
        const tree = await (0, protosRepository_1.getSkylynxPortalTemplateTree)(portalName);
        res.json(tree);
    }
    catch (err) {
        console.error("❌ loadPortalTemplateTreeHandler Error:", err);
        res.status(500).json({ error: "Failed to load portal template tree." });
    }
};
exports.loadPortalTemplateTreeHandler = loadPortalTemplateTreeHandler;
const getAllProtosTargetTypesHandler = async (req, res) => {
    try {
        const targetTypes = await (0, protosRepository_1.getAllProtosTargetTypes)();
        res.json(targetTypes);
    }
    catch (err) {
        console.error("❌ getAllProtosTargetTypesHandler Error:", err);
        res.status(500).json({ error: "Failed to load target types." });
    }
};
exports.getAllProtosTargetTypesHandler = getAllProtosTargetTypesHandler;
// ✅ Generic handler for any target by type + id
const getTargetByIdHandler = async (req, res) => {
    try {
        const { type, id } = req.params;
        switch (type.toLowerCase()) {
            case "portal":
                return res.json(await portalModel_1.default.getPortalById(id));
            case "layout":
                return res.json(await (0, protosRepository_1.getLayoutById)(id));
            case "page":
                return res.json(await (0, protosRepository_1.getPageById)(id));
            case "module":
                return res.json(await (0, protosRepository_1.getModuleById)(id));
            case "datamodel":
                return res.json(await (0, protosRepository_1.getDataModelById)(id));
            case "dyform":
                return res.json(await (0, protosRepository_1.getDyFormById)(id));
            case "viewmodel":
                return res.json(await (0, protosRepository_1.getDyFormVMById)(id));
            case "dyformvm":
                return res.json(await (0, protosRepository_1.getDyFormVMById)(id));
            case "theme":
                return res.json(await (0, protosRepository_1.getThemeById)(id));
            case "themecolors":
                return res.json(await (0, protosRepository_1.getThemeById)(id));
            default:
                return res.status(400).json({ error: `Unsupported type: ${type}` });
        }
    }
    catch (err) {
        console.error(`❌ getTargetByIdHandler Error:`, err);
        res.status(500).json({ error: `Failed to load target for type ${req.params.type}` });
    }
};
exports.getTargetByIdHandler = getTargetByIdHandler;
