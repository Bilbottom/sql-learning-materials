# Temperature anomaly detection 🔍

> [!SUCCESS] Scenario
>
> Some scientists are studying temperature data from various sites.
>
> They are interested in identifying temperature readings that are significantly higher than the surrounding readings.

> [!QUESTION]
>
> Given the temperature data below, return the temperature readings that are at least 10% higher than the average of the previous 2 and following 2 readings.
>
> Do _not_ include the current reading in the average calculation, and use the calculated average temperature as the denominator for the 10% calculation.
>
> If there are fewer than 2 readings before or 2 after the current reading, do not include the reading in the output.
>
> The output should only have the temperature readings above the threshold, with the columns:
>
> - `site_id`
> - `reading_datetime`
> - `temperature`
> - `average_temperature` as the average of the 4 readings around the current reading (2 each side), rounded to 4 decimal places
> - `percentage_increase` as the percentage increase of the current reading over the `average_temperature`, rounded to 4 decimal places
>
> Order the output by `site_id` and `reading_datetime`.

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/bronze/temperature-anomaly-detection.sql"
</details>

The solution can be found at:

- [temperature-anomaly-detection.md](../../solutions/bronze/temperature-anomaly-detection.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> | site_id | reading_datetime    | temperature | average_temperature | percentage_increase |
> |--------:|:--------------------|------------:|--------------------:|--------------------:|
> |       1 | 2021-01-02 02:01:17 |       22.43 |             20.0525 |             11.8564 |
> |     ... | ...                 |         ... |                 ... |                 ... |

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> Use a [window function](../../../from-excel-to-sql/main-concepts/window-functions.md) (or two!) to calculate the average temperature of the surrounding readings.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> Use another [window function](../../../from-excel-to-sql/main-concepts/window-functions.md) to identify rows with at least 4 surrounding readings (2 before and 2 after).
