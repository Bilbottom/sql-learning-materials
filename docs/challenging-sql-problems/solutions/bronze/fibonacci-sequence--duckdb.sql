```sql
with recursive fibonacci(n, f_n, f_m) as (
        select 1, 1, 0
    union all
        select
            n + 1,
            f_n + f_m,
            f_n
        from fibonacci
        where n < 45
)

select n, f_n
from fibonacci
order by n
```
