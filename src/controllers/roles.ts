// ================================================
// ✅ Controller: rolesController
// Description: Handles role lookup, creation, and assignment endpoints
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: controllers/roles.ts
// ================================================

import { Request, Response } from "express";
import RoleModel from "../services/roleModel"; // 👈 Corrected import

const { getAllRoles, createRole, assignUserRole } = RoleModel;

// ✅ Get all roles from stored procedure
const getAll = async (req: Request, res: Response) => {
  try {
    const roles = await getAllRoles();
    res.json(roles);
  } catch (error) {
    console.error("❌ Error fetching roles:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// ✅ Create a new role using stored procedure
const create = async (req: Request, res: Response) => {
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
const assignToUser = async (req: Request, res: Response) => {
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

// ✅ Named module export following your standard pattern
const roleController = {
  getAll,
  create,
  assignToUser,
};

export default roleController;
