// my global types file for entire server app.
import { Request } from "express";

declare module "express-serve-static-core" {
  interface Request {
    apiKey?: string;
    portalName?: string;
    portalId?: string;
  }
}
