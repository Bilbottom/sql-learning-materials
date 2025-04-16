```sql
with events(event_id, user_id, event_datetime, event_type) as (
    values
        (1,  1, '2024-01-01 03:00:00'::timestamp, 'login failed'),
        (2,  1, '2024-01-01 03:01:00'::timestamp, 'login failed'),
        (3,  1, '2024-01-01 03:02:00'::timestamp, 'login failed'),
        (4,  1, '2024-01-01 11:00:00'::timestamp, 'login'),
        (5,  1, '2024-01-01 12:00:00'::timestamp, 'logout'),
        (6,  2, '2024-01-01 15:00:00'::timestamp, 'login'),
        (7,  2, '2024-01-01 18:00:00'::timestamp, 'logout'),
        (8,  1, '2024-01-02 03:00:00'::timestamp, 'login failed'),
        (9,  1, '2024-01-02 03:01:00'::timestamp, 'login failed'),
        (10, 1, '2024-01-02 03:02:00'::timestamp, 'login failed'),
        (11, 1, '2024-01-03 03:00:00'::timestamp, 'login failed'),
        (12, 1, '2024-01-03 03:01:00'::timestamp, 'login failed'),
        (13, 1, '2024-01-03 03:02:00'::timestamp, 'login failed')
)
```
