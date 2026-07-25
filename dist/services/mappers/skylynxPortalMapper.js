"use strict";
// ================================================
// ✅ Mapper: mapPortalTemplateTree
// Description: Transforms flat portal tree rows into nested PortalTemplateTree
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: skylynxPortalMapper.ts
// ================================================
Object.defineProperty(exports, "__esModule", { value: true });
exports.mapPortalTemplateTree = mapPortalTemplateTree;
// Helper: build a full ProtosTemplate from row
function mapTemplate(row) {
    const template = {
        templateID: row.ChildTemplateID,
        templateName: row.ChildTemplateName,
        templateType: {
            targetTypeID: row.ChildTargetTypeID,
            TargetTypeName: row.ChildTemplateType,
        },
        version: row.ChildVersionLabel + String(row.ChildVersionNumber),
        versionID: row.ChildVersionID,
        sortOrder: row.ChildSortOrder,
        targetID: row.ChildObjectID,
    };
    if (row.ResolverID) {
        template.resolver = {
            resolverId: row.ResolverID,
            resolverType: row.ResolverType,
            target: row.ResolverTarget,
            description: row.ResolverDescription || undefined,
        };
    }
    return template;
}
// Recursive builder
function buildTree(flatRows, parentId) {
    const children = flatRows.filter((r) => r.ParentTemplateID === parentId);
    return children.map((row) => {
        return {
            nodeName: row.ChildTemplateType,
            template: mapTemplate(row),
            children: buildTree(flatRows, row.ChildTemplateID),
        };
    });
}
// ================================================
// ✅ Function: mapPortalTemplateTree
// Description: Converts raw SP result to PortalTemplateTree
// ================================================
function mapPortalTemplateTree(rows) {
    if (!rows.length)
        throw new Error("Empty tree result");
    // Root row is always a Portal type
    const rootRow = rows.find((r) => r.ParentTemplateType === "Portal");
    if (!rootRow)
        throw new Error("Missing Portal root in result");
    const PortalTemplate = {
        templateID: rootRow.ParentTemplateID,
        templateName: rootRow.ParentTemplateName,
        templateType: {
            targetTypeID: rootRow.ParentTargetTypeID,
            TargetTypeName: rootRow.ParentTemplateType,
        },
        version: rootRow.ParentVersionLabel + String(rootRow.ParentVersionNumber),
        versionID: rootRow.ParentVersionID,
        targetID: rootRow.ParentObjectID,
    };
    const children = buildTree(rows, PortalTemplate.templateID);
    return {
        PortalName: rootRow.ParentTemplateName,
        PortalTemplate,
        children,
    };
}
