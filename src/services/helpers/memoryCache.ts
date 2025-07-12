// ================================================
// ✅ Module: MemoryCache
// Description: Simple in-memory cache for portal metadata trees
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: memoryCache.ts
// ================================================

import { getProtosTreeViewModelConfig } from "../protos/repository/protosRepository";
import {
  SkylynxPortalCache,
  SkylynxPortalConfig,
} from "../../entities/skylynx/types";

const cache: SkylynxPortalCache = {};

export class MemoryCache {
  /**
   * ✅ Returns cached portal tree structure by form name,
   * retrieving and storing it if not already cached.
   */
  static async getCachedPortalTree(
    formName: string
  ): Promise<SkylynxPortalConfig> {
    if (!cache[formName]) {
      const config = await getProtosTreeViewModelConfig(formName);
      cache[formName] = config;
    }
    return cache[formName]; // ✅ Corrected return
  }
}
