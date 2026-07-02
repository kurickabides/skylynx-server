import express from "express";

// For HMAC signature verification
export const authorizeNetRaw = express.raw({ type: "*/*" });
