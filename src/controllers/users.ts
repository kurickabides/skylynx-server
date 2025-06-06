import { Request, Response } from "express";
import userModel from "../services/userModel";

const { getAllUsers, getUserById, createUser, assignUserRole, getUserRoles } =
  userModel;

// ✅ Get all users
const getAll = async (req: Request, res: Response) => {
  try {
    const users = await getAllUsers();
    res.json(users);
  } catch (error) {
    console.error("❌ Failed to fetch users:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// ✅ Get a specific user by ID
const getById = async (req: Request, res: Response) => {
  try {
    const user = await getUserById(req.params.id);
    if (!user) return res.status(404).json({ error: "User not found" });

    res.json(user);
  } catch (error) {
    console.error("❌ Failed to fetch user:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// ✅ Create a user
const create = async (req: Request, res: Response) => {
  try {
    const { username, email, passwordHash } = req.body;
    const userId = await createUser(username, email, passwordHash);
    res.status(201).json({ message: "User created", userId });
  } catch (error) {
    console.error("❌ Failed to create user:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// ✅ Assign a role to user
const assignRole = async (req: Request, res: Response) => {
  try {
    const userId = req.params.id;
    const { roleId } = req.body;
    await assignUserRole(userId, roleId);
    res.json({ message: "Role assigned successfully" });
  } catch (error) {
    console.error("❌ Failed to assign role:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// ✅ Get roles for a user
const getRoles = async (req: Request, res: Response) => {
  try {
    const roles = await getUserRoles(req.params.id);
    res.json(roles);
  } catch (error) {
    console.error("❌ Failed to get user roles:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// ✅ Final export following your enforced module naming convention
const userController = {
  getAll,
  getById,
  create,
  assignRole,
  getRoles,
};

export default userController;
