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
      const [dbTest, setDbTest] = useState(null);
      const [backupDbTest, setBackupDbTest] = useState(null);
      const [testingDb, setTestingDb] = useState(false);
      const [testingBackupDb, setTestingBackupDb] = useState(false);
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
          if (showLoadedMessage) setMessage("Settings loaded.");
        } catch (err) {
          localStorage.removeItem("skylynxServerToken");
          setError(err.message);
        }
      }

      const setupMode = configured === false;
      const signedIn = Boolean(settings && database);
      const showLoginForm = !signedIn;

      function updateDatabase(field, value) {
        setDatabase({ ...database, [field]: value });
      }

      async function testPrimaryDb() {
        setError("");
        setMessage("");
        setTestingDb(true);
        try {
          const result = await api("/api/server/settings/database/test-primary", { method: "POST" });
          setDbTest(result);
          setMessage(result.message);
        } catch (err) {
          setError(err.message);
        } finally {
          setTestingDb(false);
        }
      }

      async function testBackupDb() {
        setError("");
        setMessage("");
        setTestingBackupDb(true);
        try {
          const result = await api("/api/server/settings/database/test-backup", { method: "POST" });
          setBackupDbTest(result);
          setMessage(result.message);
        } catch (err) {
          setError(err.message);
        } finally {
          setTestingBackupDb(false);
        }
      }

      function DatabaseSettings() {
        if (!database) return null;
        return React.createElement(Stack, { spacing: 2 },
          React.createElement(Tabs, { value: activeTab, onChange: (_event, value) => setActiveTab(value), sx: { borderBottom: 1, borderColor: "divider" } },
            React.createElement(Tab, { label: "Database" }),
            React.createElement(Tab, { label: "Payment Providers" })
          ),
          activeTab === 0 && React.createElement(Stack, { spacing: 2 },
            React.createElement(Stack, { direction: "row", justifyContent: "space-between", alignItems: "center" },
              React.createElement(Box, null,
                React.createElement(Typography, { variant: "h6" }, "Database"),
                React.createElement(Typography, { variant: "body2", color: "text.secondary" }, "Database provider is locked to SQL Server for this build.")
              ),
              React.createElement(Chip, { label: database.provider || "sqlserver", color: "primary", variant: "outlined" })
            ),
            React.createElement(Divider),
            React.createElement(Stack, { spacing: 1 },
              React.createElement(Stack, { direction: "row", justifyContent: "space-between", alignItems: "center", flexWrap: "wrap", gap: 1 },
                React.createElement(Typography, { variant: "h6" }, "Primary SQL Server"),
                React.createElement(Stack, { direction: "row", spacing: 1, flexWrap: "wrap" },
                  React.createElement(Button, { variant: "contained", onClick: testPrimaryDb, disabled: testingDb }, testingDb ? "Testing..." : "Test Primary DB"),
                  React.createElement(Button, { variant: "outlined", onClick: () => loadSettings() }, "Refresh")
                )
              )
            ),
            dbTest && React.createElement(Alert, { severity: dbTest.ok ? "success" : "warning" },
              React.createElement(Stack, { spacing: 0.5 },
                React.createElement(Typography, { variant: "subtitle2" }, dbTest.ok ? "Primary database is ready." : "Primary database needs attention."),
                React.createElement(Typography, { variant: "body2" }, dbTest.message),
                React.createElement(Typography, { variant: "body2" }, "Server: " + (dbTest.serverName || database.host || "unknown")),
                React.createElement(Typography, { variant: "body2" }, "Database: " + dbTest.database + " | Tables: " + dbTest.tableCount),
                React.createElement(Typography, { variant: "body2" }, "Database exists: " + (dbTest.databaseExists ? "yes" : "no"))
              )
            ),
            React.createElement(Grid, { container: true, spacing: 2 },
              React.createElement(Grid, { item: true, xs: 12, sm: 8 },
                React.createElement(TextField, { label: "SQL Server Name or IP", value: database.host || "", onChange: (e) => updateDatabase("host", e.target.value), fullWidth: true })
              ),
              React.createElement(Grid, { item: true, xs: 12, sm: 4 },
                React.createElement(TextField, { label: "Port", value: database.port || "", onChange: (e) => updateDatabase("port", e.target.value), fullWidth: true })
              ),
              React.createElement(Grid, { item: true, xs: 12, sm: 6 },
                React.createElement(TextField, { label: "Core Database", value: database.coreDatabase || "", onChange: (e) => updateDatabase("coreDatabase", e.target.value), fullWidth: true })
              ),
              React.createElement(Grid, { item: true, xs: 12, sm: 6 },
                React.createElement(TextField, { label: "Portal Database", value: database.portalDatabase || "", onChange: (e) => updateDatabase("portalDatabase", e.target.value), fullWidth: true })
              ),
              React.createElement(Grid, { item: true, xs: 12, sm: 6 },
                React.createElement(TextField, { label: "Database Username", value: database.username || "", onChange: (e) => updateDatabase("username", e.target.value), fullWidth: true })
              ),
              React.createElement(Grid, { item: true, xs: 12, sm: 6 },
                React.createElement(TextField, { label: "Database Password", type: showDbPassword ? "text" : "password", value: database.passwordConfigured ? "configured-password-hidden" : "", fullWidth: true, InputProps: { readOnly: true } })
              ),
              React.createElement(Grid, { item: true, xs: 12 },
                React.createElement(FormControlLabel, { control: React.createElement(Switch, { checked: showDbPassword, onChange: (e) => setShowDbPassword(e.target.checked) }), label: "Show password placeholder" })
              )
            ),
            React.createElement(Divider),
            React.createElement(Stack, { spacing: 1 },
              React.createElement(Stack, { direction: "row", justifyContent: "space-between", alignItems: "center", flexWrap: "wrap", gap: 1 },
                React.createElement(Box, null,
                  React.createElement(Typography, { variant: "h6" }, "Backup SQL Server"),
                  React.createElement(Typography, { variant: "body2", color: "text.secondary" }, "Reserved for manual rollover if the primary SQL Server goes down.")
                ),
                React.createElement(Stack, { direction: "row", spacing: 1, flexWrap: "wrap" },
                  React.createElement(Button, { variant: "outlined", onClick: testBackupDb, disabled: testingBackupDb }, testingBackupDb ? "Testing..." : "Test Backup DB"),
                  React.createElement(Button, { variant: "outlined", disabled: true }, "Sync Backup"),
                  React.createElement(Button, { variant: "contained", color: "warning", disabled: true }, "Fail Over")
                )
              )
            ),
            backupDbTest && React.createElement(Alert, { severity: backupDbTest.ok ? "success" : "warning" },
              React.createElement(Stack, { spacing: 0.5 },
                React.createElement(Typography, { variant: "subtitle2" }, backupDbTest.ok ? "Backup database is ready." : "Backup database needs attention."),
                React.createElement(Typography, { variant: "body2" }, backupDbTest.message),
                React.createElement(Typography, { variant: "body2" }, "Server: " + (backupDbTest.serverName || database.backupHost || "unknown")),
                React.createElement(Typography, { variant: "body2" }, "Database: " + backupDbTest.database + " | Tables: " + backupDbTest.tableCount),
                React.createElement(Typography, { variant: "body2" }, "Database exists: " + (backupDbTest.databaseExists ? "yes" : "no"))
              )
            ),
            React.createElement(Grid, { container: true, spacing: 2 },
              React.createElement(Grid, { item: true, xs: 12, sm: 8 },
                React.createElement(TextField, { label: "Backup SQL Server Name or IP", value: database.backupHost || "", onChange: (e) => updateDatabase("backupHost", e.target.value), fullWidth: true })
              ),
              React.createElement(Grid, { item: true, xs: 12, sm: 4 },
                React.createElement(TextField, { label: "Backup Port", value: database.backupPort || "", onChange: (e) => updateDatabase("backupPort", e.target.value), fullWidth: true })
              ),
              React.createElement(Grid, { item: true, xs: 12, sm: 6 },
                React.createElement(TextField, { label: "Backup Core Database", value: database.backupCoreDatabase || "", onChange: (e) => updateDatabase("backupCoreDatabase", e.target.value), fullWidth: true })
              ),
              React.createElement(Grid, { item: true, xs: 12, sm: 6 },
                React.createElement(TextField, { label: "Backup Username", value: database.backupUsername || "", onChange: (e) => updateDatabase("backupUsername", e.target.value), fullWidth: true })
              ),
              React.createElement(Grid, { item: true, xs: 12, sm: 6 },
                React.createElement(TextField, { label: "Backup Password", type: showBackupPassword ? "text" : "password", value: database.backupPasswordConfigured ? "configured-password-hidden" : "", fullWidth: true, InputProps: { readOnly: true } })
              ),
              React.createElement(Grid, { item: true, xs: 12 },
                React.createElement(FormControlLabel, { control: React.createElement(Switch, { checked: showBackupPassword, onChange: (e) => setShowBackupPassword(e.target.checked) }), label: "Show backup password placeholder" })
              )
            ),
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
              React.createElement(Typography, { color: "text.secondary" }, signedIn ? "Manage server database settings." : setupMode ? "Create the local server admin account." : "Sign in to manage server settings.")
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
