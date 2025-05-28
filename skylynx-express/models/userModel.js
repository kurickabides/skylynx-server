const { poolPromise, sql } = require("../config/db");

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
const getUserById = async (userId) => {
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
const createUser = async (username, email, passwordHash) => {
  try {
    const userId = randomUUID(); // Generate UserId in application code
    const pool = await poolPromise;
    const result = await pool
      .request()
      .input("UserName", sql.NVarChar(100), username)
      .input("Email", sql.NVarChar(256), email)
      .input("PasswordHash", sql.NVarChar(sql.MAX), passwordHash)
      .output("UserID", sql.UniqueIdentifier) // Send generated UserId to SP
      .execute("CreateUser");

    return userId;
  } catch (error) {
    console.error(`❌ Error creating user (${email}):`, error);
    throw error;
  }
};



// ✅ Assign a role to a user using stored procedure
const assignUserRole = async (userId, roleId) => {
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
const getUserRoles = async (userId) => {
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
const validateUserByEmail = async (email) => {
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
module.exports = {
  getAllUsers,
  getUserById,
  createUser,
  assignUserRole,
  getUserRoles,
  validateUserByEmail,
};
