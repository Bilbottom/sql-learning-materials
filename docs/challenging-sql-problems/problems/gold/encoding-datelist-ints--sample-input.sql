```sql
with events(event_id, user_id, event_datetime, event_type) as (
    values
        (1,  1, '2024-01-01 01:03:00'::timestamp, 'login'),
        (2,  1, '2024-01-04 01:02:00'::timestamp, 'login'),
        (3,  1, '2024-01-05 01:01:00'::timestamp, 'login'),
        (4,  1, '2024-01-06 01:00:00'::timestamp, 'logout'),
        (5,  1, '2024-01-07 01:05:00'::timestamp, 'logout'),
        (6,  1, '2024-01-07 01:06:00'::timestamp, 'logout'),
        (7,  2, '2024-01-08 01:07:00'::timestamp, 'login'),
        (8,  2, '2024-01-09 01:08:00'::timestamp, 'login'),
        (9,  2, '2024-01-10 01:09:00'::timestamp, 'login'),
        (10, 2, '2024-01-10 01:10:00'::timestamp, 'logout'),
        (11, 2, '2024-01-11 01:11:00'::timestamp, 'logout'),
        (12, 2, '2024-01-12 01:12:00'::timestamp, 'logout')
)
```
