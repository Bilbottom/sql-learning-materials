# Predicting values 🎱

> [!TIP]
>
> Solution to the following problem:
>
> - [predicting-values.md](../../problems/silver/predicting-values.md)

## Result Set

Regardless of the database, the result set should look like:

|   x | dataset_1 | dataset_2 | dataset_3 | dataset_4 |
| --: | --------: | --------: | --------: | --------: |
|  16 |      11.0 |      11.0 |      11.0 |      11.0 |
|  17 |      11.5 |      11.5 |      11.5 |      11.5 |
|  18 |      12.0 |      12.0 |      12.0 |      12.0 |

This is one of the interesting things about Anscombe's quartet (and is the reason Anscombe created it): the four datasets have the same line of best fit, but look very different when plotted!

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/solutions/silver/predicting-values.sql"
</details>

## Solution

Some SQL solutions per database are provided below.

<!-- prettier-ignore -->
> SUCCESS: **DuckDB**
>
> Here's a solution using the `regr_slope` and `regr_intercept` functions:
>
--8<-- "docs/challenging-sql-problems/solutions/silver/predicting-values--duckdb--regr.sql"
>
> ...and one doing this manually:
>
--8<-- "docs/challenging-sql-problems/solutions/silver/predicting-values--duckdb--manual.sql"
