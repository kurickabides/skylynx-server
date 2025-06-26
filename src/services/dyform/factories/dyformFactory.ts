// ================================================
// ✅ Factory: dyformFactory
// Description: Routes ViewModelName to appropriate builder
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: dyformFactory.ts
// ================================================

import {
  ViewModelName,
  DyFormViewModel,
} from "../../../entities/dyform/types";

import { buildUserProfileViewModel } from "../builders/dyformUserProfileBuilder";

export async function buildDyFormViewModel(
  viewModelName: ViewModelName,
  userId: string
): Promise<DyFormViewModel> {
  switch (viewModelName) {
    case ViewModelName.vmUserProfile_View:
    case ViewModelName.vmUserProfile_Edit:
      return buildUserProfileViewModel(userId, viewModelName);
    default:
      throw new Error(`Unsupported ViewModelName: ${viewModelName}`);
  }
}