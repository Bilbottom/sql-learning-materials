# Funnel analytics ⏬

> [!TIP]
>
> Solution to the following problem:
>
> - [funnel-analytics.md](../../problems/silver/funnel-analytics.md)

## Result Set

Regardless of the database, the result set should look like:

| cohort  | stage                | mortgages | step_rate | total_rate |
| :------ | :------------------- | --------: | --------: | ---------: |
| 2024-01 | full application     |         4 |    100.00 |     100.00 |
| 2024-01 | decision             |         4 |    100.00 |     100.00 |
| 2024-01 | documentation        |         3 |     75.00 |      75.00 |
| 2024-01 | valuation inspection |         3 |    100.00 |      75.00 |
| 2024-01 | valuation made       |         3 |    100.00 |      75.00 |
| 2024-01 | valuation submitted  |         3 |    100.00 |      75.00 |
| 2024-01 | solicitation         |         1 |     33.33 |      25.00 |
| 2024-01 | funds released       |         1 |    100.00 |      25.00 |
| 2024-02 | full application     |         6 |    100.00 |     100.00 |
| 2024-02 | decision             |         6 |    100.00 |     100.00 |
| 2024-02 | documentation        |         4 |     66.67 |      66.67 |
| 2024-02 | valuation inspection |         4 |    100.00 |      66.67 |
| 2024-02 | valuation made       |         4 |    100.00 |      66.67 |
| 2024-02 | valuation submitted  |         4 |    100.00 |      66.67 |
| 2024-02 | solicitation         |         3 |     75.00 |      50.00 |
| 2024-02 | funds released       |         3 |    100.00 |      50.00 |
| 2024-03 | full application     |         3 |    100.00 |     100.00 |
| 2024-03 | decision             |         3 |    100.00 |     100.00 |
| 2024-03 | documentation        |         1 |     33.33 |      33.33 |
| 2024-03 | valuation inspection |         1 |    100.00 |      33.33 |
| 2024-03 | valuation made       |         1 |    100.00 |      33.33 |
| 2024-03 | valuation submitted  |         1 |    100.00 |      33.33 |
| 2024-03 | solicitation         |         0 |      0.00 |       0.00 |
| 2024-03 | funds released       |         0 |      0.00 |       0.00 |

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/solutions/silver/funnel-analytics.sql"
</details>

## Solution

Some SQL solutions per database are provided below.

[//]: # "What about a solution like: https://popsql.com/sql-templates/marketing/running-a-funnel-analysis"

<!-- prettier-ignore -->
> SUCCESS: **DuckDB**
>
--8<-- "docs/challenging-sql-problems/solutions/silver/funnel-analytics--duckdb.sql"
