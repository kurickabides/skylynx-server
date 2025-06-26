// ================================================
// ✅ Config.Mappers: dyformBuilder
// Description: Maps DyFormViewModel for user profile
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: userProfileMap.ts
// ================================================

import { DyFormViewModel, ViewModelName } from "../../../entities/dyform/types";

// Metadata map only for UserProfile view models
export const userProfileMap: Record<
  ViewModelName.vmUserProfile_View | ViewModelName.vmUserProfile_Edit,
  DyFormViewModel["context"]
> = {
  [ViewModelName.vmUserProfile_View]: {
    formName: "UserProfile",
    template: "DefaultUserTemplate",
    version: "v1.0",
    resolver: {
      method: "GET",
      path: "/api/dyform/viewmodel/vmUserProfile_View",
      type: "UserProfileViewOnly",
    },
  },
  [ViewModelName.vmUserProfile_Edit]: {
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
