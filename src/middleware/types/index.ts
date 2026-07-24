// ================================================
// ✅ Types: Middleware Types
// Description: Shared Express request interfaces for middleware
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename: middleware/types/index.ts
// ================================================

import { Request } from "express";

export interface AuthenticatedRequest extends Request {
  user?: {
    id: string;
    roles?: string[];
  };
}
