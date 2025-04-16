```sql
with

session_datetimes as (
    select
        event_id,
        user_id,
        event_datetime as login_datetime,
        coalesce(
            (
                select min(event_datetime)
                from events as innr
                where 1=1
                    and events.user_id = innr.user_id
                    and innr.event_datetime > events.event_datetime
                    and innr.event_datetime <= events.event_datetime + interval '1 day'
                    and innr.event_type = 'logout'
            ),
            events.event_datetime + interval '1 day'
        ) as logout_datetime,
    from events
    where event_type = 'login'
),

event_groups as (
    select
        *,
        sum(is_new_session::int) over (order by login_datetime) as session_id
    from (
        select
            *,
            login_datetime >= lag(logout_datetime, 1, login_datetime) over (
                partition by user_id
                order by login_datetime
            ) as is_new_session
        from session_datetimes
    )
),

sessions as (
    select
        user_id,
        min(login_datetime)::date as login_date,
        max(logout_datetime)::date as logout_date
    from event_groups
    group by user_id, session_id
),

dates(active_date) as (
    select unnest(generate_series(
        (select min(event_datetime)::date from events),
        (select max(event_datetime)::date from events),
        interval '1 day'
    ))
),

activity(user_id, active_date, is_active) as (
    select
        users.user_id,
        dates.active_date::date as active_date,
        exists(
            select *
            from sessions
            where 1=1
                and users.user_id = sessions.user_id
                and dates.active_date between sessions.login_date
                                          and sessions.logout_date
        )::int as is_active,
        row_number() over (
            partition by users.user_id
            order by dates.active_date desc
        ) as step
    from (select distinct user_id from sessions) as users
        cross join dates
)

select
    user_id,
    max(active_date) as last_update,
    sum(is_active * power(2, step - 1)) as activity_history
from activity
group by user_id
order by user_id
```
