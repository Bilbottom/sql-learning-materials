```sql
with

routes_schedule(
    schedule_id,
    mode_of_transport,
    from_location,
    to_location,
    earliest_departure,
    latest_departure,
    frequency,
    duration,
    cost
) as (
    values
        (1, 'train', 'London Gatwick', 'London St Pancras', '09:00:00+00:00'::timetz, '21:00:00+00:00'::timetz, '01:00:00'::time, '00:30:00'::time, 12.25),
        (2, 'bus',   'London Gatwick', 'London St Pancras', '06:00:00+00:00'::timetz, '06:00:00+00:00'::timetz, null::time,       '03:30:00'::time,  8.50)
),

routes_timetable(
    route_id,
    mode_of_transport,
    from_location,
    to_location,
    departure_datetime,
    arrival_datetime,
    cost
) as (
    values
        (1, 'boat',  'New York',          'London Gatwick', '2024-01-01 04:30:00-05:00'::timestamptz, '2024-01-01 22:00:00+00:00'::timestamptz, 179.00),
        (2, 'plane', 'New York',          'London Gatwick', '2024-01-01 18:00:00-05:00'::timestamptz, '2024-01-02 10:45:00+00:00'::timestamptz, 125.00),
        (3, 'boat',  'London St Pancras', 'Paris',          '2024-01-02 13:00:00+00:00'::timestamptz, '2024-01-02 14:30:00+01:00'::timestamptz,  75.00)
)
```
