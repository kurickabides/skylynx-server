import express from "express";
import fs from "fs";
import os from "os";
import path from "path";
import request from "supertest";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

describe("server auth routes", () => {
  const oldEnv = process.env;
  let tempDir: string;

  async function makeApp() {
    vi.resetModules();
    const routes = (await import("../src/routes/serverAuthRoutes")).default;
    const app = express();
    app.use(express.json());
    app.use("/api/server/auth", routes);
    return app;
  }

  beforeEach(() => {
    tempDir = fs.mkdtempSync(path.join(os.tmpdir(), "skylynx-auth-routes-"));
    process.env = {
      ...oldEnv,
      SKYLYNX_ADMIN_DIR: tempDir,
      SERVER_JWT_SECRET: "test-secret",
    };
  });

  afterEach(() => {
    process.env = oldEnv;
    fs.rmSync(tempDir, { recursive: true, force: true });
  });

  it("reports setup status, creates the first admin, and rejects duplicate setup", async () => {
    const app = await makeApp();

    let response = await request(app).get("/api/server/auth/status");
    expect(response.body).toEqual({ configured: false });

    response = await request(app)
      .post("/api/server/auth/setup")
      .send({ username: "admin", password: "long-password" });
    expect(response.status).toBe(201);
    expect(response.body).toMatchObject({
      configured: true,
      username: "admin",
      roles: ["SERVER_ADMIN"],
    });

    response = await request(app)
      .post("/api/server/auth/setup")
      .send({ username: "admin2", password: "long-password" });
    expect(response.status).toBe(409);
  });

  it("logs in and returns the current server admin with a valid token", async () => {
    const app = await makeApp();
    await request(app)
      .post("/api/server/auth/setup")
      .send({ username: "admin", password: "long-password" });

    const login = await request(app)
      .post("/api/server/auth/login")
      .send({ username: "admin", password: "long-password" });

    expect(login.status).toBe(200);
    expect(login.body.token).toEqual(expect.any(String));

    const me = await request(app)
      .get("/api/server/auth/me")
      .set("Authorization", `Bearer ${login.body.token}`);

    expect(me.status).toBe(200);
    expect(me.body.admin).toMatchObject({
      username: "admin",
      roles: ["SERVER_ADMIN"],
      scope: "skylynx-server-admin",
    });
  });

  it("rejects bad login and missing or invalid tokens", async () => {
    const app = await makeApp();
    await request(app)
      .post("/api/server/auth/setup")
      .send({ username: "admin", password: "long-password" });

    const login = await request(app)
      .post("/api/server/auth/login")
      .send({ username: "admin", password: "wrong-password" });
    expect(login.status).toBe(401);

    const missing = await request(app).get("/api/server/auth/me");
    expect(missing.status).toBe(401);

    const invalid = await request(app)
      .get("/api/server/auth/me")
      .set("Authorization", "Bearer bad-token");
    expect(invalid.status).toBe(401);
  });
});
