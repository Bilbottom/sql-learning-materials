```sql
select *
from values
    ('2024-01-01', 'full application',     4, 100.00, 100.00),
    ('2024-01-01', 'decision',             4, 100.00, 100.00),
    ('2024-01-01', 'documentation',        3,  75.00,  75.00),
    ('2024-01-01', 'valuation inspection', 3, 100.00,  75.00),
    ('2024-01-01', 'valuation made',       3, 100.00,  75.00),
    ('2024-01-01', 'valuation submitted',  3, 100.00,  75.00),
    ('2024-01-01', 'solicitation',         1,  33.33,  25.00),
    ('2024-01-01', 'funds released',       1, 100.00,  25.00),
    ('2024-02-01', 'full application',     6, 100.00, 100.00),
    ('2024-02-01', 'decision',             6, 100.00, 100.00),
    ('2024-02-01', 'documentation',        4,  66.67,  66.67),
    ('2024-02-01', 'valuation inspection', 4, 100.00,  66.67),
    ('2024-02-01', 'valuation made',       4, 100.00,  66.67),
    ('2024-02-01', 'valuation submitted',  4, 100.00,  66.67),
    ('2024-02-01', 'solicitation',         3,  75.00,  50.00),
    ('2024-02-01', 'funds released',       3, 100.00,  50.00),
    ('2024-03-01', 'full application',     3, 100.00, 100.00),
    ('2024-03-01', 'decision',             3, 100.00, 100.00),
    ('2024-03-01', 'documentation',        1,  33.33,  33.33),
    ('2024-03-01', 'valuation inspection', 1, 100.00,  33.33),
    ('2024-03-01', 'valuation made',       1, 100.00,  33.33),
    ('2024-03-01', 'valuation submitted',  1, 100.00,  33.33),
    ('2024-03-01', 'solicitation',         0,   0.00,   0.00),
    ('2024-03-01', 'funds released',       0,   0.00,   0.00)
as solution(cohort, stage, mortgages, step_rate, total_rate)
```
