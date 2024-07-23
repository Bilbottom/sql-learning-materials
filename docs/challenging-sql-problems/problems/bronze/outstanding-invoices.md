---
hide:
  - tags
tags:
  - asof join
---

# Outstanding invoices 💱

> [!SUCCESS] Scenario
>
> A consulting firm, based in the US, works with clients all over the world.
>
> They invoice their clients in USD and are interested in the total amount outstanding in each local currency.

> [!QUESTION]
>
> Calculate the total amount outstanding (`is_paid = false`) in each local currency for the invoices in the `invoices` table.
>
> Use the `exchange_rates` table to convert the invoice amount (USD) to the local currency, using the latest exchange rate at the time of the invoice.
>
> The output should have a row per `invoice_currency` with the columns:
>
> - `invoice_currency`
> - `amount_outstanding` as the total amount outstanding in the local currency, _rounded up_ to two decimal places
>
> Order the output by `invoice_currency`.

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/bronze/outstanding-invoices.sql"
</details>

The solution can be found at:

- [outstanding-invoices.md](../../solutions/bronze/outstanding-invoices.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample input**
>
> **Invoices**
>
> | invoice_id | invoice_datetime    | invoice_amount_usd | is_paid | invoice_currency |
> |-----------:|:--------------------|-------------------:|:--------|:-----------------|
> |          1 | 2024-06-03 11:52:01 |             100.00 | true    | USD              |
> |          2 | 2024-06-04 01:11:52 |             200.00 | false   | INR              |
> |          3 | 2024-06-17 21:01:29 |             300.00 | false   | USD              |
> |          4 | 2024-06-18 00:12:50 |             499.00 | false   | GBP              |
>
> **Exchange Rates**
>
> | from_datetime       | from_currency | to_currency |    rate |
> |:--------------------|:--------------|:------------|--------:|
> | 2024-06-02 00:45:52 | USD           | GBP         |  0.7808 |
> | 2024-06-02 04:59:57 | USD           | INR         | 83.0830 |
> | 2024-06-14 03:35:27 | USD           | GBP         |  0.7880 |
> | 2024-06-14 07:49:32 | USD           | INR         | 83.5470 |
> | 2024-06-17 23:21:22 | USD           | GBP         |  0.7870 |
> | 2024-06-28 21:56:52 | USD           | GBP         |  0.7909 |
> | 2024-06-29 17:42:47 | USD           | INR         | 83.5680 |
>
--8<-- "docs/challenging-sql-problems/problems/bronze/outstanding-invoices--sample-input.sql"

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> | invoice_currency | amount_outstanding |
> |:-----------------|-------------------:|
> | GBP              |             392.72 |
> | INR              |           16616.60 |
> | USD              |             300.00 |
>
--8<-- "docs/challenging-sql-problems/problems/bronze/outstanding-invoices--sample-output.sql"

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> For databases that support it, use [an `ASOF` join](../../../everything-about-joins/syntax/timestamp-joins.md) to use the latest exchange rate for each invoice (as of the time of the invoice).
>
> For databases that don't support `ASOF` joins, use any other method to get the exchange rates for each invoice, such as a correlated subquery.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> Use the `CEIL` function (or equivalent) with the value to round multiplied by 100, then divide by 100 to round up to two decimal places.
