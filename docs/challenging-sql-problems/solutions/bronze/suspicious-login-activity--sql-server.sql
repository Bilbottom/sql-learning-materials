```sql
with

event_groups as (
    select
        *,
        (0
            + row_number() over (partition by user_id             order by event_id)
            - row_number() over (partition by user_id, event_type order by event_id)
        ) as event_group
    from events
),

consecutive_failures as (
    select
        user_id,
        count(*) as consecutive_failures,
        max(count(*)) over (partition by user_id) as max_consecutive_failures
    from event_groups
    where event_type = 'login failed'
    group by user_id, event_group
    having count(*) >= 5
)

select
    user_id,
    consecutive_failures
from consecutive_failures
where 1=1
    and consecutive_failures >= 5
    and consecutive_failures = max_consecutive_failures
order by user_id
```
