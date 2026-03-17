export class ApiResponse<T> {
  public readonly status: string = "success";

  constructor(
    public readonly data: T,
    public readonly statusCode: number = 200,
    public readonly message: string = "Success",
  ) {}
}