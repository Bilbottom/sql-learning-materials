```sql
with

unpivoted as (
    unpivot anscombes_quartet
    on
        (dataset_1__x, dataset_1__y) as dataset_1,
        (dataset_2__x, dataset_2__y) as dataset_2,
        (dataset_3__x, dataset_3__y) as dataset_3,
        (dataset_4__x, dataset_4__y) as dataset_4,
    into
        name dataset
        value x, y
),

coefficients as (
    select
        dataset,
        avg(x) as avg_x,
        avg(y) as avg_y,
        avg(x * x) as avg_xx,
        avg(x * y) as avg_xy,
        (avg_x * avg_y - avg_xy) / (avg_x * avg_x - avg_xx) as m,
        avg_y - m * avg_x as c,
    from unpivoted
    group by dataset
),

predictions as (
    select
        dataset,
        x,
        round(m * x + c, 1) as y
    from coefficients
        cross join (values (16), (17), (18)) as v(x)
)

pivot predictions
on dataset
using any_value(y)
order by x
```
