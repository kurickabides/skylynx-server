"use strict";
// ================================================
// ✅ Builder: dyformUserProfileBuilder
// Description: Builds DyFormViewModel for user profile
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: dyformUserProfileBuilder.ts
// ================================================
Object.defineProperty(exports, "__esModule", { value: true });
exports.buildUserProfileViewModel = buildUserProfileViewModel;
const dyformRepository_1 = require("../repositories/dyformRepository");
const resultMapper_1 = require("../../mappers/resultMapper");
const userProfileMap_1 = require("../config/userProfileMap");
async function buildUserProfileViewModel(userId, viewModelName, portalName, portalId, providerId) {
    const recordsets = await (0, dyformRepository_1.loadUserProfileValues)(userId, portalName, portalId, providerId);
    const meta = userProfileMap_1.userProfileMap[viewModelName];
    const sections = (0, resultMapper_1.mapUserProfileResults)(recordsets);
    return {
        viewModel: viewModelName,
        userId,
        portalName,
        moduleName: "UserManagement", // stub or derive later
        context: {
            formName: meta.formName,
            template: meta.template,
            version: meta.version,
            resolver: meta.resolver,
        },
        sections: sections,
    };
}
