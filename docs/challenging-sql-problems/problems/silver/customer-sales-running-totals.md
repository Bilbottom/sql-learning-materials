# Customer sales running totals 📈

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

However, you should calculate this yourself (don't just copy the above values).

The solution can be found at:

- [customer-sales-running-totals.md](../../solutions/silver/customer-sales-running-totals.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> | BalanceDate | CustomerID | RunningTotal |
> |:------------|-----------:|-------------:|
> | 2014-06-01  |      11091 |    1243.5234 |
> | 2014-06-01  |      11176 |    1222.8820 |
> | 2014-06-01  |      11287 |    1115.2109 |
> | 2014-06-02  |      11091 |    1243.5234 |
> | 2014-06-02  |      11176 |    1222.8820 |
> | 2014-06-02  |      11287 |    1115.2109 |
> | 2014-06-03  |      11091 |    1243.5234 |
> | 2014-06-03  |      11176 |    1222.8820 |
> | 2014-06-03  |      11287 |    1115.2109 |
> | ...         |        ... |          ... |

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> Use a [recursive CTE](../../../from-excel-to-sql/advanced-concepts/recursive-ctes.md) (or equivalent) to generate the June 2014 date axis, and then join the customers' sales to it.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> Use the `SUM` function with [the `OVER` clause](../../../from-excel-to-sql/main-concepts/window-functions.md) to calculate the running total.
