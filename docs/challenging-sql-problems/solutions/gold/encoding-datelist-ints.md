# Encoding datelist ints 🔐

> [!TIP]
>
> Solution to the following problem:
>
> - [encoding-datelist-ints.md](../../problems/gold/encoding-datelist-ints.md)

## Result Set

Regardless of the database, the result set should look like:

| user_id | last_update | activity_history |
| ------: | :---------- | ---------------: |
|       1 | 2024-02-01  |       2684356096 |
|       2 | 2024-02-01  |        940442496 |
|       3 | 2024-02-01  |        204672192 |

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/solutions/gold/encoding-datelist-ints.sql"
</details>

## Solution

Some SQL solutions per database are provided below.

<!-- prettier-ignore -->
> SUCCESS: **DuckDB**
>
--8<-- "docs/challenging-sql-problems/solutions/gold/encoding-datelist-ints--duckdb.sql"
