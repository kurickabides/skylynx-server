// ================================================
// ✅ Builder: dyformBuilder
// Description: Builds DyFormViewModel for user profile
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: dyformBuilder.ts
// ================================================

import { loadUserProfileValues } from "../repositories/dyformRepository";
import { getPMContextStub } from "../helpers/dyformContextHelper";
import { mapUserProfileResults } from "../helpers/resultMapper";
import { DyFormViewModel, ViewModelName } from "../../../entities/dyform/types";
import { userProfileMap } from "../config/userProfileMap";

export async function buildUserProfileViewModel(
  userId: string,
  viewModelName: ViewModelName.vmUserProfile_View | ViewModelName.vmUserProfile_Edit
): Promise<DyFormViewModel> {
  const context = getPMContextStub();
  const recordsets = await loadUserProfileValues(userId);
  const meta = userProfileMap[viewModelName];
  const sections = mapUserProfileResults(recordsets);

  return {
    viewModel: viewModelName,
    userId,
    ...context,
    context: {
      formName: meta.formName,
      template: meta.template,
      version: meta.version,
      resolver: meta.resolver,
    },
    sections,
  };
}