import express from "express";
import request from "supertest";
import { describe, expect, it, vi } from "vitest";

const verifyToken = vi.fn();

vi.mock("../src/services/serverAdminService", () => ({
  default: { verifyToken },
}));

async function makeApp() {
  const app = express();
  const { authenticateServerAdmin } = await import("../src/middleware/serverAdminMiddleware");
  app.get("/protected", authenticateServerAdmin, (req, res) => {
    res.json({ admin: req.serverAdmin });
  });
  return app;
}

describe("server admin middleware", () => {
  it("rejects requests without a bearer token", async () => {
    const response = await request(await makeApp()).get("/protected");

    expect(response.status).toBe(401);
    expect(response.body.error).toBe("Missing server admin token.");
  });

  it("rejects tokens without the SERVER_ADMIN role", async () => {
    verifyToken.mockReturnValueOnce({
      username: "admin",
      roles: ["USER"],
      scope: "skylynx-server-admin",
    });

    const response = await request(await makeApp())
      .get("/protected")
      .set("Authorization", "Bearer valid-token");

    expect(response.status).toBe(403);
    expect(response.body.error).toBe("Server admin role required.");
  });

  it("attaches the decoded server admin token to valid requests", async () => {
    verifyToken.mockReturnValueOnce({
      sub: "server-owner",
      username: "admin",
      roles: ["SERVER_ADMIN"],
      scope: "skylynx-server-admin",
    });

    const response = await request(await makeApp())
      .get("/protected")
      .set("Authorization", "Bearer valid-token");

    expect(response.status).toBe(200);
    expect(response.body.admin).toMatchObject({
      username: "admin",
      roles: ["SERVER_ADMIN"],
    });
  });
});
