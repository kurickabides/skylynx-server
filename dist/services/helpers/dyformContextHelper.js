"use strict";
// ================================================
// ✅ Helper: dyformContextHelper
// Description: Provides portal/module context stub for now
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// FileName: dyformContextHelper.ts
// ================================================
Object.defineProperty(exports, "__esModule", { value: true });
exports.getPMContextStub = void 0;
const getPMContextStub = () => ({
    portalName: 'SkylynxPortal',
    moduleName: 'UserManagement'
});
exports.getPMContextStub = getPMContextStub;
