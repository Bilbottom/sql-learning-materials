---
hide:
  - tags
tags:
  - pivot and unpivot
  - correlation
---

# Metric correlation 🔀

> [!SUCCESS] Scenario
>
> A company has banded their customers into segments and calculated several metrics for each customer.
>
> The company wants to know which pairs of metrics are most correlated within each segment.

> [!QUESTION]
>
> For each customer segment, find the highest correlated pair of metrics.
>
> The correlation should be rounded to four decimal places, and the output should keep ties in the (rounded) correlation. Don't compare a metric to itself 😄
>
> The output should have a row per segment and metric pair, with the columns:
>
> - `segment`
> - `metric_pair` as the metric pair in the format `metric_1, metric_2`. Put the ([lexicographically](https://www.reddit.com/r/explainlikeimfive/comments/wf5s2e/eli5_what_are_lexicographical_order_in_computer/)) lower metric name on the left using your database's default [collation](https://stackoverflow.com/a/4538738/8213085)
> - `correlation` as the correlation between the two metrics, rounded to four decimal places
>
> Order the output by `segment` and `metric_pair`.

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/silver/metric-correlation.sql"
</details>

The solution can be found at:

- [metric-correlation.md](../../solutions/silver/metric-correlation.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample input**
>
> | customer_id | segment | metric_1 | metric_2 | metric_3 | metric_4 | metric_5 |
> |------------:|--------:|---------:|---------:|---------:|---------:|---------:|
> |           1 |       1 |       21 |       58 |       66 |       79 |       29 |
> |           2 |       0 |       70 |       55 |       79 |      125 |        2 |
> |           3 |       1 |       68 |       55 |       10 |      123 |       70 |
> |           4 |       1 |       20 |       62 |       59 |       82 |       25 |
> |           5 |       0 |       42 |        9 |       80 |       51 |       13 |
> |           6 |       1 |       26 |       89 |       17 |      115 |       66 |
> |           7 |       1 |       45 |       51 |       90 |       96 |       17 |
> |           8 |       0 |        4 |       52 |       47 |       56 |       61 |
> |           9 |       0 |       57 |       48 |       82 |      105 |       40 |
> |          10 |       1 |       17 |       93 |       45 |      109 |       76 |
>
--8<-- "docs/challenging-sql-problems/problems/silver/metric-correlation--sample-input.sql"

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> | segment | metric_pair        | correlation |
> |--------:|:-------------------|------------:|
> |       0 | metric_1, metric_3 |      0.9051 |
> |       1 | metric_4, metric_5 |      0.8357 |
>
--8<-- "docs/challenging-sql-problems/problems/silver/metric-correlation--sample-output.sql"

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> Use a correlation function, usually called `CORR`, to calculate the correlation between two metrics.
>
> If you're using a database that doesn't have a built-in correlation function, you can try to calculate it manually -- but I'd instead recommend skipping this question.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> To get every pair of metrics "side by side" for the `CORR` function, unpivot the table so that each metric is in its own row and then join the resulting table to itself on the `segment` and `customer_id` columns.
