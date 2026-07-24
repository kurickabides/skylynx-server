# SkyLynx Server Admin Runtime Files

This folder is mounted into the Docker container at `/app/admin`.

Runtime files in this folder are local server configuration, not application
source code. The installer/server admin flow creates `server-admin.json` here
after the first server owner is set up.

Do not commit generated admin files or secrets.
