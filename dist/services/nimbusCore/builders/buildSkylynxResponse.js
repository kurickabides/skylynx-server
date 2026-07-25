"use strict";
// ================================================
// Function: buildSkylynxResponse
// Description: Builds full response using tree, layout SP, and data resolver
// Filename: buildSkylynxResponse.ts
// ================================================
Object.defineProperty(exports, "__esModule", { value: true });
exports.buildSkylynxResponse = buildSkylynxResponse;
const dyformRepository_1 = require("../../dyform/repositories/dyformRepository");
async function buildSkylynxResponse(tree, bodyParams) {
    const topVM = tree.viewModel;
    const data = {};
    if (tree.resolver?.target) {
        const resolvedData = await runResolver(tree.resolver, bodyParams);
        Object.assign(data, resolvedData);
    }
    const layoutResults = [];
    for (const variant of tree.variants ?? []) {
        for (const child of variant.children ?? []) {
            const fields = await getMetadataForVM(child.viewModel);
            layoutResults.push(...fields);
        }
    }
    const sections = groupFieldsBySection(layoutResults);
    return {
        viewModel: topVM,
        portalName: tree.portalName,
        moduleName: tree.moduleName,
        sections,
        data,
    };
}
async function runResolver(resolver, bodyParams) {
    return dyformRepository_1.DyformRepository.runResolver(resolver.resolverType ?? resolver.type, resolver.target, bodyParams);
}
async function getMetadataForVM(viewModel) {
    const metadata = await dyformRepository_1.DyformRepository.loadDyFormMetadata(viewModel);
    return metadata.sections.flatMap((section) => section.fields.map((field) => ({
        ...field,
        sectionId: section.sectionId,
        sectionName: section.name,
        sectionLabel: section.label ?? section.name,
        sectionSortOrder: section.sortOrder ?? 0,
    })));
}
function groupFieldsBySection(fields) {
    const sections = new Map();
    for (const field of fields) {
        const section = sections.get(field.sectionId) ?? {
            sectionId: field.sectionId,
            sectionName: field.sectionName,
            label: field.sectionLabel,
            sortOrder: field.sectionSortOrder,
            fields: [],
        };
        section.fields?.push(field);
        sections.set(field.sectionId, section);
    }
    return Array.from(sections.values()).sort((left, right) => left.sortOrder - right.sortOrder);
}
