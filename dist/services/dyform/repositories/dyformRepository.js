"use strict";
// ================================================
// ✅ Repository: dyformRepository
// Description: Handles DyForm resolver-based execution
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: dyformRepository.ts
// ================================================
Object.defineProperty(exports, "__esModule", { value: true });
exports.loadUserProfileValues = exports.DyformRepository = void 0;
const db_1 = require("../../../config/db");
class DyformRepository {
    // ================================================
    // ✅ Method: runResolver
    // Description: Dynamically executes resolver target (SP or JSON)
    // ================================================
    static async runResolver(resolverType, target, params) {
        try {
            if (resolverType === "StoredProcedure" || resolverType === "sp") {
                const pool = await db_1.poolPromise;
                const request = pool.request();
                for (const [key, value] of Object.entries(params)) {
                    request.input(key, value);
                }
                const result = await request.execute(target);
                const record = result.recordset?.[0] || {};
                return record;
            }
            if (resolverType === "MockJson") {
                return JSON.parse(target);
            }
            throw new Error(`Unsupported resolver type: ${resolverType}`);
        }
        catch (err) {
            console.error("❌ Resolver execution failed:", err);
            throw err;
        }
    }
    // ================================================
    // ✅ Method: loadDyFormMetadata
    // Description: Loads sections + fields for given ViewModel
    // ================================================
    static async loadDyFormMetadata(viewModelName) {
        const pool = await db_1.poolPromise;
        const request = pool.request();
        request.input("ViewModelName", viewModelName);
        const result = await request.execute("LoadDyFormViewModelLayout");
        // 🧠 Type cast to avoid TS 7053 error
        const recordsets = result.recordsets;
        const sectionsRaw = recordsets?.[0] || [];
        const fieldsRaw = recordsets?.[1] || [];
        const sectionMap = {};
        for (const section of sectionsRaw) {
            sectionMap[section.SectionID] = {
                sectionId: section.SectionID,
                name: section.SectionName, // maps to `name`
                label: section.Label,
                sortOrder: section.SortOrder,
                fields: [],
            };
        }
        for (const field of fieldsRaw) {
            const section = sectionMap[field.SectionID];
            if (!section)
                continue;
            section.fields.push({
                fieldId: field.DyFormFieldID,
                label: field.Label,
                tooltip: field.Tooltip,
                fieldType: {
                    fieldTypeId: field.FieldTypeID,
                    fieldTypeName: field.FieldTypeName,
                    componentName: field.ComponentName,
                },
                sortOrder: field.FieldSortOrder,
                sourceKey: field.SourceKey,
                sourcePath: field.SourcePath,
                isDirectProperty: field.IsDirectProperty,
            });
        }
        return {
            sections: Object.values(sectionMap),
        };
    }
}
exports.DyformRepository = DyformRepository;
const loadUserProfileValues = async (userId, portalName, portalId, providerId) => {
    const pool = await db_1.poolPromise;
    const request = pool.request();
    request.input("UserID", db_1.sql.UniqueIdentifier, userId);
    request.input("PortalName", db_1.sql.NVarChar, portalName);
    request.input("PortalID", db_1.sql.UniqueIdentifier, portalId);
    if (providerId) {
        request.input("ProviderID", db_1.sql.UniqueIdentifier, providerId);
    }
    const result = await request.execute("LoadUserProfileValues");
    return (result.recordsets ?? []);
};
exports.loadUserProfileValues = loadUserProfileValues;
