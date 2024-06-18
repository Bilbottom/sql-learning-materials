# Customer sales running totals 📈

> [!SUCCESS] Scenario
>
> A retail company is interested in understanding the sales performance of some specific customers throughout June 2014.

> [!QUESTION]
>
> Using _only_ the `Sales.SalesOrderHeader` table in the [AdventureWorks](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure) database, calculate the running total of `TotalDue` per customer for the customers with `CustomerID` values of `11176`, `11091`, and `11287`.
>
> The output should have a row per customer for each day in June 2014, but the running totals should include all the historic sales for the customers.
>
> The output should have 90 rows (30 days in June for 3 customers) and the columns:
>
> - `BalanceDate` as the date that the end-of-day balance corresponds to
> - `CustomerID`
> - `RunningTotal` as the sum of the `TotalDue` values up to and including the `BalanceDate`
>
> Order the output by `BalanceDate` and `CustomerID`.

> [!NOTE]
>
> You can access this table on the [db<>fiddle](https://dbfiddle.uk/8VEWSCRd) website at:
>
> - [https://dbfiddle.uk/8VEWSCRd](https://dbfiddle.uk/8VEWSCRd)

Since the rows corresponding to 2014-06-01 should include the historic sales, the rows for 2014-06-01 should be:

| BalanceDate | CustomerID | RunningTotal |
| :---------- | ---------: | -----------: |
| 2014-06-01  |      11091 |    1243.5234 |
| 2014-06-01  |      11176 |    1222.8820 |
| 2014-06-01  |      11287 |    1115.2109 |

However, you should calculate this yourself (don't copy the above values).

The solution can be found at:

- [customer-sales-running-totals.md](../../solutions/silver/customer-sales-running-totals.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample input**
>
> | CustomerID | OrderDate           |   TotalDue |
> |-----------:|:--------------------|-----------:|
> |          1 | 2014-03-14 00:00:00 | 23153.2339 |
> |          1 | 2014-04-16 00:00:00 |  1457.3288 |
> |          1 | 2014-04-21 00:00:00 | 36865.8012 |
> |          1 | 2014-05-12 00:00:00 | 32474.9324 |
> |          1 | 2014-05-04 00:00:00 |   472.3108 |
> |          1 | 2014-06-03 00:00:00 | 27510.4109 |
> |          1 | 2014-06-08 00:00:00 | 16158.6961 |
> |          1 | 2014-06-16 00:00:00 |  5694.8564 |
> |          1 | 2014-06-21 00:00:00 |  6876.3649 |
> |          1 | 2014-06-28 00:00:00 | 40487.7233 |
>
--8<-- "docs/challenging-sql-problems/problems/silver/customer-sales-running-totals--sample-input.sql"

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> | BalanceDate | CustomerID | RunningTotal |
> |:------------|-----------:|-------------:|
> | 2014-06-01  |          1 |   94423.6071 |
> | 2014-06-02  |          1 |   94423.6071 |
> | 2014-06-03  |          1 |  121934.0180 |
> | 2014-06-04  |          1 |  121934.0180 |
> | 2014-06-05  |          1 |  121934.0180 |
> | 2014-06-06  |          1 |  121934.0180 |
> | 2014-06-07  |          1 |  121934.0180 |
> | 2014-06-08  |          1 |  138092.7141 |
> | 2014-06-09  |          1 |  138092.7141 |
> | 2014-06-10  |          1 |  138092.7141 |
> | 2014-06-11  |          1 |  138092.7141 |
> | 2014-06-12  |          1 |  138092.7141 |
> | 2014-06-13  |          1 |  138092.7141 |
> | 2014-06-14  |          1 |  138092.7141 |
> | 2014-06-15  |          1 |  138092.7141 |
> | 2014-06-16  |          1 |  143787.5705 |
> | 2014-06-17  |          1 |  143787.5705 |
> | 2014-06-18  |          1 |  143787.5705 |
> | 2014-06-19  |          1 |  143787.5705 |
> | 2014-06-20  |          1 |  143787.5705 |
> | 2014-06-21  |          1 |  150663.9354 |
> | 2014-06-22  |          1 |  150663.9354 |
> | 2014-06-23  |          1 |  150663.9354 |
> | 2014-06-24  |          1 |  150663.9354 |
> | 2014-06-25  |          1 |  150663.9354 |
> | 2014-06-26  |          1 |  150663.9354 |
> | 2014-06-27  |          1 |  150663.9354 |
> | 2014-06-28  |          1 |  191151.6587 |
> | 2014-06-29  |          1 |  191151.6587 |
> | 2014-06-30  |          1 |  191151.6587 |
>
--8<-- "docs/challenging-sql-problems/problems/silver/customer-sales-running-totals--sample-output.sql"

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> Use a [recursive CTE](../../../from-excel-to-sql/advanced-concepts/recursive-ctes.md) (or equivalent) to generate the June 2014 date axis, and then join the customers' sales to it.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> Use the `SUM` function with [the `OVER` clause](../../../from-excel-to-sql/main-concepts/window-functions.md) to calculate the running total.
