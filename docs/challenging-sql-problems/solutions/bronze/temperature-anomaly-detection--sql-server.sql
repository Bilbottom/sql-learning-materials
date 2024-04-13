```sql
with temps as (
    select
        site_id,
        reading_datetime,
        temperature,
        (
            avg(temperature) over rows_before_site_reading
            + avg(temperature) over rows_after_site_reading
        ) / 2 as average_temperature,
        (
            count(temperature) over rows_before_site_reading
            + count(temperature) over rows_after_site_reading
        ) as count_of_rows
    from readings
    window
        rows_before_site_reading as (
            partition by site_id
            order by reading_datetime
            rows between 2 preceding and 1 preceding
        ),
        rows_after_site_reading as (
            partition by site_id
            order by reading_datetime
            rows between 1 following and 2 following
        )
)

select
    site_id,
    reading_datetime,
    temperature,
    round(average_temperature, 4) as average_temperature,
    round(100.0 * (temperature - average_temperature) / average_temperature, 4) as percentage_increase
from temps
where 1=1
    and count_of_rows = 4
    and (temperature - average_temperature) / average_temperature > 0.1
order by
    site_id,
    reading_datetime
```
