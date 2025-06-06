import { poolPromise, sql } from "../config/db";
// import { randomUUID } from "crypto"; // Uncomment if generating UUIDs in app logic

// ✅ Fetch all users using stored procedure
const getAllUsers = async () => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().execute("GetAllUsers");
    return result.recordset;
  } catch (error) {
    console.error("❌ Error fetching users:", error);
    throw error;
  }
};

// ✅ Fetch a single user by ID using stored procedure  
const getUserById = async (userId: string) => {
  try {
    const pool = await poolPromise;
    const result = await pool
      .request()
      .input("UserId", sql.NVarChar, userId)
      .execute("GetUserById");

    return result.recordset.length > 0 ? result.recordset[0] : null;
  } catch (error) {
    console.error(`❌ Error fetching user with ID ${userId}:`, error);
    throw error;
  }
};

// ✅ Create a new user using stored procedure
const createUser = async (
  username: string,
  email: string,
  passwordHash: string
): Promise<string> => {
  try {
    const userId = email; // Replace with `randomUUID()` if needed
    const pool = await poolPromise;

    await pool
      .request()
      .input("UserID", sql.NVarChar(128), userId)
      .input("UserName", sql.NVarChar(100), username)
      .input("Email", sql.NVarChar(256), email)
      .input("PasswordHash", sql.NVarChar(sql.MAX), passwordHash)
      .execute("CreateUser");

    return userId;
  } catch (error) {
    console.error(`❌ Error creating user (${email}):`, error);
    throw error;
  }
};

// ✅ Assign a role to a user using stored procedure
const assignUserRole = async (userId: string, roleId: string) => {
  try {
    const pool = await poolPromise;
    await pool
      .request()
      .input("UserId", sql.NVarChar, userId)
      .input("RoleId", sql.NVarChar, roleId)
      .execute("AssignUserRole");
  } catch (error) {
    console.error(
      `❌ Error assigning role ${roleId} to user ${userId}:`,
      error
    );
    throw error;
  }
};

// ✅ Get user roles using stored procedure
const getUserRoles = async (userId: string): Promise<string[]> => {
  try {
    const pool = await poolPromise;
    const result = await pool
      .request()
      .input("UserId", sql.NVarChar, userId)
      .execute("GetUserRoles");

    return result.recordset.map((row) => row.Name);
  } catch (error) {
    console.error(`❌ Error fetching roles for user ${userId}:`, error);
    throw error;
  }
};

// ✅ Validate user by email using stored procedure
const validateUserByEmail = async (email: string) => {
  try {
    const pool = await poolPromise;
    const result = await pool
      .request()
      .input("Email", sql.NVarChar, email)
      .execute("ValidateUserByEmail");

    return result.recordset.length > 0 ? result.recordset[0] : null;
  } catch (error) {
    console.error(`❌ Error validating user with Email ${email}:`, error);
    throw error;
  }
};

// ✅ Export all functions
export default {
  getAllUsers,
  getUserById,
  createUser,
  assignUserRole,
  getUserRoles,
  validateUserByEmail,
};
