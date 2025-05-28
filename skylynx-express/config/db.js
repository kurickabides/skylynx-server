const sql = require("mssql");

// Database Configuration
const config = {
  user: process.env.DB_USER || "NOT_SET",
  password: process.env.DB_PASSWORD || "NOT_SET",
  server: process.env.DB_HOST || "NOT_SET",
  port: parseInt(process.env.DB_PORT, 10) || 1433,
  database: process.env.DB_NAME || "NOT_SET",
  options: {
    encrypt: false,
    trustServerCertificate: true,
  },
};

// Debugging Logs
console.log("🔹 Database Configuration:");
console.log(`DB_USER: ${config.user}`);
console.log(`DB_PASSWORD: ${config.password ? "*****" : "NOT SET"}`);
console.log(`DB_HOST: ${config.server}`);
console.log(`DB_PORT: ${config.port}`);
console.log(`DB_NAME: ${config.database}`);

let poolPromise; // Ensure it's defined

try {
  poolPromise = new sql.ConnectionPool(config)
    .connect()
    .then((pool) => {
      console.log("✅ Connected to SQL Server");
      return pool;
    })
    .catch((err) => {
      console.error("❌ Database Connection Failed!", err);
      throw new Error("Database connection failed: " + err.message);
    });
} catch (err) {
  console.error("❌ Critical Error in DB Connection:", err);
}

module.exports = { sql, poolPromise };
