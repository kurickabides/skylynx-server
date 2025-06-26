// ================================================
// ✅ Repository: dyformRepository
// Description: Loads data via LoadUserFullProfileViewModel SP
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: dyformRepository.ts
// ================================================

import { sql, poolPromise } from "../../../config/db";
import { IRecordSet } from "mssql";

export async function loadUserProfileValues(
  userId: string
): Promise<IRecordSet<any>[]> {
  try {
    const pool = await poolPromise;
    const request = pool.request();
    request.input("UserID", sql.NVarChar(128), userId);

    const result = await request.execute("LoadUserFullProfileViewModel");

    // ✅ Explicitly cast result.recordsets as IRecordSet<any>[]
    const recordsets = result.recordsets as IRecordSet<any>[];

    if (!Array.isArray(recordsets)) {
      throw new Error("recordsets is not an array");
    }

    return recordsets;
  } catch (err) {
    console.error("❌ SP Execution Error:", err);
    throw err;
  }
}
