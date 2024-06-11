```sql
with recursive

axis as (
    select generate_series / 100 as i
    from generate_series(-200, 200, 8)
),

grid as (
    select x.i as x, y.i as y,
    from axis as x, axis as y
),

apply_calculation as (
        /* define the set of complex points (c = (x, y), z = (a, b)) */
        select
            x,
            y,
            000.0000 as a,
            000.0000 as b,
            0 as i,
        from grid
    union all
        /* apply the mandelbrot set formula */
        select
            x,
            y,
            a^2 - b^2 + x,
            2 * a * b + y,
            i + 1,
        from apply_calculation
        where 1=1
            and (abs(a), abs(b)) <= (2, 2)
            and i < 100
),

mandelbrot_set as (
    select
        grid.x,
        grid.y,
        if(apply_calculation.i is not null, '•', ' ') as in_set
    from grid
        left join apply_calculation
            on  grid.x = apply_calculation.x
            and grid.y = apply_calculation.y
            and apply_calculation.i = 100
)

select string_agg(x_rows, e'\n' order by y) as mandelbrot_set
from (
    select
        y,
        string_agg(in_set, '' order by x) as x_rows
    from mandelbrot_set
    group by y
)
```
