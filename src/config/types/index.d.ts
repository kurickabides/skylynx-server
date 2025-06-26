// my global types file for entire server app.
import { Request } from "express";

declare module "express-serve-static-core" {
  interface Request {
    portalName?: string;
    portalId?: string;
  }
}
