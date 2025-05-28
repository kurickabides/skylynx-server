const {
  getAllRoles,
  createRole,
  assignUserRole,
} = require("../models/roleModel");

// ✅ Get all roles from stored procedure
const getRoles = async (req, res) => {
  try {
    const roles = await getAllRoles();
    res.json(roles);
  } catch (error) {
    console.error("❌ Error fetching roles:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// ✅ Create a new role using stored procedure
const createRoleController = async (req, res) => {
  try {
    const { roleName } = req.body;
    if (!roleName) {
      return res.status(400).json({ error: "Role name is required" });
    }

    await createRole(roleName);
    res.status(201).json({ message: "Role created successfully" });
  } catch (error) {
    console.error("❌ Error creating role:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// ✅ Assign a role to a user using stored procedure
const assignRoleToUser = async (req, res) => {
  try {
    const { userId, roleId } = req.body;
    if (!userId || !roleId) {
      return res
        .status(400)
        .json({ error: "User ID and Role ID are required" });
    }

    await assignUserRole(userId, roleId);
    res.json({ message: "Role assigned successfully" });
  } catch (error) {
    console.error("❌ Error assigning role:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// ✅ Export role controllers
module.exports = { getRoles, createRoleController, assignRoleToUser };
