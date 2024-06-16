# Temperature anomaly detection 🔍

> [!SUCCESS] Scenario
>
> Some scientists are studying temperature data from various sites.
>
> They are interested in identifying temperature readings that are significantly higher than the surrounding readings.

> [!QUESTION]
>
> Given the temperature data below, select the temperature readings that are at least 10% higher than the average of the previous 2 and following 2 readings for the same site.
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
>? INFO: **Sample input**
>
> | site_id | reading_datetime    | temperature |
> |--------:|:--------------------|------------:|
> |       1 | 2021-06-01 02:12:31 |       26.17 |
> |       1 | 2021-06-01 21:17:12 |       26.32 |
> |       1 | 2021-06-02 01:19:56 |       29.58 |
> |       1 | 2021-06-02 19:35:32 |       27.06 |
> |       1 | 2021-06-03 03:14:53 |       26.26 |
> |       1 | 2021-06-03 20:47:42 |       28.37 |
>
--8<-- "docs/challenging-sql-problems/problems/bronze/temperature-anomaly-detection--sample-input.sql"

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> | site_id | reading_datetime    | temperature | average_temperature | percentage_increase |
> |--------:|:--------------------|------------:|--------------------:|--------------------:|
> |       1 | 2021-06-02 01:19:56 |       29.58 |             26.4525 |             11.8231 |
>
--8<-- "docs/challenging-sql-problems/problems/bronze/temperature-anomaly-detection--sample-output.sql"

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> Use a [window function](../../../from-excel-to-sql/main-concepts/window-functions.md) (or two!) to calculate the average temperature of the surrounding readings.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> Use another [window function](../../../from-excel-to-sql/main-concepts/window-functions.md) to identify rows with at least 4 surrounding readings (2 before and 2 after).
