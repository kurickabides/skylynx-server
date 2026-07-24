// ================================================
// ✅ Page: serverHomePage
// Description: Public SkyLynx server status landing page
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: admin/serverHomePage.ts
// ================================================

export const serverHomePage = `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>SkyLynx Server</title>
  <style>
    :root {
      color-scheme: light dark;
      --bg: #f4f6f8;
      --panel: #ffffff;
      --text: #172033;
      --muted: #5c6678;
      --line: #d8dee8;
      --accent: #2e6f8f;
      --ok: #2f7d4f;
    }

    @media (prefers-color-scheme: dark) {
      :root {
        --bg: #151a21;
        --panel: #1d242d;
        --text: #edf2f7;
        --muted: #a8b3c4;
        --line: #303946;
        --accent: #77b6d1;
        --ok: #75c28d;
      }
    }

    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      min-height: 100vh;
      display: grid;
      place-items: center;
      padding: 24px;
      background: var(--bg);
      color: var(--text);
      font-family: Arial, Helvetica, sans-serif;
      line-height: 1.5;
    }

    main {
      width: min(100%, 560px);
      padding: 28px;
      border: 1px solid var(--line);
      border-radius: 8px;
      background: var(--panel);
    }

    .status {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      margin-bottom: 18px;
      color: var(--ok);
      font-size: 14px;
      font-weight: 700;
      letter-spacing: 0.02em;
      text-transform: uppercase;
    }

    .status::before {
      width: 9px;
      height: 9px;
      border-radius: 999px;
      background: currentColor;
      content: "";
    }

    h1 {
      margin: 0 0 10px;
      font-size: 30px;
      font-weight: 700;
      letter-spacing: 0;
    }

    p {
      margin: 0 0 14px;
      color: var(--muted);
      font-size: 16px;
    }

    .notice {
      margin-top: 22px;
      padding-top: 18px;
      border-top: 1px solid var(--line);
      color: var(--text);
      font-size: 14px;
    }

    a {
      color: var(--accent);
      text-decoration: none;
    }

    a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
  <main aria-labelledby="page-title">
    <div class="status">Server online</div>
    <h1 id="page-title">SkyLynx Server</h1>
    <p>SkyLynx is a website server for hosting and supporting SkyLynx-powered portals, APIs, forms, and site services.</p>
    <p class="notice">If you are not the server administrator, there is nothing to do here. Please move along.</p>
  </main>
</body>
</html>`;
