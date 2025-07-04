// ================================================
// ✅ Entity: DyFormViewModel
// Description: Defines DyForm types
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename:/entities/dyform/types/index.ts
// ================================================

import { SkylynxDataModel } from "../../skylynx/types";

export enum ViewModelName {
  vmUserProfile_View = "vmUserProfile_View",
  vmUserProfile_Edit = "vmUserProfile_Edit",
  vmPortalAdmin_View = "vmPortalAdmin_View",
}
export enum ViewNames {
  view = "View",
  edit = "Edit",
  admin = "Admin",
}
export interface DyFormViewModel {
  viewModel: string;
  userId?: string;
  portalName: string;
  moduleName: string;
  context: {
    formName: string;
    template: string;
    version: string;
    resolver: {
      method: string;
      path: string;
      type: string;
    };
  };
  sections: DyFormSection[];
}

export interface DyFormSection {
  name: string;
  label?: string;
  sortOrder?: number;
  resolvers?: DyFormResolver[];
  fields: DyFormField[];
}

export interface DyFormField {
  fieldId: string;
  label: string;
  tooltip?: string;
  placeholder?: string;
  value: any;
  type: string;
  readonly?: boolean;
  required?: boolean;
  rules?: DyFormRule[];
  domain?: DyFormDomain;
}

export interface DyFormRule {
  type: string;
  value: any;
}

export interface DyFormDomain {
  name: string;
  options: DyFormDomainOption[];
}

export interface DyFormDomainOption {
  key: string;
  value: string;
}

export interface DyFormResolver {
  context: string;
  type: string;
  target: string;
  path?: string;
  method?: string;
  notes?: string;
}

// ================================================
// ✅ Interfaces: DyForm ViewModel Result Sets
// Description: Matches result sets from GetUserFullProfileViewModel
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// ================================================



