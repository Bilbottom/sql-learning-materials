```sql
with temperatures as (
    select
        site_id,
        reading_datetime,
        temperature,
        sum(temperature) over (
            partition by site_id
            order by reading_datetime rows between 2 preceding and 2 following
        ) as sum_temps
    from readings
    qualify 5 = count(*) over (
        partition by site_id
        order by reading_datetime rows between 2 preceding and 2 following
    )
)

select
    * exclude (sum_temps),
    round((sum_temps - temperature) / 4, 4) as average_temperature,
    round(100 * (temperature - average_temperature) / temperature, 4) as percentage_increase
from temperatures
where percentage_increase > 10
order by
    site_id,
    reading_datetime
```
