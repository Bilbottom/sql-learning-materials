```sql
with routes as (
        select
            bus_id,
            from_stop as starting_stop,
            from_stop as current_stop,
            cast(from_stop as varchar(max)) as route
        from bus_stops
        where 0=1
            or (bus_id = 1 and from_stop = 'Old Street')
            or (bus_id = 2 and from_stop = 'Hillside')
            or (bus_id = 3 and from_stop = 'Birch Park')
    union all
        select
            routes.bus_id,
            routes.starting_stop,
            bus_stops.to_stop,
            concat_ws(' - ', routes.route, bus_stops.to_stop)
        from routes
            inner join bus_stops as bus_stops
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
