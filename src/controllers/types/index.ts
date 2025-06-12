import { Request } from "express";

export interface ProfileField {
  FieldID: string;
  FieldValue: string;
  FieldName?: string; // Optional for server logic, mostly used client-side
}

//use this in file to use types
// import { ProfileField } from "./types";