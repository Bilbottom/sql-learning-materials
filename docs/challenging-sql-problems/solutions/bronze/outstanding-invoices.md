# Outstanding invoices 💱

> [!TIP]
>
> Solution to the following problem:
>
> - [outstanding-invoices.md](../../problems/bronze/outstanding-invoices.md)

## Result Set

Regardless of the database, the result set should look like:

| invoice_currency | amount_outstanding |
| :--------------- | -----------------: |
| GBP              |           59184.66 |
| INR              |          852086.90 |
| USD              |           11219.50 |

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/solutions/bronze/outstanding-invoices.sql"
</details>

## Solution

Some SQL solutions per database are provided below.

<!-- prettier-ignore -->
> SUCCESS: **DuckDB**
>
--8<-- "docs/challenging-sql-problems/solutions/bronze/outstanding-invoices--duckdb.sql"
