```sql
solution(stock_date, store_id, supplier_id, stock_volume, stock_proportion) as (
    values
        ('2024-01-01'::date, 6, 1,  0,   0.00),
        ('2024-01-01'::date, 6, 2, 10, 100.00),
        ('2024-01-01'::date, 7, 1,  0,   0.00),
        ('2024-01-01'::date, 7, 2,  0,   0.00),
        ('2024-01-01'::date, 8, 1,  0,   0.00),
        ('2024-01-01'::date, 8, 2,  0,   0.00),
        ('2024-01-02'::date, 6, 1,  0,   0.00),
        ('2024-01-02'::date, 6, 2,  9, 100.00),
        ('2024-01-02'::date, 7, 1,  6,  54.55),
        ('2024-01-02'::date, 7, 2,  5,  45.45),
        ('2024-01-02'::date, 8, 1,  0,   0.00),
        ('2024-01-02'::date, 8, 2,  1, 100.00),
        ('2024-01-03'::date, 6, 1, 14,  41.18),
        ('2024-01-03'::date, 6, 2, 20,  58.82),
        ('2024-01-03'::date, 7, 1,  0,   0.00),
        ('2024-01-03'::date, 7, 2,  2, 100.00),
        ('2024-01-03'::date, 8, 1,  1,   6.25),
        ('2024-01-03'::date, 8, 2, 15,  93.75),
        ('2024-01-04'::date, 6, 1, 34,  57.63),
        ('2024-01-04'::date, 6, 2, 25,  42.37),
        ('2024-01-04'::date, 7, 1,  3, 100.00),
        ('2024-01-04'::date, 7, 2,  0,   0.00),
        ('2024-01-04'::date, 8, 1, 15, 100.00),
        ('2024-01-04'::date, 8, 2,  0,   0.00)
)
```
