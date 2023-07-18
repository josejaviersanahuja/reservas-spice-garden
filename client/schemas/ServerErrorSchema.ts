/**
 * @deprecated
 * @description i wanted to customize the error thrown and rendered by the client. No success.
 */
export interface ServerErrorSchema {
  statusCode: number;
  message: string;
  error?: string;
}
