import { NextResponse, NextRequest } from "next/server";
import { cookies } from "next/headers";

/**
 * @deprecated
 * test route para saber como funcionan. No se usa nunca en la app
 */
export async function POST(req: NextRequest) {
  const apiKey = process.env.API_KEY ?? "";
  const ckService = cookies();
  const reader = req.body?.getReader();
  let body = "";
  let decoder = new TextDecoder();
  while (true) {
    const { done, value } = await reader?.read();
    if (done) break;
    body += decoder.decode(value);
  }
  
  return new Response("Hello from route", {
    status: 200,
    headers: {
      "Set-Cookie": `api_key=${apiKey}; Path=/; HttpOnly; Secure; SameSite=Strict`,
    },
  });
}
