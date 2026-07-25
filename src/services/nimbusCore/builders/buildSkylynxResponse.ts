// ================================================
// Function: buildSkylynxResponse
// Description: Builds full response using tree, layout SP, and data resolver
// Filename: buildSkylynxResponse.ts
// ================================================

import { DyFormField, DyFormResolver, DyFormSections } from "../../../entities/dyform/types";
import {
  SkylynxDataModelRecords,
  SkylynxPortalResponse,
} from "../../../entities/skylynx/types";
import { DyformRepository } from "../../dyform/repositories/dyformRepository";

type PortalViewModelNode = {
  viewModel: string;
  portalName: string;
  moduleName: string;
  resolver?: DyFormResolver & { resolverType?: string };
  variants?: Array<{
    children?: Array<{ viewModel: string }>;
  }>;
};

type DyFormFieldDefinition = DyFormField & {
  sectionId: string;
  sectionName: string;
  sectionLabel: string;
  sectionSortOrder: number;
};

export async function buildSkylynxResponse(
  tree: PortalViewModelNode,
  bodyParams: any
): Promise<SkylynxPortalResponse> {
  const topVM = tree.viewModel;

  const data: SkylynxDataModelRecords = {};
  if (tree.resolver?.target) {
    const resolvedData = await runResolver(tree.resolver, bodyParams);
    Object.assign(data, resolvedData);
  }

  const layoutResults: DyFormFieldDefinition[] = [];
  for (const variant of tree.variants ?? []) {
    for (const child of variant.children ?? []) {
      const fields = await getMetadataForVM(child.viewModel);
      layoutResults.push(...fields);
    }
  }

  const sections = groupFieldsBySection(layoutResults);

  return {
    viewModel: topVM,
    portalName: tree.portalName,
    moduleName: tree.moduleName,
    sections,
    data,
  };
}

async function runResolver(
  resolver: DyFormResolver & { resolverType?: string },
  bodyParams: any
): Promise<Record<string, any>> {
  return DyformRepository.runResolver(
    resolver.resolverType ?? resolver.type,
    resolver.target,
    bodyParams
  );
}

async function getMetadataForVM(
  viewModel: string
): Promise<DyFormFieldDefinition[]> {
  const metadata = await DyformRepository.loadDyFormMetadata(viewModel);
  return metadata.sections.flatMap((section) =>
    section.fields.map((field) => ({
      ...field,
      sectionId: section.sectionId,
      sectionName: section.name,
      sectionLabel: section.label ?? section.name,
      sectionSortOrder: section.sortOrder ?? 0,
    }))
  );
}

function groupFieldsBySection(
  fields: DyFormFieldDefinition[]
): DyFormSections[] {
  const sections = new Map<string, DyFormSections>();

  for (const field of fields) {
    const section = sections.get(field.sectionId) ?? {
      sectionId: field.sectionId,
      sectionName: field.sectionName,
      label: field.sectionLabel,
      sortOrder: field.sectionSortOrder,
      fields: [],
    };

    section.fields?.push(field);
    sections.set(field.sectionId, section);
  }

  return Array.from(sections.values()).sort(
    (left, right) => left.sortOrder - right.sortOrder
  );
}
