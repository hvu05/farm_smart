import type { Request, Response, NextFunction } from "express";
import { env } from "../config/env";
import { AppError } from "../errors/AppError";


export const errorHandler = (err: AppError, _req: Request, res: Response, _next: NextFunction): void => {
  let statusCode = err.statusCode || 500;
  let message = err.message || "Internal Server Error";
  let code = err.code || "INTERNAL_ERROR";
  let details = err.details || null;

  const isOperational = err instanceof AppError;

  const payload: any = {
    statusCode: statusCode,
    status: "error",
    code: isOperational ? code : "INTERNAL_ERROR",
    message: isOperational ? message : "Something went wrong on our end",
    ...(details && { details }), 
  };

  // Log lỗi hệ thống ra console để theo dõi
  if (!isOperational) {
    console.error(">>> SYSTEM ERROR:", err);
  }

  res.status(statusCode).json(payload);
};