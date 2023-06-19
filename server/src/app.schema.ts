export interface PostgresCrudService<T> {
  isError: boolean;
  message: string;
  errorCode?: string;
  stack?: string;
  rowsAffected?: number;
  result?: T;
}

export enum MEAL_PLAN {
  SC = 'SC',
  BB = 'BB',
  HB = 'HB',
  FB = 'FB',
  AI = 'AI',
}

export enum TIME_OPTIONS {
  t1900 = '19:00',
  t1915 = '19:15',
  t1930 = '19:30',
  t1945 = '19:45',
  t2000 = '20:00',
  t2015 = '20:15',
  t2030 = '20:30',
  t2045 = '20:45',
  t2100 = '21:00',
  t2115 = '21:15',
  t2130 = '21:30',
  t2145 = '21:45',
}

export type ROOM_OPTIONS =
  | 'P01'
  | 'P02'
  | 'P03'
  | 'P04'
  | 'P05'
  | 'P06'
  | 'P07'
  | 'P08'
  | 'P09'
  | 'P10'
  | 'P11'
  | 'P12'
  | 'P13'
  | 'P14'
  | 'P15'
  | 'P16'
  | 'P17'
  | 'P18'
  | 'P19'
  | 'P20'
  | 'P21'
  | 'P22'
  | '001'
  | '002'
  | '003'
  | '004'
  | '005'
  | '006'
  | '007'
  | '008'
  | '009'
  | '010'
  | '011'
  | '012'
  | '013'
  | '014'
  | '015'
  | '016'
  | '017'
  | '018'
  | '019'
  | '020'
  | '021'
  | '022'
  | '023'
  | '024'
  | '025'
  | '026'
  | '027'
  | '028'
  | '029'
  | '030'
  | '031'
  | '032'
  | '033'
  | '034'
  | '035'
  | '036'
  | '037'
  | '038'
  | '039'
  | '040'
  | '041'
  | '042'
  | '043'
  | '044'
  | '045'
  | '046'
  | '047'
  | '048'
  | '049'
  | '050'
  | '101'
  | '102'
  | '103'
  | '104'
  | '105'
  | '106'
  | '107'
  | '108'
  | '109'
  | '110'
  | '111'
  | '112'
  | '113'
  | '114'
  | '115'
  | '116'
  | '117'
  | '118'
  | '119'
  | '120'
  | '121'
  | '122'
  | '123'
  | '124'
  | '125'
  | '126'
  | '127'
  | '128'
  | '129'
  | '130'
  | '131'
  | '132'
  | '133'
  | '134'
  | '135'
  | '136'
  | '137'
  | '138'
  | '139'
  | '140'
  | '141'
  | '142'
  | '143'
  | '201'
  | '202'
  | '203'
  | '204'
  | '205'
  | '206'
  | '207'
  | '208'
  | '209'
  | '210'
  | '211'
  | '212'
  | '213'
  | '214'
  | '215'
  | '216'
  | '217'
  | '218'
  | '219'
  | '220'
  | '221'
  | '222'
  | '223'
  | '224'
  | '225'
  | '226'
  | '227'
  | '228'
  | '229'
  | '230'
  | '231'
  | '232'
  | '233'
  | '234'
  | '235'
  | '236'
  | '237'
  | '238'
  | '239'
  | '240'
  | '241'
  | '242'
  | '301'
  | '302'
  | '303'
  | '304'
  | '305'
  | '306'
  | '307'
  | '308'
  | '309'
  | '310'
  | '311'
  | '312'
  | '313'
  | '314'
  | '315'
  | '316'
  | 'S/N';
