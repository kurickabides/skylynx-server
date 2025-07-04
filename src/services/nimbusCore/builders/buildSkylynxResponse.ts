// ================================================
// ✅ Function: buildSkylynxResponse
// Description: Builds full response using tree, layout SP, and data resolver
// Filename: buildSkylynxResponse.ts
// ================================================

export async function buildSkylynxResponse(
  tree: PortalViewModelNode,
  bodyParams: any
): Promise<SkylynxPortalResponse> {
  const topVM = tree.viewModel;
  const context = getPMContextStub(tree);

  // 1️⃣ Get data using resolver on top-level only
  const data: Record<string, any> = {};
  if (tree.resolver?.target) {
    const resolvedData = await runResolver(tree.resolver, bodyParams);
    Object.assign(data, resolvedData); // Example: { vmAspNetUserModel: {...}, ... }
  }

  // 2️⃣ Get all metadata by calling Layout SP for every child ViewModel
  const layoutResults: DyFormFieldDefinition[] = [];
  for (const variant of tree.variants ?? []) {
    for (const child of variant.children ?? []) {
      const fields = await getMetadataForVM(child.viewModel);
      layoutResults.push(...fields);
    }
  }

  // 3️⃣ Group fields by SectionID to form `sections: SectionWithFields[]`
  const sections = groupFieldsBySection(layoutResults);

  // 4️⃣ Return final SkylynxPortalResponse
  return {
    viewModel: topVM,
    portalName: tree.portalName,
    moduleName: tree.moduleName,
    context,
    sections,
    data,
  };
}
