"use strict";
// ================================================
// ✅ Config.Mappers: dyformBuilder
// Description: Maps DyFormViewModel for user profile
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: userProfileMap.ts
// ================================================
Object.defineProperty(exports, "__esModule", { value: true });
exports.userProfileMap = void 0;
const types_1 = require("../../../entities/dyform/types");
// Metadata map only for UserProfile view models
exports.userProfileMap = {
    [types_1.ViewModelName.vmUserProfile_View]: {
        formName: "UserProfile",
        template: "DefaultUserTemplate",
        version: "v1.0",
        resolver: {
            method: "GET",
            path: "/api/dyform/viewmodel/vmUserProfile_View",
            type: "UserProfileViewOnly",
        },
    },
    [types_1.ViewModelName.vmUserProfile_Edit]: {
        formName: "UserProfileEdit",
        template: "DefaultUserTemplate",
        version: "v1.0",
        resolver: {
            method: "POST",
            path: "/api/user/edit-profile",
            type: "UserProfileEditSubmission",
        },
    },
};
