```sql
with

unpivoted as (
    unpivot metrics
    on columns(* exclude (segment, customer_id))
    into
        name metric_name
        value metric_value
),

joined as (
    select
        l.customer_id,
        l.segment,
        l.metric_name as l_metric_name,
        r.metric_name as r_metric_name,
        l.metric_value as l_metric_value,
        r.metric_value as r_metric_value
    from unpivoted as l
        inner join unpivoted as r
            on  l.customer_id = r.customer_id
            and l.segment = r.segment
            and l.metric_name < r.metric_name  /* No point in pairing metrics twice */
)

select
    segment,
    l_metric_name || ', ' || r_metric_name as metric_pair,
    round(corr(l_metric_value, r_metric_value), 4) as correlation
from joined
group by segment, l_metric_name, r_metric_name
qualify correlation = max(correlation) over (partition by segment)
order by segment, metric_pair
```
