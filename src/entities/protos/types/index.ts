// ================================================
// ✅ Entity: SkylynxDataModel + SkylynxPortalPayload
// Description: Core base model and payload for system-wide use
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename:/entities/protos/types/index.ts
// ================================================

// ================================================
// ✅ Interface: ProtosTemplate
// Description: Optional metadata tied to a ViewModel's template resolution
// ================================================

export interface IResolver {
  resolverId: string;
  resolverType: string; // from ResolverType table
  target: string;
  description?: string;
}
export interface PortalTemplateTree {
  PortalName: string;
  PortalTemplate: ProtosTemplate;
  children?: SkylynxTemplateNode[];
}


export interface ProtosTemplate {
  templateID: string;
  templateName: string;
  templateType: TemplateType;
  version: string;
  versionID: string; // TemplateVersionID
  resolver?: IResolver;
  sortOrder?: number;
  targetID?: string;
}

export type TemplateRelationship = {
  parentType: string;
  allowedChildTypes: string[];
};

// ================================================
// ✅ Interface: SkylynxPortalViewModel
// Description: Represents a ViewModel node in the config tree
// ================================================
export interface SkylynxTemplateNode {
  nodeName: string;
  template: ProtosTemplate;
  children?: SkylynxTemplateNode[];
}

export interface TemplateType {
  targetTypeID: string;
  TargetTypeName?: string;
  description?: string;
  createdAt?: Date;
}