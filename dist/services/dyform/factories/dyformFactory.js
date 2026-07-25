"use strict";
// ================================================
// ✅ Factory: dyformFactory
// Description: Routes ViewModelName to appropriate builder
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: dyformFactory.ts
// ================================================
Object.defineProperty(exports, "__esModule", { value: true });
exports.buildDyFormViewModel = buildDyFormViewModel;
const types_1 = require("../../../entities/dyform/types");
const dyformUserProfileBuilder_1 = require("../builders/dyformUserProfileBuilder");
async function buildDyFormViewModel(viewModelName, userId, portalName, portalId, providerId) {
    switch (viewModelName) {
        case types_1.ViewModelName.vmUserProfile_View:
        case types_1.ViewModelName.vmUserProfile_Edit:
            return (0, dyformUserProfileBuilder_1.buildUserProfileViewModel)(userId, viewModelName, portalName, portalId, providerId);
        default:
            throw new Error(`Unsupported ViewModelName: ${viewModelName}`);
    }
}
