```sql
with readings(site_id, reading_datetime, temperature) as (
    values
        (1, '2021-06-01 02:12:31'::timestamp, 26.17),
        (1, '2021-06-01 21:17:12'::timestamp, 26.32),
        (1, '2021-06-02 01:19:56'::timestamp, 29.58),
        (1, '2021-06-02 19:35:32'::timestamp, 27.06),
        (1, '2021-06-03 03:14:53'::timestamp, 26.26),
        (1, '2021-06-03 20:47:42'::timestamp, 28.37)
)
```
