```sql
with temperatures as (
    select
        site_id,
        reading_datetime,
        temperature,
        avg(temperature) over rows_around_site_reading as average_temperature
    from readings
    window rows_around_site_reading as (
        partition by site_id
        order by reading_datetime
        rows between 2 preceding
                 and 2 following
             exclude current row
    )
    qualify 4 = count(*) over rows_around_site_reading
)

select
    site_id,
    reading_datetime,
    temperature,
    round(average_temperature, 4) as average_temperature,
    round(100.0 * (temperature - average_temperature) / average_temperature, 4) as percentage_increase
from temperatures
where percentage_increase > 10
order by
    site_id,
    reading_datetime
```
