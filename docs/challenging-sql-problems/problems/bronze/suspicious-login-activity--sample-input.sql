```sql
with events(event_id, user_id, event_datetime, event_type) as (
    values
        (1, 1, '2024-01-01 03:00:00', 'login failed'),
        (2, 1, '2024-01-01 03:01:00', 'login failed'),
        (3, 1, '2024-01-01 03:02:00', 'login failed'),
        (4, 1, '2024-01-01 03:03:00', 'login failed'),
        (5, 1, '2024-01-01 03:04:00', 'login failed'),
        (6, 1, '2024-01-01 03:05:00', 'login'),
        (7, 2, '2024-01-01 10:00:00', 'login'),
        (8, 2, '2024-01-01 15:00:00', 'logout'),
        (9, 2, '2024-01-01 23:00:00', 'login failed')
)
```
