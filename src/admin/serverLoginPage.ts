// ================================================
// ✅ Page: serverLoginPage
// Description: Browser-based server admin login and settings console
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: admin/serverLoginPage.ts
// ================================================

export const serverLoginPage = `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>SkyLynx Server Admin</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <script src="https://unpkg.com/react@18/umd/react.production.min.js"></script>
  <script src="https://unpkg.com/react-dom@18/umd/react-dom.production.min.js"></script>
  <script src="https://unpkg.com/@emotion/react@11.11.4/dist/emotion-react.umd.min.js"></script>
  <script src="https://unpkg.com/@emotion/styled@11.11.0/dist/emotion-styled.umd.min.js"></script>
  <script src="https://unpkg.com/@mui/material@5.15.20/umd/material-ui.production.min.js"></script>
  <style>
    body { margin: 0; font-family: Inter, Arial, sans-serif; background: #f6f8fb; color: #172033; }
    #root { min-height: 100vh; }
  </style>
</head>
<body>
  <div id="root"></div>
  <script>
    const { useEffect, useState } = React;
    const {
      Alert, Box, Button, Card, CardContent, Chip, Container, CssBaseline,
      Divider, FormControlLabel, Grid, Stack, Switch, TextField, ThemeProvider,
      Tab, Tabs, Typography, createTheme
    } = MaterialUI;

    const theme = createTheme({
      palette: {
        mode: "light",
        primary: { main: "#125c8a" },
        secondary: { main: "#6d5f2f" },
        background: { default: "#f6f8fb" }
      },
      shape: { borderRadius: 8 },
      typography: { fontFamily: "Inter, Arial, sans-serif" }
    });

    function App() {
      const [configured, setConfigured] = useState(null);
      const [username, setUsername] = useState("");
      const [password, setPassword] = useState("");
      const [showPassword, setShowPassword] = useState(false);
      const [activeTab, setActiveTab] = useState(0);
      const [message, setMessage] = useState("");
      const [error, setError] = useState("");
      const [settings, setSettings] = useState(null);
      const [database, setDatabase] = useState(null);
      const [dbTests, setDbTests] = useState({});
      const [dbMessages, setDbMessages] = useState({});
      const [databaseLists, setDatabaseLists] = useState({});
      const [busyDatabase, setBusyDatabase] = useState("");
      const [showDbPassword, setShowDbPassword] = useState(false);
      const [showBackupPassword, setShowBackupPassword] = useState(false);

      async function api(path, options = {}) {
        const token = localStorage.getItem("skylynxServerToken");
        const response = await fetch(path, {
          ...options,
          headers: {
            "Content-Type": "application/json",
            ...(token ? { Authorization: "Bearer " + token } : {}),
            ...(options.headers || {})
          }
        });
        const data = await response.json().catch(() => ({}));
        if (!response.ok) throw new Error(data.error || "Request failed.");
        return data;
      }

      useEffect(() => {
        api("/api/server/auth/status")
          .then((data) => {
            setConfigured(data.configured);
            if (localStorage.getItem("skylynxServerToken")) {
              loadSettings(false);
            }
          })
          .catch((err) => setError(err.message));
      }, []);

      async function submit(mode) {
        setError("");
        setMessage("");
        try {
          const path = mode === "setup" ? "/api/server/auth/setup" : "/api/server/auth/login";
          await api(path, { method: "POST", body: JSON.stringify({ username, password }) });
          const login = await api("/api/server/auth/login", { method: "POST", body: JSON.stringify({ username, password }) });
          localStorage.setItem("skylynxServerToken", login.token);
          setConfigured(true);
          setMessage("Signed in as " + login.username + ".");
          const status = await api("/api/server/settings/status");
          const databaseResult = await api("/api/server/settings/database");
          setSettings(status);
          setDatabase(databaseResult);
          setDatabaseLists({
            primaryCore: databaseResult.primaryCore?.database ? [databaseResult.primaryCore.database] : [],
            primaryPortal: databaseResult.primaryPortal?.database ? [databaseResult.primaryPortal.database] : [],
            backupCore: databaseResult.backupCore?.database ? [databaseResult.backupCore.database] : [],
            backupPortal: databaseResult.backupPortal?.database ? [databaseResult.backupPortal.database] : []
          });
          history.replaceState(null, "", "/server/settings");
        } catch (err) {
          setError(err.message);
        }
      }

      async function loadSettings(showLoadedMessage = true) {
        setError("");
        try {
          const status = await api("/api/server/settings/status");
          const databaseResult = await api("/api/server/settings/database");
          setSettings(status);
          setDatabase(databaseResult);
          setDatabaseLists({
            primaryCore: databaseResult.primaryCore?.database ? [databaseResult.primaryCore.database] : [],
            primaryPortal: databaseResult.primaryPortal?.database ? [databaseResult.primaryPortal.database] : [],
            backupCore: databaseResult.backupCore?.database ? [databaseResult.backupCore.database] : [],
            backupPortal: databaseResult.backupPortal?.database ? [databaseResult.backupPortal.database] : []
          });
          if (showLoadedMessage) setMessage("Settings loaded.");
        } catch (err) {
          localStorage.removeItem("skylynxServerToken");
          setError(err.message);
        }
      }

      const setupMode = configured === false;
      const signedIn = Boolean(settings && database);
      const showLoginForm = !signedIn;

      function fieldValue(sectionKey, field, fallback = "") {
        const input = document.getElementById(sectionKey + "-" + field);
        return input ? input.value : fallback;
      }

      function readDatabaseSection(sectionKey) {
        const section = database[sectionKey] || {};
        return {
          ...section,
          host: fieldValue(sectionKey, "host", section.host || ""),
          port: fieldValue(sectionKey, "port", section.port || ""),
          username: fieldValue(sectionKey, "username", section.username || ""),
          password: fieldValue(sectionKey, "password", section.password || ""),
          database: fieldValue(sectionKey, "database", section.database || "")
        };
      }

      function syncDatabaseSection(sectionKey) {
        const nextSection = readDatabaseSection(sectionKey);
        setDatabase({
          ...database,
          [sectionKey]: nextSection
        });
        return nextSection;
      }

      function databasePayload(sectionKey) {
        const section = readDatabaseSection(sectionKey);
        return {
          target: sectionKey,
          provider: "sqlserver",
          host: section.host || "",
          port: Number(section.port || 1433),
          username: section.username || "",
          database: section.database || "",
          role: section.role || "core",
          ...(section.password ? { password: section.password } : {})
        };
      }

      function setSectionMessage(sectionKey, severity, text) {
        setDbMessages({ ...dbMessages, [sectionKey]: { severity, text } });
      }

      async function testDatabase(sectionKey) {
        setError("");
        setSectionMessage(sectionKey, "info", "Testing database connection...");
        setBusyDatabase(sectionKey + ":test");
        try {
          syncDatabaseSection(sectionKey);
          const result = await api("/api/server/settings/database/test", { method: "POST", body: JSON.stringify(databasePayload(sectionKey)) });
          setDbTests({ ...dbTests, [sectionKey]: result });
          setSectionMessage(sectionKey, result.ok ? "success" : "warning", result.message);
        } catch (err) {
          setSectionMessage(sectionKey, "error", err.message);
        } finally {
          setBusyDatabase("");
        }
      }

      async function listDatabases(sectionKey) {
        setError("");
        setSectionMessage(sectionKey, "info", "Testing SQL Server and loading database list...");
        setBusyDatabase(sectionKey + ":list");
        try {
          const nextSection = syncDatabaseSection(sectionKey);
          const result = await api("/api/server/settings/database/list", { method: "POST", body: JSON.stringify(databasePayload(sectionKey)) });
          const names = result.databases || [];
          const mergedNames = nextSection.database && !names.includes(nextSection.database) ? [nextSection.database, ...names] : names;
          setDatabaseLists({ ...databaseLists, [sectionKey]: mergedNames });
          setSectionMessage(sectionKey, "success", "Server connection tested. Found " + names.length + " database" + (names.length === 1 ? "." : "s."));
        } catch (err) {
          setSectionMessage(sectionKey, "error", err.message);
        } finally {
          setBusyDatabase("");
        }
      }

      async function createDatabase(sectionKey) {
        setError("");
        setSectionMessage(sectionKey, "info", "Creating database...");
        setBusyDatabase(sectionKey + ":create");
        try {
          syncDatabaseSection(sectionKey);
          const result = await api("/api/server/settings/database/create", { method: "POST", body: JSON.stringify(databasePayload(sectionKey)) });
          setDbTests({ ...dbTests, [sectionKey]: result });
          await listDatabases(sectionKey);
          setSectionMessage(sectionKey, "success", "Database created. " + result.message);
        } catch (err) {
          setSectionMessage(sectionKey, "error", err.message);
        } finally {
          setBusyDatabase("");
        }
      }

      async function installDatabase(sectionKey) {
        setError("");
        setSectionMessage(sectionKey, "info", "Installing database schema and seed data...");
        setBusyDatabase(sectionKey + ":install");
        try {
          syncDatabaseSection(sectionKey);
          const result = await api("/api/server/settings/database/install", { method: "POST", body: JSON.stringify(databasePayload(sectionKey)) });
          setDbTests({ ...dbTests, [sectionKey]: result });
          setSectionMessage(
            sectionKey,
            result.installed ? "success" : "warning",
            result.message + " Batches executed: " + result.batchesExecuted + ". Log: " + (result.installLogPath || "not available") + "."
          );
        } catch (err) {
          setSectionMessage(sectionKey, "error", err.message);
        } finally {
          setBusyDatabase("");
        }
      }

      function DatabaseSettings() {
        if (!database) return null;
        const sections = [
          {
            key: "primaryCore",
            title: "Primary Core SQL Server",
            description: "SkyLynx core identity, portals, settings, and system data.",
            testLabel: "Test Core DB",
            installLabel: "Install Core DB",
            showPassword: showDbPassword,
            setShowPassword: setShowDbPassword
          },
          {
            key: "primaryPortal",
            title: "Primary Portal SQL Server",
            description: "Portal content and template database. This can point to a separate template server.",
            testLabel: "Test Portal DB",
            installLabel: "Install Portal DB",
            showPassword: showDbPassword,
            setShowPassword: setShowDbPassword
          },
          {
            key: "backupCore",
            title: "Backup Core SQL Server",
            description: "Backup target for SkyLynx core data.",
            testLabel: "Test Backup Core",
            installLabel: "Install Backup Core",
            showPassword: showBackupPassword,
            setShowPassword: setShowBackupPassword
          },
          {
            key: "backupPortal",
            title: "Backup Portal SQL Server",
            description: "Backup target for portal content and template data.",
            testLabel: "Test Backup Portal",
            installLabel: "Install Backup Portal",
            showPassword: showBackupPassword,
            setShowPassword: setShowBackupPassword
          }
        ];

        function DatabaseSection(config) {
          const section = database[config.key] || {};
          const test = dbTests[config.key];
          const sectionMessage = dbMessages[config.key];
          const dbOptions = databaseLists[config.key] || [];
          const installReady = Boolean(test && test.databaseExists && test.tableCount === 0);
          const createReady = Boolean(section.database && test && !test.databaseExists);
          const busy = busyDatabase.startsWith(config.key + ":");
          return React.createElement(Stack, { spacing: 1.5, key: config.key },
            React.createElement(Stack, { direction: "row", justifyContent: "space-between", alignItems: "center", flexWrap: "wrap", gap: 1 },
              React.createElement(Box, null,
                React.createElement(Typography, { variant: "h6" }, config.title),
                React.createElement(Typography, { variant: "body2", color: "text.secondary" }, config.description)
              ),
              React.createElement(Stack, { direction: "row", spacing: 1, flexWrap: "wrap" },
                React.createElement(Button, { variant: "outlined", onClick: () => listDatabases(config.key), disabled: busy }, busyDatabase === config.key + ":list" ? "Loading..." : "Test Server"),
                React.createElement(Button, { variant: "contained", onClick: () => testDatabase(config.key), disabled: busy }, busyDatabase === config.key + ":test" ? "Testing..." : config.testLabel),
                React.createElement(Button, { variant: "outlined", onClick: () => createDatabase(config.key), disabled: busy || !createReady }, busyDatabase === config.key + ":create" ? "Creating..." : "Create Database"),
                React.createElement(Button, { variant: "contained", color: "success", onClick: () => installDatabase(config.key), disabled: busy || !installReady }, busyDatabase === config.key + ":install" ? "Installing..." : config.installLabel)
              )
            ),
            sectionMessage && React.createElement(Alert, { severity: sectionMessage.severity }, sectionMessage.text),
            test && React.createElement(Alert, { severity: test.ok ? "success" : "warning" },
              React.createElement(Stack, { spacing: 0.5 },
                React.createElement(Typography, { variant: "subtitle2" }, test.ok ? config.title + " is ready." : config.title + " needs attention."),
                React.createElement(Typography, { variant: "body2" }, test.message),
                React.createElement(Typography, { variant: "body2" }, "Server: " + (test.serverName || section.host || "unknown")),
                React.createElement(Typography, { variant: "body2" }, "Database: " + test.database + " | Tables: " + test.tableCount),
                React.createElement(Typography, { variant: "body2" }, "Database exists: " + (test.databaseExists ? "yes" : "no"))
              )
            ),
            React.createElement(Grid, { container: true, spacing: 2 },
              React.createElement(Grid, { item: true, xs: 12, sm: 8 },
                React.createElement(TextField, { id: config.key + "-host", label: "SQL Server Name or IP", defaultValue: section.host || "", fullWidth: true })
              ),
              React.createElement(Grid, { item: true, xs: 12, sm: 4 },
                React.createElement(TextField, { id: config.key + "-port", label: "Port", defaultValue: section.port || "", fullWidth: true })
              ),
              React.createElement(Grid, { item: true, xs: 12, sm: 6 },
                React.createElement(TextField, { id: config.key + "-username", label: "Database Username", defaultValue: section.username || "", fullWidth: true })
              ),
              React.createElement(Grid, { item: true, xs: 12, sm: 6 },
                React.createElement(TextField, {
                  id: config.key + "-password",
                  label: "Database Password",
                  type: config.showPassword ? "text" : "password",
                  defaultValue: section.password || "",
                  placeholder: section.passwordConfigured ? "Configured password will be used if left blank" : "",
                  fullWidth: true
                })
              ),
              React.createElement(Grid, { item: true, xs: 12 },
                React.createElement(TextField, {
                  id: config.key + "-database",
                  label: "Database Name",
                  defaultValue: section.database || "",
                  fullWidth: true,
                  inputProps: { list: config.key + "-database-list" }
                }),
                React.createElement("datalist", { id: config.key + "-database-list" },
                  dbOptions.map((name) => React.createElement("option", { key: name, value: name }))
                ),
                dbOptions.length > 0 && React.createElement(Typography, { variant: "caption", color: "text.secondary" }, dbOptions.length + " database option" + (dbOptions.length === 1 ? "" : "s") + " available.")
              ),
              React.createElement(Grid, { item: true, xs: 12 },
                React.createElement(FormControlLabel, { control: React.createElement(Switch, { checked: config.showPassword, onChange: (e) => config.setShowPassword(e.target.checked) }), label: "Show password placeholder" })
              )
            )
          );
        }

        return React.createElement(Stack, { spacing: 2 },
          React.createElement(Tabs, { value: activeTab, onChange: (_event, value) => setActiveTab(value), sx: { borderBottom: 1, borderColor: "divider" } },
            React.createElement(Tab, { label: "Database" }),
            React.createElement(Tab, { label: "Payment Providers" }),
            React.createElement(Tab, { label: "AI Providers" })
          ),
          activeTab === 0 && React.createElement(Stack, { spacing: 2 },
            React.createElement(Stack, { direction: "row", justifyContent: "space-between", alignItems: "center" },
              React.createElement(Box, null,
                React.createElement(Typography, { variant: "h6" }, "Database"),
                React.createElement(Typography, { variant: "body2", color: "text.secondary" }, "Core and portal databases can be pointed at different SQL Servers.")
              ),
              React.createElement(Chip, { label: database.provider || "sqlserver", color: "primary", variant: "outlined" })
            ),
            React.createElement(Divider),
            ...sections.map((section, index) => React.createElement(React.Fragment, { key: section.key },
              index > 0 && React.createElement(Divider),
              DatabaseSection(section)
            )),
            React.createElement(Stack, { direction: "row", spacing: 1, justifyContent: "flex-end" },
              React.createElement(Button, { variant: "contained", disabled: true }, "Save Later")
            )
          ),
          activeTab === 1 && React.createElement(Stack, { spacing: 2 },
            React.createElement(Box, null,
              React.createElement(Typography, { variant: "h6" }, "Payment Providers"),
              React.createElement(Typography, { variant: "body2", color: "text.secondary" }, "Provider settings will live here after the database settings flow is stable.")
            ),
            React.createElement(Alert, { severity: "info" }, "Placeholder for Authorize.Net, PayPal, provider modes, webhook status, and payment secret configuration.")
          ),
          activeTab === 2 && React.createElement(Stack, { spacing: 2 },
            React.createElement(Box, null,
              React.createElement(Typography, { variant: "h6" }, "AI Providers"),
              React.createElement(Typography, { variant: "body2", color: "text.secondary" }, "AI provider settings will live here after the server settings flow is stable.")
            ),
            React.createElement(Alert, { severity: "info" }, "Placeholder for OpenAI, provider modes, API keys, model defaults, and usage status.")
          )
        );
      }

      return React.createElement(ThemeProvider, { theme },
        React.createElement(CssBaseline),
        React.createElement(Container, { maxWidth: signedIn ? "md" : "sm", sx: { py: 8 } },
          React.createElement(Stack, { spacing: 2.5 },
            React.createElement(Box, null,
              React.createElement(Stack, { direction: "row", spacing: 1, alignItems: "center", sx: { mb: 1 } },
                React.createElement(Typography, { variant: "h4", fontWeight: 700 }, "SkyLynx Server"),
                React.createElement(Chip, { size: "small", label: "Admin", color: "primary" })
              ),
              React.createElement(Typography, { color: "text.secondary" }, signedIn ? "Manage server and api settings." : setupMode ? "Create the local server admin account." : "Sign in to manage server settings.")
            ),
            error && React.createElement(Alert, { severity: "error" }, error),
            message && React.createElement(Alert, { severity: "success" }, message),
            showLoginForm && React.createElement(Card, { variant: "outlined" },
              React.createElement(CardContent, null,
                React.createElement(Stack, { spacing: 2 },
                  React.createElement(Typography, { variant: "h6" }, setupMode ? "First Server Admin" : "Server Login"),
                  React.createElement(TextField, { label: "Username", value: username, onChange: (e) => setUsername(e.target.value), fullWidth: true }),
                  React.createElement(TextField, { label: "Password", type: showPassword ? "text" : "password", value: password, onChange: (e) => setPassword(e.target.value), fullWidth: true }),
                  React.createElement(FormControlLabel, { control: React.createElement(Switch, { checked: showPassword, onChange: (e) => setShowPassword(e.target.checked) }), label: "Show password" }),
                  React.createElement(Button, { variant: "contained", size: "large", onClick: () => submit(setupMode ? "setup" : "login") }, setupMode ? "Create Admin" : "Sign In")
                )
              )
            ),
            React.createElement(Card, { variant: "outlined" },
              React.createElement(CardContent, null,
                signedIn ? React.createElement(DatabaseSettings) : React.createElement(Stack, { spacing: 1.5 },
                  React.createElement(Typography, { variant: "h6" }, "Settings"),
                  React.createElement(Divider),
                  React.createElement(Typography, { variant: "body2", color: "text.secondary" }, "Sign in to view server database settings.")
                )
              )
            )
          )
        )
      );
    }

    ReactDOM.createRoot(document.getElementById("root")).render(React.createElement(App));
  </script>
</body>
</html>`;
