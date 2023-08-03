import Link from "next/link";

interface Props {
  children: React.ReactNode;
}

export default function NuevaAgendaLayout({ children }: Props) {
  return (
    <section>
      <div className="flex items-start justify-between p-4 lg:p-0 md:p-4 sm:p-8">
        <Link href={"/agendas/nueva/normal"}>Normal</Link>
        <Link href={"/agendas/nueva/verano"}>Verano</Link>
        <Link href={"/agendas/nueva/custom"}>Custom</Link>
      </div>
      {children}
    </section>
  );
}
