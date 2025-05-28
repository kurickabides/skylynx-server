const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const {
  getUserById,
  createUser,
  getUserRoles,
  validateUserByEmail,
} = require("../models/userModel");

const JWT_SECRET = process.env.JWT_SECRET;

// ✅ User Signup with Stored Procedure
const signup = async (req, res) => {
  try {
    const { username, email, password } = req.body;
    if (!username || !email || !password) {
      return res
        .status(400)
        .json({ error: "Username, email, and password are required." });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const userId = await createUser(username, email, hashedPassword);

    res.status(201).json({ message: "User registered successfully", userId });
  } catch (error) {
    console.error("❌ Signup Error:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// ✅ User Login with Stored Procedure
const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res
        .status(400)
        .json({ error: "Email and password are required." });
    }

    const user = await validateUserByEmail(email);
    if (!user) {
      return res.status(401).json({ error: "Invalid email or password" });
    }

    const isMatch = await bcrypt.compare(password, user.PasswordHash);
    if (!isMatch) {
      return res.status(401).json({ error: "Invalid email or password" });
    }

    const userRoles = await getUserRoles(user.Id);
    const token = jwt.sign({ id: user.Id, roles: userRoles }, JWT_SECRET, {
      expiresIn: "1h",
    });

    res.json({ message: "Login successful", token, roles: userRoles });
  } catch (error) {
    console.error("❌ Login Error:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

module.exports = { signup, login };
