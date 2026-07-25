"use strict";
// ================================================
// ✅ Entity: DyFormViewModel
// Description: Defines DyForm types
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename:/entities/dyform/types/index.ts
// ================================================
Object.defineProperty(exports, "__esModule", { value: true });
exports.ViewNames = exports.ViewModelName = void 0;
var ViewModelName;
(function (ViewModelName) {
    ViewModelName["vmUserProfile_View"] = "vmUserProfile_View";
    ViewModelName["vmUserProfile_Edit"] = "vmUserProfile_Edit";
    ViewModelName["vmPortalAdmin_View"] = "vmPortalAdmin_View";
})(ViewModelName || (exports.ViewModelName = ViewModelName = {}));
var ViewNames;
(function (ViewNames) {
    ViewNames["view"] = "View";
    ViewNames["edit"] = "Edit";
    ViewNames["admin"] = "Admin";
})(ViewNames || (exports.ViewNames = ViewNames = {}));
