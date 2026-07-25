"use strict";
// ================================================
// ✅ Module: NimbusCoreFactory
// Description: Entry point for resolving full DyForm ViewModel layout + values
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: nimbusCoreFactory.ts
// ================================================
Object.defineProperty(exports, "__esModule", { value: true });
exports.NimbusCoreFactory = void 0;
const protosRepository_1 = require("../../protos/repository/protosRepository");
const dyformRepository_1 = require("../../dyform/repositories/dyformRepository");
const resultMapper_1 = require("../../mappers/resultMapper");
class NimbusCoreFactory {
    // 📦 Entry point to load full DyForm ViewModel (structure + values) from Portal Template Tree
    static async loadFormFromPortal(portalName, params) {
        const tree = await (0, protosRepository_1.getSkylynxPortalTemplateTree)(portalName);
        const viewModelNode = findFirstDyFormVM(tree.children);
        if (!viewModelNode)
            throw new Error("No DyFormVM node found in portal tree");
        const formVersionID = viewModelNode.template.versionID;
        const formName = viewModelNode.template.templateName;
        const metadata = await dyformRepository_1.DyformRepository.loadDyFormMetadata(formVersionID);
        const formViewModel = {
            viewModel: formName,
            portalName: tree.PortalName,
            moduleName: "",
            context: {
                formName,
                template: formName,
                version: String(viewModelNode.template.version || ""),
                resolver: {
                    method: "POST",
                    path: "/api/nimbus/forms/loadform",
                    type: "Internal",
                },
            },
            sections: metadata.sections,
        };
        if (viewModelNode.template?.resolver?.target) {
            const rawResults = await dyformRepository_1.DyformRepository.runResolver(viewModelNode.template.resolver.resolverType, viewModelNode.template.resolver.target, params);
            const values = resultMapper_1.ResultMapper.mapFormData(metadata.sections, rawResults);
            for (const section of formViewModel.sections) {
                for (const field of section.fields) {
                    const value = values[field.fieldId];
                    if (value !== undefined) {
                        field.value = value;
                    }
                }
            }
        }
        return formViewModel;
    }
}
exports.NimbusCoreFactory = NimbusCoreFactory;
function findFirstDyFormVM(nodes) {
    if (!nodes)
        return undefined;
    for (const node of nodes) {
        if (node.template.templateType.TargetTypeName === "DyFormVM") {
            return node;
        }
        const found = findFirstDyFormVM(node.children);
        if (found)
            return found;
    }
    return undefined;
}
