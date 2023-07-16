import { Handlers } from "$fresh/server.ts";
import { Head } from "$fresh/runtime.ts";
import Layout from "../components/Layout.tsx";
import ProtectedRoute from "../islands/ProtectedRoute.tsx";

export const handler: Handlers = {
  GET(req, ctx) {
    console.log("SSR DEBUGGING HOME"); //, req.headers, ctx);

    return ctx.render();
  },
};

export default function Home() {
  return (
    <>
      <Head>
        <link href="index.css" rel="stylesheet" />
        <title>Reservas Spice Garden</title>
      </Head>
      <ProtectedRoute />
      <Layout user={null}>
        <div class="pt-24 px-4 mx-auto max-w-screen-md">
          <p class="my-6">
            Welcome to `fresh`. Try updating this message in the
            ./routes/index.tsx file, and refresh.
          </p>
        </div>
      </Layout>
    </>
  );
}
