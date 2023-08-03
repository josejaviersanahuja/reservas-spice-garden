import { redirect } from "next/navigation";

const redirecting = async () => {
  redirect("/agendas/nueva/normal");
  return await fetch("", { cache: "no-cache" });
};

export default function NuevaAgenda() {
  return null;
}
