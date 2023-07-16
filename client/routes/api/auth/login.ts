import { HandlerContext } from "$fresh/server.ts";

export const handler = {
  async POST(_req: Request, _ctx: HandlerContext): Promise<Response> {
    console.log(Deno.env.get("API_URL"));
    const reader = _req.body?.getReader();
    let result = "";
    while (true) {
      const read = await reader?.read();
      if (read?.done) break;
      result += new TextDecoder().decode(read?.value);
    }

    console.log(JSON.parse(result));
    console.log(_req.headers);

    const body = JSON.stringify({ message: "Hello from Deno!" });
    return new Response(body);
  },
};
