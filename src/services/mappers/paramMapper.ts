// ================================================
// ✅ Mapper: mapRequestToParams
// Description: Converts IKeyValuePair[] to key-value object map
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: mapRequestToParams.ts
// ================================================

import { IKeyValuePair } from "../../entities/skylynx/types";

export function mapRequestToParams(
  params: IKeyValuePair[]
): Record<string, string> {
  const result: Record<string, string> = {};

  for (const { key, value } of params) {
    if (key) result[key] = value;
  }

  return result;
}
