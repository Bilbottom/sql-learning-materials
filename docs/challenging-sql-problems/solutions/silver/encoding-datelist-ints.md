# Encoding datelist ints 🔐

> [!TIP]
>
> Solution to the following problem:
>
> - [encoding-datelist-ints.md](../../problems/silver/encoding-datelist-ints.md)

## Result Set

Regardless of the database, the result set should look like:

| user_id | last_update | activity_history |
| ------: | :---------- | ---------------: |
|       1 | 2024-01-26  |         41943064 |
|       2 | 2024-01-26  |         14694414 |
|       3 | 2024-01-26  |          3210303 |

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/solutions/silver/encoding-datelist-ints.sql"
</details>

## Solution

Some SQL solutions per database are provided below.

<!-- prettier-ignore -->
> SUCCESS: **DuckDB**
>
--8<-- "docs/challenging-sql-problems/solutions/silver/encoding-datelist-ints--duckdb.sql"
