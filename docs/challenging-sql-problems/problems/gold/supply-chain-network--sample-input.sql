```sql
with

locations(location_id, location_type) as (
    values
        (1, 'supplier'),
        (2, 'supplier'),
        (3, 'depot'),
        (4, 'depot'),
        (5, 'store')
),

deliveries(delivery_date, from_location_id, to_location_id, product_id, quantity) as (
    values
        ('2024-01-01 01:23:53'::timestamp, 1, 3, 123, 25),
        ('2024-01-01 06:27:54'::timestamp, 2, 4, 123, 25),
        ('2024-01-01 12:27:39'::timestamp, 4, 5, 123, 25),
        ('2024-01-01 17:12:59'::timestamp, 1, 3, 123, 30),
        ('2024-01-02 01:27:57'::timestamp, 3, 5, 123, 25),
        ('2024-01-02 05:16:08'::timestamp, 3, 4, 123, 30),
        ('2024-01-02 05:40:53'::timestamp, 2, 3, 123, 20),
        ('2024-01-02 07:29:53'::timestamp, 1, 4, 123, 30),
        ('2024-01-02 09:22:53'::timestamp, 3, 5, 123, 20),
        ('2024-01-02 18:28:39'::timestamp, 4, 5, 123, 60)
),

sales(sale_datetime, store_id, product_id, quantity) as (
    values
        ('2024-01-01 14:56:12'::timestamp, 5, 123,  5),
        ('2024-01-01 16:28:24'::timestamp, 5, 123,  3),
        ('2024-01-01 16:35:38'::timestamp, 5, 123,  4),
        ('2024-01-01 20:13:46'::timestamp, 5, 123,  2),
        ('2024-01-02 09:37:11'::timestamp, 5, 123, 12),
        ('2024-01-02 14:02:57'::timestamp, 5, 123, 30),
        ('2024-01-02 14:21:39'::timestamp, 5, 123,  3),
        ('2024-01-02 16:44:26'::timestamp, 5, 123,  8),
        ('2024-01-02 18:28:37'::timestamp, 5, 123,  2)
)
```
