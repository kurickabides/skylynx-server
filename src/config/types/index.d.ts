// ================================================
// ✅ Types: Global Server Types
// Description: Global TypeScript declarations for the server app
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: config/types/index.d.ts
// ================================================
import { Request } from "express";

declare module "express-serve-static-core" {
  interface Request {
    apiKey?: string;
    portalName?: string;
    portalId?: string;
  }
}
