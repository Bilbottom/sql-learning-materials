```sql
with temperatures as (
    select
        site_id,
        reading_datetime,
        temperature,
        (sum(temperature) over rows_around_site_reading - temperature) / 4 as average_temperature,
        count(*) over rows_around_site_reading as count_of_rows
    from readings
    window rows_around_site_reading as (
        partition by site_id
        order by reading_datetime rows between 2 preceding and 2 following
    )
)

select
    site_id,
    reading_datetime,
    temperature,
    round(average_temperature, 4) as average_temperature,
    round(100.0 * (temperature - average_temperature) / temperature, 4) as percentage_increase
from temperatures
where 1=1
    and count_of_rows = 5
    and (temperature - average_temperature) / temperature > 0.1
order by
    site_id,
    reading_datetime
```
