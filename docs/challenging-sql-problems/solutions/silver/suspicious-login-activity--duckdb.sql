```sql
with event_groups as (
    select
        *,
        (0
            + row_number() over (partition by user_id             order by event_id)
            - row_number() over (partition by user_id, event_type order by event_id)
        ) as event_group
    from events
)

select
    user_id,
    count(*) as consecutive_failures
from event_groups
group by user_id, event_group
having 1=1
    and consecutive_failures >= 5
    and any_value(event_type) = 'login failed'
qualify consecutive_failures = max(consecutive_failures) over (partition by user_id)
order by user_id
```
