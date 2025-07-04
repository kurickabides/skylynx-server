// ================================================
// ✅ Module: NimbusCoreFactory
// Description: Entry point for resolving full DyForm ViewModel layout + values
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: nimbusCoreFactory.ts
// ================================================

import { getProtosTreeViewModelConfig } from "../../protos/repository/protosRepository";
import { loadDyFormMetadata } from "../../dyform/repositories/dyformRepository";

import { runResolver } from "../../helpers/resolverExecutor";
import { mapUserProfileResults } from "../../mappers/resultMapper";

import {
  ViewModelParams,
  SkylynxPortalViewModel,
  SkylynxPortalConfig,
} from "../../../entities/skylynx/types";

import {
  DyFormViewModel,
  DyFormSection,
  DyFormField,
} from "../../../entities/dyform/types";

export class NimbusCoreFactory {
  // 📦 Entry point to load full DyForm ViewModel (structure + values)
  static async loadForm(
    formVM: string,
    view: string,
    params: ViewModelParams
  ): Promise<DyFormViewModel> {
    // 1️⃣ Load full ViewModel tree config
    const portalTree: SkylynxPortalConfig = await getProtosTreeViewModelConfig(
      formVM
    );

    // 2️⃣ Get the active variant node
    const targetView = portalTree.variants.find((v) => v.viewModel === view);
    if (!targetView)
      throw new Error(`ViewModel '${view}' not found in variants`);

    // 3️⃣ Initialize the full ViewModel with context and structure
    const fullViewModel: DyFormViewModel = {
      viewModel: targetView.viewModel,
      portalName: targetView.portalName,
      moduleName: targetView.moduleName,
      context: {
        formName: portalTree.viewModel,
        template: targetView.template?.templateName || "",
        version: String(targetView.template?.version || ""),
        resolver: {
          method: "POST",
          path: "/api/nimbus/loadForm",
          type: "Internal",
        },
      },
      sections: [],
    };

    // 4️⃣ Traverse through children ViewModels
    const vmChildren = targetView.children || [];
    for (const vm of vmChildren) {
      const metadata = await loadDyFormMetadata(vm);
      fullViewModel.sections.push(...metadata.sections);

      if (vm.template?.resolver?.target) {
        const rawResults = await runResolver(vm.template.resolver, params);
        const mapped = mapUserProfileResults(metadata.fields, rawResults);

        // Set values on fields directly (flattened into section.fields)
        for (const section of metadata.sections) {
          for (const field of section.fields) {
            const mappedValue = mapped[field.fieldId];
            if (mappedValue !== undefined) {
              field.value = mappedValue;
            }
          }
        }
      }
    }

    return fullViewModel;
  }
}
