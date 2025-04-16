```sql
with

locations as (
    select
        grid_id,
        substring(grid_id, 1, -1 + charindex('-', grid_id)) as region,
        substring(grid_id, 1 + charindex('-', grid_id), 99) as location
    from (values
        ('AC-27'),
        ('AQ-54'),
        ('AQ-55'),
        ('AQ-56'),
        ('BK-45'),
        ('BK-77'),
        ('BR-18'),
        ('X-17')
    ) as v(grid_id)
),

region_by_month as (
    select
        grid_id,
        month_name,
        precipitation,
        substring(grid_id, 1, -1 + charindex('-', grid_id)) as region,
        substring(grid_id, 1 + charindex('-', grid_id), 99) as location
    from precipitation
    unpivot (
        precipitation
        for month_name in (
            pr_january,
            pr_february,
            pr_march,
            pr_april,
            pr_may,
            pr_june,
            pr_july,
            pr_august,
            pr_september,
            pr_october,
            pr_november,
            pr_december
        )
    ) as unpivoted
),

average_precipitation as (
    select
        region,
        location,
        grouping_id(region, location) as group_id,  /* 0 - region & location;  1 - region;  3 - total */
        avg(precipitation) as average_precipitation
    from region_by_month
    group by rollup (region, location)
)

select
    locations.grid_id,
    round(coalesce(
        region_location.average_precipitation,
        region_only.average_precipitation,
        overall.average_precipitation
    ), 6) as average_precipitation
from locations
    left join average_precipitation as region_location
        on  locations.region = region_location.region
        and locations.location = region_location.location
        and region_location.group_id = 0
    left join average_precipitation as region_only
        on  locations.region = region_only.region
        and region_only.group_id = 1
    left join average_precipitation as overall
        on overall.group_id = 3
order by locations.grid_id
```
