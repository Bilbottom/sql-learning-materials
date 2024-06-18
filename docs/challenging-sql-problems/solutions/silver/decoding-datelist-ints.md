# Decoding datelist ints 🔐

> [!TIP]
>
> Solution to the following problem:
>
> - [decoding-datelist-ints.md](../../problems/silver/decoding-datelist-ints.md)

## Result Set

Regardless of the database, the result set should look like:

| active_date | user_1 | user_2 | user_3 | user_4 | user_5 | user_6 |
| :---------- | :----- | :----- | :----- | :----- | :----- | :----- |
| 2024-05-03  | 0      | 1      | 0      | 0      | 0      | 0      |
| 2024-05-04  | 0      | 1      | 0      | 0      | 0      | 1      |
| 2024-05-05  | 0      | 0      | 1      | 0      | 1      | 1      |
| 2024-05-06  | 0      | 1      | 1      | 0      | 1      | 1      |
| 2024-05-07  | 0      | 1      | 0      | 0      | 1      | 0      |
| 2024-05-08  | 0      | 0      | 0      | 0      | 0      | 1      |
| 2024-05-09  | 0      | 0      | 0      | 1      | 1      | 0      |
| 2024-05-10  | 0      | 0      | 0      | 0      | 0      | 1      |
| 2024-05-11  | 0      | 0      | 0      | 0      | 1      | 0      |
| 2024-05-12  | 1      | 1      | 0      | 1      | 0      | 1      |
| 2024-05-13  | 0      | 0      | 0      | 0      | 1      | 1      |
| 2024-05-14  | 0      | 1      | 0      | 1      | 1      | 1      |
| 2024-05-15  | 0      | 0      | 0      | 0      | 0      | 0      |
| 2024-05-16  | 0      | 0      | 0      | 1      | 1      | 1      |
| 2024-05-17  | 0      | 0      | 0      | 0      | 0      | 0      |
| 2024-05-18  | 0      | 0      | 0      | 0      | 1      | 1      |
| 2024-05-19  | 0      | 1      | 1      | 0      | 1      | 1      |
| 2024-05-20  | 1      | 0      | 0      | 1      | 1      | 0      |
| 2024-05-21  | 1      | 0      | 0      | 0      | 0      | 1      |
| 2024-05-22  | 1      | 0      | 0      | 0      | 0      | 0      |
| 2024-05-23  | 1      | 1      | 0      | 0      | 0      | 0      |
| 2024-05-24  | 0      | 1      | 0      | 1      | 0      | 0      |
| 2024-05-25  | 0      | 0      | 1      | 0      | 0      | 1      |
| 2024-05-26  | 0      | 0      | 1      | 1      | 1      | 1      |
| 2024-05-27  | 0      | 0      | 1      | 1      | 0      | 1      |
| 2024-05-28  | 0      | 1      | 1      | 0      | 1      | 1      |
| 2024-05-29  | 0      | 1      | 1      | 0      | 0      | 0      |
| 2024-05-30  | 0      | 0      | 0      | 0      | 1      | 1      |
| 2024-05-31  | 0      | 0      | 0      | 0      | 1      | 1      |
| 2024-06-01  | 0      | 0      | 0      | 0      | 0      | 1      |

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/solutions/silver/decoding-datelist-ints.sql"
</details>

## Solution

Some SQL solutions per database are provided below.

<!-- prettier-ignore -->
> SUCCESS: **DuckDB**
>
--8<-- "docs/challenging-sql-problems/solutions/silver/decoding-datelist-ints--duckdb.sql"
