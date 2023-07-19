import { Agenda } from '@/schemas/AgendaSchema';
import {} from 'next/navigation'
interface Props {
  params: {
    fechaI: string | undefined;
    fechaF: string | undefined;
  };
}

async function loadAgendasByQueryParams(props:{
  fechaI: string;
  fechaF: string;
}) {
  console.log(props, 'Debugging props');
  return await fetch(`http://localhost:3001/agenda?fechaI=${props.fechaI}&fechaF=${props.fechaF}`, {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
      apikey: process.env.API_KEY ?? "",
    },
    cache: "no-cache",
  })
}

export default async function Agendas({params}: Props) {
  console.log(params, 'Debugging params');
  
  let fechaI = params.fechaI ?? '';
  let fechaF = params.fechaF ?? '';
  if (!params.fechaI && !params.fechaF) {
    const thisMonth = new Date();
    thisMonth.setDate(1);
    fechaI = thisMonth.toISOString().substring(0, 10);
    thisMonth.setMonth(thisMonth.getMonth() + 1);
    fechaF = thisMonth.toISOString().substring(0, 10);
  }
  
  const response = await loadAgendasByQueryParams({
    fechaI,
    fechaF,
  });
  const res = await response.json();
  if (typeof res === 'object' && "statusCode" in res) {
    throw new Error(res.message + ' - statusCode ' + res.statusCode);
  }
  const agendas: Agenda[] = res;
  // console.log(agendas, 'Debugging agendas');
  
  if (agendas.length === 0) {
    return <section>No hay agendas para mostrar del {fechaI} al {fechaF}</section>;
  }
  return <section>Esto es la page de Agendas del {fechaI} al {fechaF}</section>;
}
