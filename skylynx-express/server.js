const express = require("express");
const cors = require("cors"); // ✅ Import CORS
const authRoutes = require("./routes/authRoutes");
const userRoutes = require("./routes/userRoutes");
const roleRoutes = require("./routes/roleRoutes");
const portalRoutes = require("./routes/portalRoutes");

const { poolPromise, sql } = require("./config/db");

const app = express();
const port = process.env.PORT || 3200;

// Debugging - Log startup
console.log("🔹 Starting API Server...");

// Middleware
app.use(cors()); // ✅ Enable CORS
app.use(express.json()); // ✅ Ensure JSON is parsed

// Debugging - Log middleware load
console.log("✅ Middleware Loaded");

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/users", userRoutes);
app.use("/api/roles", roleRoutes);
app.use("/api/portals", portalRoutes);

// Debugging - Log registered routes
console.log("✅ Routes Registered");

// Test API Route
app.get("/api", (req, res) => {
  res.json({ message: "Server is up!" });
});

// Test POST API Route
app.post("/api/test-post", (req, res) => {
  console.log(
    "🔹 Received POST request to /api/test-post with data:",
    req.body
  );
  res.json({ message: "POST request successful", receivedData: req.body });
});

// Database Connection Test Route
app.get("/api/test-db", async (req, res) => {
  try {
    if (!poolPromise) {
      throw new Error(
        "❌ Database poolPromise is undefined. The DB connection might have failed."
      );
    }

    const pool = await poolPromise;
    const result = await pool
      .request()
      .query("SELECT TOP 1 * FROM AspNetUsers");
    res.json(result.recordset);
  } catch (err) {
    console.error("❌ API Database Query Error:", err);
    res.status(500).json({ error: err.message, stack: err.stack });
  }
});

// Global Error Handler (For Uncaught Route Errors)
app.use((err, req, res, next) => {
  console.error("❌ Unhandled Error:", err);
  res.status(500).json({ error: err.message, stack: err.stack });
});

// Start Express Server
app.listen(port, "0.0.0.0", () => {
  console.log(`🚀 API is running on port ${port}`);
});
