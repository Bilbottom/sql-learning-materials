```sql
with event_groups as (
    select
        *,
        (0
            + row_number() over (partition by user_id             order by event_id)
            - row_number() over (partition by user_id, event_type order by event_id)
        ) as event_group,
    from events
)

select
    user_id,
    event_datetime::date as ban_date
from event_groups
where event_type = 'login failed'
group by
    user_id,
    ban_date,
    event_group
qualify 3 = sum((count(*) >= 3)::int) over (
    partition by user_id
    order by ban_date range interval '2 days' preceding
)
order by user_id
```
