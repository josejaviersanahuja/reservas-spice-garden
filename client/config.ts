export interface ConfigApp {
  apiKey: string;
  apiUrl: string;
}

export const config: ConfigApp = {
  apiKey: process.env.NEXT_PUBLIC_API_KEY || "",
  apiUrl: process.env.NEXT_PUBLIC_API_URL || "",
};
