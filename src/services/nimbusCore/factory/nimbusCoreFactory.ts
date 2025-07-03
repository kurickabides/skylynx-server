// ================================================
// ✅ Module: NimbusCoreFactory
// Description: Entry point for resolving full DyForm ViewModel layout + values
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: nimbusCoreFactory.ts
// ================================================

import { getProtosTreeViewModelConfig } from "../../protos/repository/protosRepository";
import {
  getResolverForViewModel,
  loadDyFormMetadata,
} from "../../dyform/repositories/dyformRepository";

import { runResolver } from "../../helpers/resolverExecutor";
import { mapResultsToFields } from "../../mappers/resultMapper";
import {

  ViewModelParams,
} from "../../../entities/skylynx/types";
import {
  DyFormViewModel,
} from "../../../entities/dyform/types";


export class NimbusCoreFactory {
  // 📦 Entry point to load full DyForm ViewModel (structure + values)
  static async loadForm(
    formVM: string,
    view: string,
    params: ViewModelParams
  ): Promise<DyFormViewModel> {
    // 1️⃣ Get ViewModel tree for the form (includes sub-ViewModels)
    const vmTree = await getViewModelTree(formVM);

    // 2️⃣ Loop through all ViewModels and build metadata + data
    const fullViewModel: DyFormViewModel = {
      formVM,
      view,
      sections: [],
      fieldValues: {},
    };

    for (const vm of vmTree) {
      // 🔹 Step 3: Load DyForm metadata for current ViewModel
      const metadata = await loadDyFormMetadata(vm);
      fullViewModel.sections.push(...metadata.sections);

      // 🔹 Step 4: Resolve associated data for ViewModel
      const resolver = await getResolverForViewModel(vm);
      const rawResults = await runResolver(resolver, params);

      // 🔹 Step 5: Map results to metadata FieldKeys
      const mapped = mapResultsToFields(metadata.fields, rawResults);

      // 🔹 Step 6: Merge field values
      Object.assign(fullViewModel.fieldValues, mapped);
    }

    return fullViewModel;
  }
}
