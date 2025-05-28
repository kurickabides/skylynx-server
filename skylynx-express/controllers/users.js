const bcrypt = require("bcryptjs");
const {
  getAllUsers,
  getUserById,
  createUser,
  assignUserRole,
  getUserRoles,
} = require("../models/userModel");

const getUsers = async (req, res) => {
  try {
    const users = await getAllUsers();
    res.json(users);
  } catch (error) {
    console.error("❌ Error fetching users:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

const getUser = async (req, res) => {
  try {
    const userId = req.params.id;
    if (!userId) {
      return res.status(400).json({ error: "User ID is required" });
    }

    const user = await getUserById(userId);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    res.json(user);
  } catch (error) {
    console.error("❌ Error fetching user:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

const createUserController = async (req, res) => {
  try {
    const { username, email, password } = req.body;
    if (!username || !email || !password) {
      return res
        .status(400)
        .json({ error: "Username, email, and password are required" });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const userId = await createUser(username, email, hashedPassword);
    res.status(201).json({ userId });
  } catch (error) {
    console.error("❌ Error creating user:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

const assignRoleToUser = async (req, res) => {
  try {
    const userId = req.params.id;
    const roleId = req.body.roleId;

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

const getUserRolesController = async (req, res) => {
  try {
    const userId = req.params.id;
    if (!userId) {
      return res.status(400).json({ error: "User ID is required" });
    }

    const roles = await getUserRoles(userId);
    res.json({ roles });
  } catch (error) {
    console.error("❌ Error fetching user roles:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

module.exports = {
  getUsers,
  getUser,
  createUserController,
  assignRoleToUser,
  getUserRolesController,
};
