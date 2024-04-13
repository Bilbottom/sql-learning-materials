# UK bank holidays 📅

> [!TIP]
>
> Solution to the following problem:
>
> - [uk-bank-holidays.md](../../problems/bronze/uk-bank-holidays.md)

## Result Set

A reduced result set (as at 2024-04-13) should look like:

| division          | title                  | date       | notes | bunting |
| :---------------- | :--------------------- | :--------- | :---- | :------ |
| england-and-wales | New Year’s Day         | 2018-01-01 |       | true    |
| england-and-wales | Good Friday            | 2018-03-30 |       | false   |
| england-and-wales | Easter Monday          | 2018-04-02 |       | true    |
| england-and-wales | Early May bank holiday | 2018-05-07 |       | true    |
| england-and-wales | Spring bank holiday    | 2018-05-28 |       | true    |
| england-and-wales | Summer bank holiday    | 2018-08-27 |       | true    |
| england-and-wales | Christmas Day          | 2018-12-25 |       | true    |
| england-and-wales | Boxing Day             | 2018-12-26 |       | true    |
| england-and-wales | New Year’s Day         | 2019-01-01 |       | true    |
| ...               | ...                    | ...        | ...   | ...     |

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/solutions/bronze/uk-bank-holidays.sql"
</details>

## Solution

The solution for DuckDB is provided below.

<!-- prettier-ignore -->
> SUCCESS: **DuckDB**
>
--8<-- "docs/challenging-sql-problems/solutions/bronze/uk-bank-holidays--duckdb.sql"
