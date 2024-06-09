```sql
with

event_groups as (
    select
        *,
        cast(event_datetime as date) as event_date,
        (0
            + row_number() over (partition by user_id             order by event_id)
            - row_number() over (partition by user_id, event_type order by event_id)
        ) as event_group
    from events
),

login_failed_events as (
    select
        user_id,
        event_date,
        event_group,
        iif(count(*) >= 3, 1, 0) as three_login_failures_flag
    from event_groups
    where event_type = 'login failed'
    group by
        user_id,
        event_date,
        event_group
)

select
    user_id,
    event_date as ban_date
from login_failed_events
where 3 = (
    select sum(last_three_days.three_login_failures_flag)
    from login_failed_events as last_three_days
    where login_failed_events.user_id = last_three_days.user_id
      and last_three_days.event_date between dateadd(day, -2, login_failed_events.event_date)
                                         and login_failed_events.event_date
)
order by user_id
```
