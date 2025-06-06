"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const db_1 = require("../config/db");
// ✅ Get all roles using a stored procedure
const getAllRoles = async () => {
    try {
        const pool = await db_1.poolPromise;
        const result = await pool.request().execute("GetAllRoles");
        return result.recordset;
    }
    catch (error) {
        console.error("❌ Error fetching roles:", error);
        throw error;
    }
};
// ✅ Create a new role using a stored procedure
const createRole = async (roleName) => {
    try {
        const pool = await db_1.poolPromise;
        await pool
            .request()
            .input("RoleName", db_1.sql.NVarChar, roleName)
            .execute("CreateRole");
    }
    catch (error) {
        console.error("❌ Error creating role:", error);
        throw error;
    }
};
// ✅ Assign a role to a user using stored procedure
const assignUserRole = async (userId, roleId) => {
    try {
        const pool = await db_1.poolPromise;
        await pool
            .request()
            .input("UserId", db_1.sql.NVarChar, userId)
            .input("RoleId", db_1.sql.NVarChar, roleId)
            .execute("AssignUserRole");
    }
    catch (error) {
        console.error("❌ Error assigning role:", error);
        throw error;
    }
};
// ✅ Export using standard object pattern
const RoleModel = {
    getAllRoles,
    createRole,
    assignUserRole,
};
exports.default = RoleModel;
