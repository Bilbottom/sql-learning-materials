# Temperature anomaly detection 🔍

> [!TIP]
>
> Solution to the following problem:
>
> - [temperature-anomaly-detection.md](../../problems/bronze/temperature-anomaly-detection.md)

## Result Set

Regardless of the database, the result set should look like:

| site_id | reading_datetime    | temperature | average_temperature | percentage_increase |
| ------: | :------------------ | ----------: | ------------------: | ------------------: |
|       1 | 2021-01-02 02:01:17 |       22.43 |             20.0525 |             11.8564 |
|       1 | 2021-01-04 21:45:34 |       22.69 |             20.2700 |             11.9388 |
|       2 | 2021-01-02 01:59:43 |       23.10 |             20.6050 |             12.1087 |

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/solutions/bronze/temperature-anomaly-detection.sql"
</details>

## Solution

Some SQL solutions per database are provided below.

<!-- prettier-ignore -->
> SUCCESS: **DuckDB**
>
--8<-- "docs/challenging-sql-problems/solutions/bronze/temperature-anomaly-detection--duckdb.sql"

<!-- prettier-ignore -->
> SUCCESS: **SQLite, PostgreSQL**
>
--8<-- "docs/challenging-sql-problems/solutions/bronze/temperature-anomaly-detection--sqlite.sql"

<!-- prettier-ignore -->
> SUCCESS: **Snowflake**
>
--8<-- "docs/challenging-sql-problems/solutions/bronze/temperature-anomaly-detection--snowflake.sql"

<!-- prettier-ignore -->
> SUCCESS: **SQL Server**
>
--8<-- "docs/challenging-sql-problems/solutions/bronze/temperature-anomaly-detection--sql-server.sql"
