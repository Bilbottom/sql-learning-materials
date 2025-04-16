```sql
select
    user_id,
    bit_count((activity_history >> 7) & (power(2, 7)::int - 1)) as days_active_last_week
from user_history
where 1=1
    /* Active last week... */
    and (activity_history >> 7) & (power(2, 7)::int - 1) > 0
    /* ...and inactive this week */
    and activity_history & (power(2, 7)::int - 1) = 0
```
