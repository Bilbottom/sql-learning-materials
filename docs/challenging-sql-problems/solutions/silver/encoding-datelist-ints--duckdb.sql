```sql
with recursive

event_groups as (
    select
        event_id,
        user_id,
        event_type,
        event_datetime as login_datetime,
        (0
            + row_number() over (partition by user_id             order by event_datetime)
            - row_number() over (partition by user_id, event_type order by event_datetime)
        ) as event_group,
        coalesce(
            (
                select min(event_datetime)
                from events as innr
                where 1=1
                    and events.event_type = 'login'
                    and innr.event_type = 'logout'
                    and events.user_id = innr.user_id
                    and events.event_datetime < innr.event_datetime
                    and innr.event_datetime <= events.event_datetime + interval '1 day'
            ),
            events.event_datetime + interval '1 day'
        ) as logout_datetime
    from events
),

sessions as (
    select
        user_id,
        min(login_datetime)::date as login_date,
        max(logout_datetime)::date as logout_date
    from event_groups
    where event_type = 'login'
    group by user_id, event_group
),

dates(active_date) as (
    select unnest(generate_series(
        (select min(login_date) from sessions),
        (select max(logout_date) from sessions),
        interval '1 day'
    ))
),

activity(user_id, active_date, is_active) as (
    select
        users.user_id,
        dates.active_date::date as active_date,
        if(sessions.user_id is null, 0, 1) as is_active,
        row_number() over (
            partition by users.user_id
            order by dates.active_date desc
        ) as step
    from (select distinct user_id from sessions) as users
        cross join dates
        left join sessions
            on  users.user_id = sessions.user_id
            and dates.active_date between sessions.login_date
                                      and sessions.logout_date
)

select
    user_id,
    max(active_date) as last_update,
    sum(is_active * power(2, step - 1)) as activity_history
from activity
group by user_id
order by user_id
```
