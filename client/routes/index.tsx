import { Head } from "$fresh/runtime.ts";
import ProtectedRoute from "../islands/ProtectedRoute.tsx";

export default function Home() {

  return (
    <>
      <Head>
        <title>Reserv</title>
      </Head>
      <ProtectedRoute />
      <div class="p-4 mx-auto max-w-screen-md">
        <p class="my-6">
          Welcome to `fresh`. Try updating this message in the
          ./routes/index.tsx file, and refresh.
        </p>
      </div>
    </>
  );
}
