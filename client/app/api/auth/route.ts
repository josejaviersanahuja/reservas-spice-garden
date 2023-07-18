import { NextResponse, NextRequest } from 'next/server'
import { cookies } from 'next/headers'
 
export async function POST(req: NextRequest) {
  const apiKey = process.env.API_KEY ?? ""
  console.log(apiKey, 'route.ts apiKey');
  const ckService = cookies()
  console.log(req.cookies.getAll(), 'route.ts cookies?');
  console.log(ckService.getAll(), 'route.ts cookies?');
  const reader = req.body?.getReader()
  let body = ""
  let decoder = new TextDecoder();
  while (true) {
    const { done, value } = await reader?.read()
    if (done) break
    // console.log(value, 'route.ts value?');
    body += decoder.decode(value)
  }
  console.log(body, 'route.ts body?');
  
  return new Response('Hello from route', {
    status: 200,
    headers: {
      'Set-Cookie': `api_key=${apiKey}; Path=/; HttpOnly; Secure; SameSite=Strict`,
    }
  })
}