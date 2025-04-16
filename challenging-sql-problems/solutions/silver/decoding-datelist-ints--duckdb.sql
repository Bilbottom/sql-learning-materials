```sql
with recursive

axis(active_date, max_, step) as (
        select
            (select last_update from user_history limit 1),
            (select max(log2(activity_history)) from user_history),
            1
    union all
        select active_date - 1, max_, step + 1
        from axis
        where step < max_
),

decoded as (
    select
        user_history.user_id,
        axis.active_date,
        (activity_history & power(2, axis.step - 1)::int > 0)::int as active_flag
    from axis
        cross join user_history
)

pivot decoded
on ('user_' || user_id)
using any_value(active_flag)
order by active_date
```
