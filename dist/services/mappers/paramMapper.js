"use strict";
// ================================================
// ✅ Mapper: mapRequestToParams
// Description: Converts IKeyValuePair[] to key-value object map
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: mapRequestToParams.ts
// ================================================
Object.defineProperty(exports, "__esModule", { value: true });
exports.mapRequestToParams = mapRequestToParams;
function mapRequestToParams(params) {
    const result = {};
    for (const { key, value } of params) {
        if (key)
            result[key] = value;
    }
    return result;
}
