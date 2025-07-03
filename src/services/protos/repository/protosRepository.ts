// ================================================
// ✅ Repository: protosRepository
// Description: Fetches DyForm ViewModel Tree as SkylynxPortalConfig
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename:protosRepository.ts
// ================================================

import { sql, poolPromise } from "../../../config/db";
import { SkylynxPortalConfig } from "../../../entities/skylynx/types";
import { mapPortalViewModelTree  } from "../../../services/mappers/skylynxPortalMapper"; // ✅ Use updated path

// ================================================
// ✅ Function: getProtosTreeViewModelConfig
// Description: Loads SkylynxPortalConfig by calling SkylynxPortalViewModelTree
// ================================================
export async function getProtosTreeViewModelConfig(
  viewModel: string
): Promise<SkylynxPortalConfig> {
  try {
    const pool = await poolPromise;
    const result = await pool
      .request()
      .input("ViewModelName", sql.NVarChar, viewModel)
      .execute("LoadSkylynxPortalVMTree"); // ✅ Updated to match current SP
    const recordsets = result.recordsets;

    return mapPortalViewModelTree(recordsets as any[][]);// ✅ Use new mapper
  } catch (error) {
    console.error("❌ Failed to load SkylynxPortalConfig:", error);
    throw error;
  }
}
