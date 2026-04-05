import { AppError } from "./AppError";

export class BadRequestError extends AppError {
  constructor(message: string = "Bad request", details: any = null) {
    super(message, 400, "BAD_REQUEST", details);
  }
}

export class UnauthorizedError extends AppError {
  constructor(message: string = "Unauthorized", details: any = null) {
    super(message, 401, "UNAUTHORIZED", details);
  }
}

export class ForbiddenError extends AppError {
  constructor(message: string = "Forbidden", details: any = null) {
    super(message, 403, "FORBIDDEN", details);
  }
}

export class NotFoundError extends AppError {
  constructor(message: string = "Not found", details: any = null) {
    super(message, 404, "NOT_FOUND", details);
  }
}

export class ConflictError extends AppError {
  constructor(message: string = "Conflict", details: any = null) {
    super(message, 409, "CONFLICT", details);
  }
}

export class InternalError extends AppError {
  constructor(message: string = "Internal server error", details: any = null) {
    super(message, 500, "INTERNAL_ERROR", details);
  }
}

// Chỉnh sửa lại tên class cho đúng chuẩn camelCase và mã lỗi 503
export class ServiceUnavailableError extends AppError {
  constructor(message: string = "Service Unavailable", details: any = null) {
    super(message, 503, "SERVICE_UNAVAILABLE", details);
  }
}
