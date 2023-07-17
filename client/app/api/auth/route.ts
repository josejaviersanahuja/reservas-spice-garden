import { NextResponse, NextRequest } from 'next/server'
 
export async function POST(req: NextRequest) {
  const apiKey = process.env.API_KEY ?? ""
  console.log(apiKey, 'route.ts apiKey');
  
  console.log(req.cookies.getAll(), 'route.ts headers?');
  
  return NextResponse.json({ message: "Hello from api route" })
}