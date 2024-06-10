```sql
with temperatures as (
    select
        site_id,
        reading_datetime,
        temperature,
        avg(temperature) over rows_around_site_reading as average_temperature,
        count(*) over rows_around_site_reading as count_of_rows
    from readings
    window rows_around_site_reading as (
        partition by site_id
        order by reading_datetime
        rows between 2 preceding
                 and 2 following
             exclude current row
    )
)

select
    site_id,
    reading_datetime,
    temperature,
    round(average_temperature, 4) as average_temperature,
    round(100.0 * (temperature - average_temperature) / average_temperature, 4) as percentage_increase
from temperatures
where 1=1
    and count_of_rows = 4
    and (temperature - average_temperature) / average_temperature > 0.1
order by
    site_id,
    reading_datetime
```
