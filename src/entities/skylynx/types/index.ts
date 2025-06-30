// ================================================
// ✅ Entity: SkylynxDataModel + SkylynxPortalPayload
// Description: Core base model and payload for system-wide use
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename:/entities/skylynx/types/index.ts
// ================================================

export interface SkylynxDataModel {
  createdAt?: Date;
  updatedAt?: Date;
  status?: string; // Optional status message or state (e.g., 'active', 'error', etc.)
}

export interface SkylynxPortalPayload {
  viewModel: string; // e.g. "vmUserProfile_Form"
  userId: string; // e.g. "SKYX-000002"
  portalName: string; // e.g. "SkyLynxNet"
  moduleName: string; // e.g. "UserManagement"
  templateName: string; // e.g. "DefaultUserTemplate"
  version: string; // e.g. "v1.0"
  variants: any[]; // Array of section-level models (data only)
}
