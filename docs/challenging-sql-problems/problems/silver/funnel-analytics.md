---
hide:
  - tags
tags:
  - custom axis
---

# Funnel analytics ⏬

> [!SUCCESS] Scenario
>
> A bank is interested in understanding the conversion rates of their mortgage application process.
>
> Their application funnel consists of the following stages, in order:
>
> 1. Full application
> 2. Decision
> 3. Documentation
> 4. Valuation inspection
> 5. Valuation made
> 6. Valuation submitted
> 7. Solicitation
> 8. Funds released

> [!QUESTION]
>
> The table `applications` tracks the dates that each mortgage application reached each stage.
>
> Calculate the conversion rates between each stage for each cohort (defined below).
>
> The output should have a row per cohort and stage, with the columns:
>
> - `cohort` as the month that the applications were started; e.g., an application started on `2024-01-15` would be cohort `2024-01`.
> - `stage`
> - `mortgages` as the number of mortgages that reached the stage
> - `step_rate` as the percentage of mortgages that reached the stage compared to the previous stage
> - `total_rate` as the percentage of mortgages that reached the stage compared to the first stage
>
> Round the `step_rate` and `total_rate` to two decimal places.
>
> Note that each cohort should have _all_ the stages, even if there are no mortgages that reached that stage -- the `mortgages` column should be `0` in that case.
>
> Order the output by `cohort` and _the `stage` order_ (e.g. `full application` should come before `decision`, and so on).

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/silver/funnel-analytics.sql"
</details>

The solution can be found at:

- [funnel-analytics.md](../../solutions/silver/funnel-analytics.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample input**
>
> | event_id | event_date | mortgage_id | stage                |
> |---------:|:-----------|------------:|:---------------------|
> |        1 | 2024-01-02 |           1 | full application     |
> |        2 | 2024-01-06 |           1 | decision             |
> |        3 | 2024-01-12 |           1 | documentation        |
> |        4 | 2024-01-14 |           1 | valuation inspection |
> |        5 | 2024-01-27 |           1 | valuation made       |
> |        6 | 2024-02-02 |           1 | valuation submitted  |
> |        7 | 2024-04-26 |           1 | solicitation         |
>
--8<-- "docs/challenging-sql-problems/problems/silver/funnel-analytics--sample-input.sql"

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> | cohort  | stage                | mortgages | step_rate | total_rate |
> |:--------|:---------------------|----------:|----------:|-----------:|
> | 2024-01 | full application     |         1 |    100.00 |     100.00 |
> | 2024-01 | decision             |         1 |    100.00 |     100.00 |
> | 2024-01 | documentation        |         1 |    100.00 |     100.00 |
> | 2024-01 | valuation inspection |         1 |    100.00 |     100.00 |
> | 2024-01 | valuation made       |         1 |    100.00 |     100.00 |
> | 2024-01 | valuation submitted  |         1 |    100.00 |     100.00 |
> | 2024-01 | solicitation         |         1 |    100.00 |     100.00 |
> | 2024-01 | funds released       |         0 |      0.00 |       0.00 |
>
--8<-- "docs/challenging-sql-problems/problems/silver/funnel-analytics--sample-output.sql"

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> Determine each row's cohort before calculating the rates.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> Use [window functions](../../../from-excel-to-sql/main-concepts/window-functions.md) to compare the current row with the historic rows.
