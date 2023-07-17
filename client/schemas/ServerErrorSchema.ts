export interface ServerErrorSchema {
  statusCode: number;
  message: string;
  error?: string;
}