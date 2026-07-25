import request from "supertest";
import { beforeEach, describe, expect, it, vi } from "vitest";

vi.mock("../src/config/db", () => ({
  sql: {
    NVarChar: vi.fn(),
  },
  poolPromise: Promise.resolve({
    request: () => ({
      query: vi.fn(async () => ({ recordset: [] })),
      input() {
        return this;
      },
      execute: vi.fn(async () => ({ recordset: [] })),
    }),
  }),
}));

vi.mock("../src/services/payments/authorizeNetProvider", () => ({
  AuthorizeNetProvider: class {
    createHostedPayment = vi.fn(async () => ({ token: "hosted-token" }));
    getIntentStatus = vi.fn(async () => ({ status: "created" }));
    processWebhook = vi.fn(async () => ({ ok: true }));
  },
}));

vi.mock("../src/utils/logger", () => ({
  logger: {
    info: vi.fn(),
    error: vi.fn(),
    warn: vi.fn(),
  },
}));

async function loadApp() {
  vi.resetModules();
  return (await import("../src/server")).app;
}

describe("server smoke routes and API contracts", () => {
  beforeEach(() => {
    process.env.SERVER_JWT_SECRET = "test-secret";
  });

  it("serves the public SkyLynx server home page", async () => {
    const app = await loadApp();

    const response = await request(app).get("/");

    expect(response.status).toBe(200);
    expect(response.type).toContain("html");
    expect(response.text).toContain("SkyLynx Server");
    expect(response.text).toContain("Server online");
    expect(response.text).toContain("Please move along");
  });

  it("serves the admin settings shell for admin URLs", async () => {
    const app = await loadApp();

    for (const path of ["/admin", "/server/login", "/server/settings"]) {
      const response = await request(app).get(path);
      expect(response.status).toBe(200);
      expect(response.type).toContain("html");
      expect(response.text).toContain("SkyLynx Server Admin");
    }
  });

  it("keeps basic API health and test-post routes working", async () => {
    const app = await loadApp();

    const health = await request(app).get("/api");
    const post = await request(app).post("/api/test-post").send({ ok: true });

    expect(health.status).toBe(200);
    expect(health.body).toEqual({ message: "Server is up!" });
    expect(post.status).toBe(200);
    expect(post.body).toEqual({
      message: "POST request successful",
      receivedData: { ok: true },
    });
  });

  it("requires portal API keys for protected application APIs", async () => {
    const app = await loadApp();
    const protectedRequests = [
      request(app).post("/api/auth/login").send({}),
      request(app).get("/api/users"),
      request(app).get("/api/roles"),
      request(app).get("/api/portals"),
      request(app).get("/api/dyform/viewmodel/UserProfile"),
      request(app).get("/api/protos/portaltree/UserProfile"),
      request(app).post("/api/nimbus/forms/loadform").send({}),
      request(app).post("/api/payments/authorizeNet/create-hosted-payment").send({}),
    ];

    for (const apiRequest of protectedRequests) {
      const response = await apiRequest;
      expect(response.status).toBe(400);
      expect(response.body.error).toBe("Missing skyx-api-key header");
    }
  });
});
