```sql
with recursive routes as (
        select
            bus_id,
            from_stop as starting_stop,
            from_stop as current_stop,
            from_stop as route
        from bus_stops
        where (bus_id, from_stop) in (
            (1, 'Old Street'),
            (2, 'Hillside'),
            (3, 'Birch Park')
        )
    union all
        select
            routes.bus_id,
            routes.starting_stop,
            bus_stops.to_stop,
            routes.route || ' - ' || bus_stops.to_stop
        from routes
            inner join bus_stops
                on  routes.bus_id = bus_stops.bus_id
                and routes.current_stop = bus_stops.from_stop
                and routes.starting_stop != bus_stops.to_stop
)

select
    bus_id,
    max(route) as route
from routes
group by bus_id
order by bus_id
```
