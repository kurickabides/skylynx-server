"use strict";
// ================================================
// ✅ Module: MemoryCache
// Description: Simple in-memory cache for portal metadata trees
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: memoryCache.ts
// ================================================
Object.defineProperty(exports, "__esModule", { value: true });
exports.MemoryCache = void 0;
const protosRepository_1 = require("../protos/repository/protosRepository");
const cache = {};
class MemoryCache {
    /**
     * ✅ Returns cached portal tree structure by form name,
     * retrieving and storing it if not already cached.
     */
    static async getCachedPortalTree(formName) {
        if (!cache[formName]) {
            const config = await (0, protosRepository_1.getProtosTreeViewModelConfig)(formName);
            cache[formName] = config;
        }
        return cache[formName]; // ✅ Corrected return
    }
}
exports.MemoryCache = MemoryCache;
