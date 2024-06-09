# Bannable login activity ❌

> [!TIP]
>
> Solution to the following problem:
>
> - [bannable-login-activity.md](../../problems/silver/bannable-login-activity.md)

## Result Set

Regardless of the database, the result set should look like:

| user_id |   ban_date |
| :------ | ---------: |
| 3       | 2024-02-01 |

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/solutions/silver/bannable-login-activity.sql"
</details>

## Solution

Some SQL solutions per database are provided below.

<!-- prettier-ignore -->
> SUCCESS: **DuckDB**
>
--8<-- "docs/challenging-sql-problems/solutions/silver/bannable-login-activity--duckdb.sql"

<!-- prettier-ignore -->
> SUCCESS: **SQL Server**
>
--8<-- "docs/challenging-sql-problems/solutions/silver/bannable-login-activity--sql-server.sql"
