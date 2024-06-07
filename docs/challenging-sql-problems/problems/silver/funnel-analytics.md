# Funnel analytics ⏬

> [!QUESTION]
>
> A prominent UK bank is interested in understanding the conversion rates of their mortgage application process.
>
> Their application funnel consists of the following stages, in order:
>
> 1. full application
> 2. decision
> 3. documentation
> 4. valuation inspection
> 5. valuation made
> 6. valuation submitted
> 7. solicitation
> 8. funds released
>
> The table `applications` tracks the dates that each mortgage application reached each stage.
>
> Write a query that calculates the conversion rates between each stage for each cohort (defined below).
>
> The output should have a row per cohort and stage, with the columns:
>
> - `cohort` as the month that the applications were started; e.g., an application started on `2024-01-15` would be cohort `2024-01-01`.
> - `stage`
> - `mortgages` as the number of mortgages that reached the stage
> - `step_rate` as the percentage of mortgages that reached the stage compared to the previous stage
> - `total_rate` as the percentage of mortgages that reached the stage compared to the first stage
>
> Note that each cohort should have _all_ the stages, even if there are no mortgages that reached that stage -- the `mortgages` column should be `0` in that case.
>
> The output should be ordered by `cohort` and _the `stage` order_ (e.g. `full application` should come before `decision`, and so on).

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/silver/funnel-analytics.sql"
</details>

The solution can be found at:

- [funnel-analytics.md](../../solutions/silver/funnel-analytics.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
| cohort     | stage                | mortgages | step_rate | total_rate |
|:-----------|:---------------------|----------:|----------:|-----------:|
| 2024-01-01 | full application     |         4 |    100.00 |     100.00 |
| 2024-01-01 | decision             |         4 |    100.00 |     100.00 |
| 2024-01-01 | documentation        |         3 |     75.00 |      75.00 |
| 2024-01-01 | valuation inspection |         3 |    100.00 |      75.00 |
| 2024-01-01 | valuation made       |         3 |    100.00 |      75.00 |
| 2024-01-01 | valuation submitted  |         3 |    100.00 |      75.00 |
| 2024-01-01 | solicitation         |         1 |     33.33 |      25.00 |
| 2024-01-01 | funds released       |         1 |    100.00 |      25.00 |
| ...        | ...                  |       ... |       ... |        ... |

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> Determine each row's cohort before calculating the rates.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> Use [window functions](../../../from-excel-to-sql/main-concepts/window-functions.md) to compare the current row with the historic rows.
