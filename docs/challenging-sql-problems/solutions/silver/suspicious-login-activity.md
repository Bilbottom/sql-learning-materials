# Suspicious login activity 🤔

> [!TIP]
>
> Solution to the following problem:
>
> - [suspicious-login-activity.md](../../problems/silver/suspicious-login-activity.md)

## Result Set

Regardless of the database, the result set should look like:

| user_id | consecutive_failures |
| ------: | -------------------: |
|       1 |                    7 |
|       3 |                    8 |

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/solutions/silver/suspicious-login-activity.sql"
</details>

## Solution

Some SQL solutions per database are provided below.

<!-- prettier-ignore -->
> SUCCESS: **DuckDB**
>
--8<-- "docs/challenging-sql-problems/solutions/silver/suspicious-login-activity--duckdb.sql"

<!-- prettier-ignore -->
> SUCCESS: **SQL Server**
>
--8<-- "docs/challenging-sql-problems/solutions/silver/suspicious-login-activity--sql-server.sql"
