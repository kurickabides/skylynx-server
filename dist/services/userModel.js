"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const db_1 = require("../config/db");
// import { randomUUID } from "crypto"; // Uncomment if generating UUIDs in app logic
// ✅ Fetch all users using stored procedure
const getAllUsers = async () => {
    try {
        const pool = await db_1.poolPromise;
        const result = await pool.request().execute("GetAllUsers");
        return result.recordset;
    }
    catch (error) {
        console.error("❌ Error fetching users:", error);
        throw error;
    }
};
// ✅ Fetch a single user by ID using stored procedure  
const getUserById = async (userId) => {
    try {
        const pool = await db_1.poolPromise;
        const result = await pool
            .request()
            .input("UserId", db_1.sql.NVarChar, userId)
            .execute("GetUserById");
        return result.recordset.length > 0 ? result.recordset[0] : null;
    }
    catch (error) {
        console.error(`❌ Error fetching user with ID ${userId}:`, error);
        throw error;
    }
};
// ✅ Create a new user using stored procedure
const createUser = async (username, email, passwordHash) => {
    try {
        const userId = email; // Replace with `randomUUID()` if needed
        const pool = await db_1.poolPromise;
        await pool
            .request()
            .input("UserID", db_1.sql.NVarChar(128), userId)
            .input("UserName", db_1.sql.NVarChar(100), username)
            .input("Email", db_1.sql.NVarChar(256), email)
            .input("PasswordHash", db_1.sql.NVarChar(db_1.sql.MAX), passwordHash)
            .execute("CreateUser");
        return userId;
    }
    catch (error) {
        console.error(`❌ Error creating user (${email}):`, error);
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
        console.error(`❌ Error assigning role ${roleId} to user ${userId}:`, error);
        throw error;
    }
};
// ✅ Get user roles using stored procedure
const getUserRoles = async (userId) => {
    try {
        const pool = await db_1.poolPromise;
        const result = await pool
            .request()
            .input("UserId", db_1.sql.NVarChar, userId)
            .execute("GetUserRoles");
        return result.recordset.map((row) => row.Name);
    }
    catch (error) {
        console.error(`❌ Error fetching roles for user ${userId}:`, error);
        throw error;
    }
};
// ✅ Validate user by email using stored procedure
const validateUserByEmail = async (email) => {
    try {
        const pool = await db_1.poolPromise;
        const result = await pool
            .request()
            .input("Email", db_1.sql.NVarChar, email)
            .execute("ValidateUserByEmail");
        return result.recordset.length > 0 ? result.recordset[0] : null;
    }
    catch (error) {
        console.error(`❌ Error validating user with Email ${email}:`, error);
        throw error;
    }
};
// ✅ Export all functions
exports.default = {
    getAllUsers,
    getUserById,
    createUser,
    assignUserRole,
    getUserRoles,
    validateUserByEmail,
};
