# Metric correlation 🔀

> [!TIP]
>
> Solution to the following problem:
>
> - [metric-correlation.md](../../problems/silver/metric-correlation.md)

## Result Set

Regardless of the database (since they should all use a similar collation), the result set should look like:

| segment | metric_pair        | correlation |
| ------: | :----------------- | ----------: |
|       0 | metric_1, metric_4 |      0.8195 |
|       1 | metric_2, metric_4 |      0.6741 |
|       2 | metric_2, metric_4 |      0.8539 |
|       3 | metric_3, metric_5 |      0.9975 |
|       4 | metric_1, metric_4 |      0.9122 |
|       5 | metric_3, metric_5 |      0.9985 |
|       6 | metric_3, metric_5 |      0.9961 |
|       7 | metric_2, metric_4 |      0.5686 |
|       8 | metric_2, metric_4 |      0.8405 |
|       9 | metric_1, metric_5 |      0.9989 |
|      10 | metric_2, metric_5 |      0.8042 |

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/solutions/silver/metric-correlation.sql"
</details>

## Solution

Some SQL solutions per database are provided below.

<!-- prettier-ignore -->
> SUCCESS: **DuckDB**
>
--8<-- "docs/challenging-sql-problems/solutions/silver/metric-correlation--duckdb.sql"
