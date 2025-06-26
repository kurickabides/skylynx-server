// ================================================
// ✅ Builder: dyformUserProfileBuilder
// Description: Builds DyFormViewModel for user profile
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: dyformUserProfileBuilder.ts
// ================================================

import { loadUserProfileValues } from "../repositories/dyformRepository";
import { mapUserProfileResults } from "../helpers/resultMapper";
import { DyFormViewModel, ViewModelName } from "../../../entities/dyform/types";
import { userProfileMap } from "../config/userProfileMap";

export async function buildUserProfileViewModel(
  userId: string,
  viewModelName:
    | ViewModelName.vmUserProfile_View
    | ViewModelName.vmUserProfile_Edit,
  portalName: string,
  portalId: string,
  providerId?: string
): Promise<DyFormViewModel> {
  const recordsets = await loadUserProfileValues(
    userId,
    portalName,
    portalId,
    providerId,
  );

  const meta = userProfileMap[viewModelName];
  const sections = mapUserProfileResults(recordsets);

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
    sections,
  };
}
