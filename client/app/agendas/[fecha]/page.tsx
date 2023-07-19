interface Props {
  params: {
    fecha: string;
  };
}

export default function Agenda({ params }: Props) {
  return <section>Esta es la agenda con fecha {params.fecha}</section>;
}
