```sql
create table routes_schedule (
    schedule_id        int primary key,
    mode_of_transport  varchar not null,
    from_location      varchar not null,
    to_location        varchar not null,
    earliest_departure timetz not null,
    latest_departure   timetz not null,
    frequency          time,  /* `null` means that it's daily */
    duration           time not null,
    cost               decimal(8, 2) not null,
);
insert into routes_schedule
values
    (1, 'train', 'London St Pancras', 'London Gatwick',    '08:00:00+00:00', '20:00:00+00:00', '01:00:00', '00:30:00', 17.50),
    (2, 'train', 'London St Pancras', 'London Gatwick',    '07:30:00+00:00', '22:30:00+00:00', '02:30:00', '01:15:00', 12.00),
    (3, 'bus',   'London St Pancras', 'London Gatwick',    '06:15:00+00:00', '06:15:00+00:00', null,       '03:30:00',  6.75),
    (4, 'bus',   'London St Pancras', 'London Gatwick',    '19:30:00+00:00', '19:30:00+00:00', null,       '03:30:00',  6.75),
    (5, 'train', 'London Gatwick',    'London St Pancras', '09:00:00+00:00', '21:00:00+00:00', '01:00:00', '00:30:00', 17.50),
    (6, 'train', 'London Gatwick',    'London St Pancras', '07:15:00+00:00', '22:15:00+00:00', '02:30:00', '01:15:00', 12.00),
    (7, 'bus',   'London Gatwick',    'London St Pancras', '06:00:00+00:00', '06:00:00+00:00', null,       '03:30:00',  6.75),
    (8, 'bus',   'London Gatwick',    'London St Pancras', '20:00:00+00:00', '20:00:00+00:00', null,       '03:30:00',  6.75)
;

create table routes_timetable (
    route_id           int primary key,
    mode_of_transport  varchar not null,
    from_location      varchar not null,
    to_location        varchar not null,
    departure_datetime timestamptz not null,
    arrival_datetime   timestamptz not null,
    cost               decimal(8, 2) not null,
);
insert into routes_timetable
values
    (1,  'boat',  'London St Pancras', 'Paris',          '2024-01-01 06:00:00+00:00', '2024-01-01 07:30:00+01:00',  45.00),
    (2,  'plane', 'London Gatwick',    'New York',       '2024-01-01 13:05:00+00:00', '2024-01-01 20:55:00-05:00', 158.00),
    (3,  'plane', 'London Gatwick',    'New York',       '2024-01-02 20:40:00+00:00', '2024-01-03 04:30:00-05:00', 147.00),
    (4,  'plane', 'London St Pancras', 'Paris',          '2024-01-03 07:00:00+00:00', '2024-01-03 08:30:00+01:00',  70.00),
    (5,  'plane', 'Paris',             'New York',       '2024-01-02 12:00:00+01:00', '2024-01-02 20:30:00-05:00', 180.00),
    (6,  'plane', 'New York',          'London Gatwick', '2024-01-01 13:00:00-05:00', '2024-01-02 05:45:00+00:00', 160.00),
    (7,  'boat',  'New York',          'London Gatwick', '2024-01-01 05:30:00-05:00', '2024-01-01 23:00:00+00:00', 195.00),
    (8,  'boat',  'London St Pancras', 'Paris',          '2024-01-01 18:00:00+00:00', '2024-01-01 19:30:00+01:00',  95.00),
    (9,  'boat',  'London St Pancras', 'Paris',          '2024-01-02 14:00:00+00:00', '2024-01-02 15:30:00+01:00',  40.00),
    (10, 'plane', 'New York',          'Paris',          '2024-01-01 18:00:00-05:00', '2024-01-02 17:45:00+01:00', 279.00)
;
```
