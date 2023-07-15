import { Head } from "$fresh/runtime.ts";
import Header from "../components/Header.tsx";
import ProtectedRoute from "../islands/ProtectedRoute.tsx";

export default function Home() {

  return (
    <>
      <Head>
        <title>Reserv</title>
      </Head>
      <ProtectedRoute />
      <Header />
      <div class="pt-24 px-4 mx-auto max-w-screen-md">
        <p class="my-6">
          Welcome to `fresh`. Try updating this message in the
          ./routes/index.tsx file, and refresh.
        </p>
      </div>
    </>
  );
}
