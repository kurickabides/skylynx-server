// ================================================
// ✅ Entity: SkylynxDataModel + SkylynxPortalPayload
// Description: Core base model and payload for system-wide use
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename:/entities/skylynx/types/index.ts
// ================================================
import { DyFormSections } from "../../dyform/types";
import { IPortal, IModule } from "../../portal/types";
import {
   ProtosTemplate,
  TemplateRelationship,
  SkylynxTemplateNode,
} from "../../protos/types";


export interface SkylynxPortalViewModel {
  portalName: string;
  moduleName: string;
  children?: SkylynxPortalViewModel[];
}

export type SkylynxDataModelRecords = Record<
  string,
  SkylynxDataModel | SkylynxDataModel[]
>;

// ================================================
// ✅ Interface: SkylynxPortalResponse
// Description: Final portal form response with config, metadata, and resolved data
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename:skylynxPortalResponse.ts
// ================================================
// Template config used to resolve and render this form
// Fully resolved section + field structure (including nested sections)
// Keyed by ViewModelName, with each record holding data for that view
export interface SkylynxPortalResponse {
  viewModel: string;
  portalName: string;
  moduleName: string;  
  template?: ProtosTemplate; 
  sections: DyFormSections[];  
  data: SkylynxDataModelRecords;
}

// ✅ Interface: SkylynxPortalCache
// Description: Root-level ViewModel structure with variants
// ================================================
export type SkylynxPortalCache = Record<string, SkylynxPortalConfig>;

// ✅ Interface: SkylynxPortalConfig
// Description: Root-level ViewModel structure with variants
// ================================================
export interface SkylynxPortalConfig extends SkylynxTemplateNode {
  portal: IPortal;
  variants: SkylynxTemplateNode[];
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

export interface SkylynxUserProfile {
  aspNetUserModel: vmAspNetUserModel;
  mailingAddressModel: vmAddressModel;
  billingAddressModel: vmAddressModel;
  providerProfileFieldModel: vmProviderProfileFieldModel;
  providerProfileValueModel: vmProviderProfileValueModel;
}

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
// ================================================
// ✅ Entity: IKeyValuePair
// Description: Represents a single input for any type or array
// ================================================
export interface IKeyValuePair {
  key: string;
  value: string;
}

