
DROP TABLE IF EXISTS reservations;
DROP TYPE IF EXISTS MEAL_PLAN_ENUM;
DROP TYPE IF EXISTS TIME_OPTIONS_ENUM;
DROP TYPE IF EXISTS ROOM_OPTIONS_ENUM;

CREATE TYPE MEAL_PLAN_ENUM AS ENUM ('SC', 'BB', 'HB', 'FB', 'AI');

CREATE TYPE TIME_OPTIONS_ENUM AS ENUM ('19:00', '19:15', '19:30', '19:45', '20:00', '20:15', '20:30', '20:45', '21:00', '21:15', '21:30', '21:45', '22:00');

CREATE TYPE ROOM_OPTIONS_ENUM AS ENUM (
  'P01', 'P02', 'P03', 'P04', 'P05', 'P06', 'P07', 'P08', 'P09', 'P10', 'P11', 'P12', 'P13', 'P14', 'P15', 'P16', 'P17', 'P18', 'P19', 'P20', 'P21', 'P22',
  '001', '002', '003', '004', '005', '006', '007', '008', '009', '010', '011', '012', '013', '014', '015', '016', '017', '018', '019', '020', '021', '022',
  '023', '024', '025', '026', '027', '028', '029', '030', '031', '032', '033', '034', '035', '036', '037', '038', '039', '040', '041', '042', '043', '044',
  '045', '046', '047', '048', '049', '050',
  '101', '102', '103', '104', '105', '106', '107', '108', '109', '110', '111', '112', '113', '114', '115', '116', '117', '118', '119', '120', '121', '122',
  '123', '124', '125', '126', '127', '128', '129', '130', '131', '132', '133', '134', '135', '136', '137', '138', '139', '140', '141', '142', '143',
  '201', '202', '203', '204', '205', '206', '207', '208', '209', '210', '211', '212', '213', '214', '215', '216', '217', '218', '219', '220', '221', '222',
  '223', '224', '225', '226', '227', '228', '229', '230', '231', '232', '233', '234', '235', '236', '237', '238', '239', '240', '241', '242',
  '301', '302', '303', '304', '305', '306', '307', '308', '309', '310', '311', '312', '313', '314', '315', '316',
  'S/N'
);

CREATE TABLE reservations (
  id SERIAL PRIMARY KEY,
  fecha DATE NOT NULL DEFAULT CURRENT_DATE,
  hora TIME_OPTIONS_ENUM NOT NULL,
  res_number INTEGER NOT NULL DEFAULT 0, -- reservation number, if there isn't one, use 0
  res_name VARCHAR(100),
  room ROOM_OPTIONS_ENUM, -- if res number is 0, room must be S/N
  is_bonus BOOLEAN DEFAULT FALSE, -- if true, means cost is 0 and bonus_qty is > 0 Meal plan is AI
  bonus_qty INTEGER DEFAULT 0,
  meal_plan MEAL_PLAN_ENUM, -- if is_bonus is true, meal_plan must be AI
  pax_number INTEGER,
  cost NUMERIC(10,2), -- if is_bonus is true, cost must be 0
  observations TEXT,
  is_noshow BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  is_deleted BOOLEAN DEFAULT FALSE
);
