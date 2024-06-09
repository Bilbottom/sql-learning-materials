# Travel plans 🚂

> [!TIP]
>
> Solution to the following problem:
>
> - [travel-plans.md](../../problems/gold/travel-plans.md)

## Result Set

Regardless of the database, the result set should look like:

| route                                                 | departure_datetime_utc | arrival_datetime_utc | duration |   cost |
| :---------------------------------------------------- | :--------------------- | :------------------- | :------- | -----: |
| New York - London Gatwick - London St Pancras - Paris | 2024-01-01 18:00:00    | 2024-01-02 14:30:00  | 20:30:00 | 212.00 |
| New York - Paris                                      | 2024-01-01 23:00:00    | 2024-01-02 16:45:00  | 17:45:00 | 279.00 |

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/solutions/gold/travel-plans.sql"
</details>

## Solution

Some SQL solutions per database are provided below.

<!-- prettier-ignore -->
> SUCCESS: **DuckDB**
>
> There's probably a better way to do this. Please let me know if you find it!
>
--8<-- "docs/challenging-sql-problems/solutions/gold/travel-plans--duckdb.sql"
