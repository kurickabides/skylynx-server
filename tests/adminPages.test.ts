import { describe, expect, it } from "vitest";
import { serverHomePage } from "../src/admin/serverHomePage";
import { serverLoginPage } from "../src/admin/serverLoginPage";

describe("admin and status pages", () => {
  it("renders a low-profile server home page", () => {
    expect(serverHomePage).toContain("<title>SkyLynx Server</title>");
    expect(serverHomePage).toContain("Server online");
    expect(serverHomePage).toContain("website server");
    expect(serverHomePage).toContain("If you are not the server administrator");
    expect(serverHomePage).toContain("Please move along");
  });

  it("includes the expected settings tabs and section labels", () => {
    expect(serverLoginPage).toContain('React.createElement(Tab, { label: "Database" })');
    expect(serverLoginPage).toContain('React.createElement(Tab, { label: "Payment Providers" })');
    expect(serverLoginPage).toContain('React.createElement(Tab, { label: "AI Providers" })');
    expect(serverLoginPage).toContain("Primary Core SQL Server");
    expect(serverLoginPage).toContain("Primary Portal SQL Server");
    expect(serverLoginPage).toContain("Backup Core SQL Server");
    expect(serverLoginPage).toContain("Backup Portal SQL Server");
    expect(serverLoginPage).toContain("Manage server and api settings.");
  });

  it("wires settings screen database actions to the expected API endpoints", () => {
    expect(serverLoginPage).toContain("/api/server/settings/database/test");
    expect(serverLoginPage).toContain("/api/server/settings/database/list");
    expect(serverLoginPage).toContain("/api/server/settings/database/create");
    expect(serverLoginPage).toContain("/api/server/settings/database/install");
    expect(serverLoginPage).toContain("Test Server");
    expect(serverLoginPage).toContain("Create Database");
    expect(serverLoginPage).toContain("Install Core DB");
    expect(serverLoginPage).toContain("Install Portal DB");
  });

  it("keeps database fields uncontrolled to avoid focus loss while typing", () => {
    expect(serverLoginPage).toContain('defaultValue: section.host || ""');
    expect(serverLoginPage).toContain('defaultValue: section.password || ""');
    expect(serverLoginPage).toContain('inputProps: { list: config.key + "-database-list" }');
    expect(serverLoginPage).toContain("setSectionMessage(sectionKey");
  });
});
