```sql
/*
    In DuckDB, we can convert a timestamp with a timezone to a timestamp
    in UTC by casting it to a varchar and then to a timestamp.
*/
with recursive

date_axis as (
        select
            /* give us a day either side to be safe */
            min(departure_datetime::date) - 1 as date_,
            max(arrival_datetime::date) + 1 as max_date,
        from routes_timetable
    union all
        select
            date_ + interval '1 day',
            max_date,
        from date_axis
        where date_ < max_date - 1  /* account for final loop */
),

scheduled_timetable as (
        select
            schedule_id,
            from_location,
            to_location,
            cost,
            duration::varchar::interval as duration,
            earliest_departure::varchar::time as departure_time_utc,
            departure_time_utc + duration::varchar::interval as arrival_time_utc,
            latest_departure::varchar::time as limit_,
            frequency::varchar::interval as frequency,
        from routes_schedule
    union all
        select
            schedule_id,
            from_location,
            to_location,
            cost,
            duration,
            departure_time_utc + frequency as departure_time_utc,
            arrival_time_utc + frequency as arrival_time_utc,
            limit_,
            frequency,
        from scheduled_timetable
        where departure_time_utc <= limit_ - frequency  /* account for the final loop */
          and frequency is not null  /* daily schedules don't need to be expanded */
),

timetable as (
        select
            from_location,
            to_location,
            departure_datetime::varchar::timestamp as departure_datetime_utc,
            arrival_datetime::varchar::timestamp as arrival_datetime_utc,
            arrival_datetime_utc - departure_datetime_utc as duration,
            cost,
        from routes_timetable
    union all
        select
            scheduled_timetable.from_location,
            scheduled_timetable.to_location,
            scheduled_timetable.departure_time_utc + date_axis.date_,
            scheduled_timetable.arrival_time_utc + date_axis.date_,
            scheduled_timetable.duration,
            scheduled_timetable.cost,
        from scheduled_timetable
            cross join date_axis
),

routes as (
        select
            from_location as starting_location,
            departure_datetime_utc as starting_departure_datetime_utc,

            from_location,
            to_location,
            departure_datetime_utc,
            arrival_datetime_utc,
            cost,
            from_location || ' - ' || to_location as route,
        from timetable
        where 1=1
            and from_location = 'New York'
            and departure_datetime_utc >= '2024-01-01 12:00:00-05:00'
    union all
        select
            routes.starting_location,
            routes.starting_departure_datetime_utc,

            timetable.from_location,
            timetable.to_location,
            timetable.departure_datetime_utc,
            timetable.arrival_datetime_utc,
            routes.cost + timetable.cost,
            routes.route || ' - ' || timetable.to_location,
        from routes
            inner join timetable
                on  routes.to_location = timetable.from_location
                and timetable.departure_datetime_utc between routes.arrival_datetime_utc + interval '30 minutes'
                                                         and routes.arrival_datetime_utc + interval '6 hours'
)

select distinct
    route,
    starting_departure_datetime_utc as departure_datetime_utc,
    arrival_datetime_utc,
    arrival_datetime_utc - starting_departure_datetime_utc as duration,
    cost
from routes
where to_location = 'Paris'
qualify 0=1
    /* fastest route */
    or 1 = row_number() over (order by duration, cost, route)
    /* cheapest route */
    or 1 = row_number() over (order by cost, duration, route)
order by arrival_datetime_utc
```
