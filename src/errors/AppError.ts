export class AppError extends Error {
  public readonly name: string;
  public readonly isOperational: boolean;

  constructor(
    public readonly message: string,
    public readonly statusCode: number,
    public readonly code: string = "APP_ERROR",
    public readonly details: any = null,
  ) {
    super(message);
    this.name = this.constructor.name;
    this.isOperational = true;
  }
}

export default AppError;
