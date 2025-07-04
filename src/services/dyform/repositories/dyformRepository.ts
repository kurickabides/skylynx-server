// ================================================
// ✅ Repository: dyformRepository
// Description: Handles DyForm resolver-based execution
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: dyformRepository.ts
// ================================================

import { sql, poolPromise } from "../../../config/db";
import { IRecordSet } from "mssql";




export class DyformRepository {
  // ================================================
  // ✅ Method: runResolver
  // Description: Dynamically executes resolver target (SP or JSON)
  // ================================================
  static async runResolver(
    resolverType: string,
    target: string,
    params: { [key: string]: any }
  ): Promise<Record<string, any>> {
    try {
      if (resolverType === "StoredProcedure" || resolverType === "sp") {
        const pool = await poolPromise;
        const request = pool.request();

        for (const [key, value] of Object.entries(params)) {
          request.input(key, value);
        }

        const result = await request.execute(target);
        const record = result.recordset?.[0] || {};

        return record;
      }

      if (resolverType === "MockJson") {
        return JSON.parse(target);
      }

      throw new Error(`Unsupported resolver type: ${resolverType}`);
    } catch (err) {
      console.error("❌ Resolver execution failed:", err);
      throw err;
    }
  }
}
