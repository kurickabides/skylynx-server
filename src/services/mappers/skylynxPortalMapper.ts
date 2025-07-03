// ================================================
// ✅ Mapper: skylynxPortalMapper
// Description: Maps SP result sets to SkylynxPortalConfig structure
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: skylynxPortalMapper.ts
// ================================================

import {
  SkylynxPortalConfig,
  SkylynxPortalViewModel,
  ProtosTemplate,
  IResolver,
} from "../../entities/skylynx/types";

// ================================================
// ✅ Function: mapResolverFields
// Description: Extracts IResolver from SQL row
// ================================================
function mapResolverFields(record: any): IResolver {
  return {
    resolverId: record?.ResolverID ?? null,
    resolverType: record?.ResolverType ?? null,
    target: record?.Target ?? null,
    description: record?.Description ?? null,
  };
}

// ================================================
// ✅ Function: mapTemplateMetadata
// Description: Extracts ProtosTemplate metadata from row
// ================================================
function mapTemplateMetadata(record: any): ProtosTemplate {
  return {
    templateName: record?.TemplateName ?? null,
    version: record?.version ?? null,
    versionID: record?.versionID ?? null,
    resolver: mapResolverFields(record),
    sortOrder: record?.SortOrder ?? null,
  };
}

// ================================================
// ✅ Function: mapPortalViewModelTree
// Description: Maps SQL result sets to SkylynxPortalConfig structure
// ================================================
export function mapPortalViewModelTree(
  recordsets: any[][]
): SkylynxPortalConfig {
  const [rootSet, variantSet = [], dyformSet = []] = recordsets;
  const root = rootSet?.[0];
  if (!root) throw new Error("Missing root ViewModel result set");

  const rootViewModel = root.ViewModel ?? root.viewModel;

  const variants: SkylynxPortalViewModel[] = variantSet.map((variant) => {
    const children = dyformSet
      .filter(
        (leaf) =>
          leaf.ParentViewModel === variant.ViewModel ||
          leaf.parentViewModel === variant.viewModel
      )
      .map((leaf) => ({
        viewModel: leaf.ViewModel ?? leaf.viewModel,
        moduleName: leaf.ModuleName ?? leaf.moduleName ?? "DynamicForms",
        portalName: leaf.PortalName ?? leaf.portalName ?? "DyForm",
        ...mapTemplateMetadata(leaf),
      }));

    return {
      viewModel: variant.ViewModel ?? variant.viewModel,
      moduleName: root.moduleName,
      portalName: root.portalName,
      ...mapTemplateMetadata(variant),
      children: children.length ? children : undefined,
    };
  });

  return {
    viewModel: root.ViewModel ?? root.viewModel,
    moduleName: root.moduleName,
    portalName: root.portalName,
    ...mapTemplateMetadata(root),
    variants,
  };
}
