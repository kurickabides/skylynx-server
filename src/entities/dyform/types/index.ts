// ================================================
// ✅ Entity: DyFormViewModel
// Description: Defines DyForm types
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename:dyform/types/index.ts
// ================================================

export enum ViewModelName {
  vmUserProfile_View = "vmUserProfile_View",
  vmUserProfile_Edit = "vmUserProfile_Edit",
  vmPortalAdmin_View = 'vmPortalAdmin_View',
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

export interface vmAspNetUserModel {
    Id: string;
    UserName: string;
    NormalizedUserName: string;
    Email: string;
    NormalizedEmail: string;
    EmailConfirmed: boolean;
    PasswordHash?: string;
    SecurityStamp?: string;
    ConcurrencyStamp?: string;
    PhoneNumber?: string;
    PhoneNumberConfirmed: boolean;
    TwoFactorEnabled: boolean;
    LockoutEnd?: Date;
    LockoutEnabled: boolean;
    AccessFailedCount: number;
    CreatedAt?: Date;
    UpdatedAt?: Date;
  }
  
  export interface vmAddressModel {
    AddyID: string;
    Street1?: string;
    Street2?: string;
    City?: string;
    State?: string;
    PostalCode?: string;
    Country?: string;
    Latitude?: number;
    Longitude?: number;
    CreatedAt?: Date;
    UpdatedAt?: Date;
  }
  
  export interface vmProviderProfileFieldModel {
    FieldID: string;
    ProviderID: string;
    FieldName: string;
    FieldTypeID: string;
    IsRequired: boolean;
    SortOrder: number;
  }
  
  export interface vmProviderProfileValueModel {
    UserID: string;
    ProviderID: string;
    FieldID: string;
    FieldValue: string;
  }

