```sql
with applications(event_id, event_date, mortgage_id, stage) as (
    values
        (1, '2024-01-02', 1, 'full application'),
        (2, '2024-01-06', 1, 'decision'),
        (3, '2024-01-12', 1, 'documentation'),
        (4, '2024-01-14', 1, 'valuation inspection'),
        (5, '2024-01-27', 1, 'valuation made'),
        (6, '2024-02-02', 1, 'valuation submitted'),
        (7, '2024-04-26', 1, 'solicitation')
)
```
