// ================================================
// ✅ Server: SkyLynx Express Server
// Description: Configures middleware, routes, health pages, and graceful shutdown
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: server.ts
// ================================================
import express, { Request, Response, NextFunction } from "express";
import cors from "cors";
import dotenv from "dotenv";
import http from "http"; // ✅ Required for graceful shutdown

import authRoutes from "./routes/authRoutes";
import userRoutes from "./routes/userRoutes";
import roleRoutes from "./routes/roleRoutes";
import portalRoutes from "./routes/portalRoutes";
import { poolPromise } from "./config/db";
import authenticateAPI from "./middleware/authenticateAPI"; // ✅ renamed for portal key auth
import dyformRoutes from "./routes/dyformRoutes";
import protosRoutes  from "./routes/protos";
import nimbusCoreRoutes  from "./routes/nimbusCore";
import paymentRoutes from "./routes/paymentRoutes";
import serverAuthRoutes from "./routes/serverAuthRoutes";
import serverSettingsRoutes from "./routes/serverSettingsRoutes";
import { serverLoginPage } from "./admin/serverLoginPage";
import { serverHomePage } from "./admin/serverHomePage";

dotenv.config();

export const app = express();
const port = parseInt(process.env.PORT || "3200", 10);

// Middleware
app.use(cors());
app.use(express.json());

app.get("/", (req: Request, res: Response) => {
  res.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, proxy-revalidate");
  res.setHeader("Pragma", "no-cache");
  res.setHeader("Expires", "0");
  res.type("html").send(serverHomePage);
});

// Server admin console routes. These are intentionally separate from portal API key auth.
app.get(["/admin", "/server/login", "/server/settings"], (req: Request, res: Response) => {
  res.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, proxy-revalidate");
  res.setHeader("Pragma", "no-cache");
  res.setHeader("Expires", "0");
  res.type("html").send(serverLoginPage);
});
app.use("/api/server/auth", serverAuthRoutes);
app.use("/api/server/settings", serverSettingsRoutes);

// Routes
app.use("/api/auth", authenticateAPI, authRoutes);
app.use("/api/users", authenticateAPI, userRoutes);
app.use("/api/roles", authenticateAPI, roleRoutes);
app.use("/api/portals", authenticateAPI, portalRoutes);
app.use("/api/dyform", authenticateAPI, dyformRoutes);
app.use("/api/protos/", authenticateAPI, protosRoutes);
app.use("/api/nimbus/", authenticateAPI, nimbusCoreRoutes);
app.use("/api/payments", paymentRoutes);


// Base API Route
app.get("/api", (req: Request, res: Response) => {
  res.json({ message: "Server is up!" });
});

// Test POST API Route
app.post("/api/test-post", (req: Request, res: Response) => {
  res.json({ message: "POST request successful", receivedData: req.body });
});

// Test DB
app.get("/api/test-db", async (req: Request, res: Response) => {
  try {
    const pool = await poolPromise;
    const result = await pool
      .request()
      .query("SELECT TOP 1 * FROM AspNetUsers");
    res.json(result.recordset);
  } catch (err: any) {
    console.error("DB Error:", err);
    res.status(500).json({ error: err.message });
  }
});

// Global Error Handler
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  console.error("Unhandled Error:", err);
  res.status(500).json({ error: err.message });
});

// ✅ Create server for shutdown control
if (require.main === module) {
const server = http.createServer(app);

server.listen(port, "0.0.0.0", () => {
  console.log(`🚀 API is running on port ${port}`);
});

// ✅ Graceful Shutdown Logic
const shutdown = () => {
  console.info(`🛑 Graceful shutdown at ${new Date().toISOString()}`);
  server.close((err) => {
    if (err) {
      console.error("❌ Error during shutdown:", err);
      process.exitCode = 1;
    }
    process.exit();
  });
};

process.on("SIGINT", shutdown); // e.g. Ctrl+C
process.on("SIGTERM", shutdown); // e.g. docker stop
}
