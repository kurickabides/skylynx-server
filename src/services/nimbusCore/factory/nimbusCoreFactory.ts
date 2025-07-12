// ================================================
// ✅ Module: NimbusCoreFactory
// Description: Entry point for resolving full DyForm ViewModel layout + values
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: nimbusCoreFactory.ts
// ================================================

import { getSkylynxPortalTemplateTree } from "../../protos/repository/protosRepository";
import { DyformRepository } from "../../dyform/repositories/dyformRepository";
import { ResultMapper } from "../../mappers/resultMapper";

import { ViewModelParams } from "../../../entities/skylynx/types";
import { DyFormViewModel } from "../../../entities/dyform/types";
import {
  SkylynxTemplateNode,
  PortalTemplateTree,
} from "../../../entities/protos/types";
export class NimbusCoreFactory {
  // 📦 Entry point to load full DyForm ViewModel (structure + values) from Portal Template Tree
  static async loadFormFromPortal(
    portalName: string,
    params: ViewModelParams
  ): Promise<DyFormViewModel> {
    const tree: PortalTemplateTree = await getSkylynxPortalTemplateTree(
      portalName
    );

    const viewModelNode = findFirstDyFormVM(tree.children);
    if (!viewModelNode)
      throw new Error("No DyFormVM node found in portal tree");

    const formVersionID = viewModelNode.template.versionID;
    const formName = viewModelNode.template.templateName;

    const metadata = await DyformRepository.loadDyFormMetadata(formVersionID);

    const formViewModel: DyFormViewModel = {
      viewModel: formName,
      portalName: tree.PortalName,
      moduleName: "",
      context: {
        formName,
        template: formName,
        version: String(viewModelNode.template.version || ""),
        resolver: {
          method: "POST",
          path: "/api/nimbus/forms/loadform",
          type: "Internal",
        },
      },
      sections: metadata.sections,
    };

    if (viewModelNode.template?.resolver?.target) {
      const rawResults = await DyformRepository.runResolver(
        viewModelNode.template.resolver.resolverType,
        viewModelNode.template.resolver.target,
        params
      );
      const values = ResultMapper.mapFormData(metadata.sections, rawResults);

      for (const section of formViewModel.sections) {
        for (const field of section.fields) {
          const value = values[field.fieldId];
          if (value !== undefined) {
            field.value = value;
          }
        }
      }
    }

    return formViewModel;
  }
}

function findFirstDyFormVM(
  nodes?: SkylynxTemplateNode[]
): SkylynxTemplateNode | undefined {
  if (!nodes) return undefined;
  for (const node of nodes) {
    if (node.template.templateType.TargetTypeName === "DyFormVM") {
      return node;
    }
    const found = findFirstDyFormVM(node.children);
    if (found) return found;
  }
  return undefined;
}
