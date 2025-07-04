// ================================================
// ✅ Entity: SkylynxDataModel + SkylynxPortalPayload
// Description: Core base model and payload for system-wide use
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename:/entities/skylynx/types/index.ts
// ================================================
export interface IResolver {
  resolverId: string;
  resolverType: string; // from ResolverType table
  target: string;
  description?: string;
}
export interface ProtosTemplate {
  templateName?: string;
  version?: number | string;
  versionID?: string; // TemplateVersionID
  resolver?: IResolver;
  sortOrder?: number;
}

// ================================================
// ✅ Interface: SkylynxPortalViewModel
// Description: Represents a ViewModel node in the config tree
// ================================================
export interface SkylynxPortalViewModel {
  viewModel: string;
  portalName: string;
  moduleName: string;
  template?: ProtosTemplate;
  children?: SkylynxPortalViewModel[];
}



// ================================================
// ✅ Interface: SkylynxPortalConfig
// Description: Root-level ViewModel structure with variants
// ================================================
export interface SkylynxPortalConfig extends SkylynxPortalViewModel {
  variants: SkylynxPortalViewModel[];
}

export interface SkylynxDataModel {
  createdAt?: Date;
  updatedAt?: Date;
  status?: string; // Optional status message or state (e.g., 'active', 'error', etc.)
}
export type ViewModelParams = {
  [paramName: string]: string | number | boolean | null;
};


export interface SkylynxPortalVariantContext {
  formName: string;
  template: string;
  version: string;
  resolverId: string;
}

//Datamodels

export interface vmAspNetUserModel extends SkylynxDataModel {
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
}

export interface vmAddressModel extends SkylynxDataModel {
  AddyID: string;
  Street1?: string;
  Street2?: string;
  City?: string;
  State?: string;
  PostalCode?: string;
  Country?: string;
  Latitude?: number;
  Longitude?: number;
}
export interface vmProviderProfileValueModel extends SkylynxDataModel {
  UserID: string;
  ProviderID: string;
  FieldID: string;
  FieldValue: string;
}


export interface vmProviderProfileFieldModel extends SkylynxDataModel {
  FieldID: string;
  ProviderID: string;
  FieldName: string;
  FieldTypeID: string;
  IsRequired: boolean;
  SortOrder: number;
}
