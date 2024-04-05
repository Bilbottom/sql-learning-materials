# Pivot tables 🧮

> [!SUCCESS]
>
> One of Excel's most awesome features is [pivot tables](https://support.microsoft.com/en-gb/office/create-a-pivottable-to-analyze-worksheet-data-a9a84538-bfe9-40a9-a8e9-f99134456576) -- and SQL has them, too (at least, most flavours)!

> [!NOTE]
>
> The `ROLLUP` modifier is optional. If you use it, it must be part of the `GROUP BY` clause.

## We use the `ROLLUP` modifier to create "pivot tables"

In [the aggregations section](group-by.md), we saw that we can use the `GROUP BY` clause to group rows together and summarise them.

This is handy but, unlike Excel's pivot tables, it doesn't include subtotals and grand totals.

To tell SQL to include these totals, we use the `ROLLUP` modifier! This modifier goes immediately after the `GROUP BY` text, and the grouping columns are listed in brackets.

For example, consider the following query which produces six months of sales summaries:

```sql
SELECT
    FORMAT(OrderDate, 'yyyy-MM') AS OrderMonth,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE '2013-01-01' <= OrderDate AND OrderDate < '2013-07-01'
GROUP BY FORMAT(OrderDate, 'yyyy-MM')
ORDER BY OrderMonth
;
```

| OrderMonth |   TotalSales |
| :--------- | -----------: |
| 2013-01    | 2340061.5521 |
| 2013-02    | 2600218.8667 |
| 2013-03    | 3831605.9389 |
| 2013-04    | 2840711.1734 |
| 2013-05    | 3658084.9461 |
| 2013-06    | 5726265.2635 |

We could use `ROLLUP` to add a grand total to the results:

```sql
SELECT
    FORMAT(OrderDate, 'yyyy-MM') AS OrderMonth,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE '2013-01-01' <= OrderDate AND OrderDate < '2013-07-01'
GROUP BY ROLLUP (FORMAT(OrderDate, 'yyyy-MM'))
ORDER BY OrderMonth
;
```

| OrderMonth |    TotalSales |
| :--------- | ------------: |
| _null_     | 20996947.7407 |
| 2013-01    |  2340061.5521 |
| 2013-02    |  2600218.8667 |
| 2013-03    |  3831605.9389 |
| 2013-04    |  2840711.1734 |
| 2013-05    |  3658084.9461 |
| 2013-06    |  5726265.2635 |

Note that the `OrderMonth` column now includes a `NULL` value, which represents the grand total.

This query only groups by a single column, so there are no subtotals (only the grand total). If we were to group by multiple columns, we would see subtotals for each combination of the grouping columns.

For example, we could extend the example above (without the `ROLLUP` modifier) to also group by the `OnlineOrderFlag` column:

```sql
SELECT
    FORMAT(OrderDate, 'yyyy-MM') AS OrderMonth,
    OnlineOrderFlag,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE '2013-01-01' <= OrderDate AND OrderDate < '2013-07-01'
GROUP BY
    FORMAT(OrderDate, 'yyyy-MM'),
    OnlineOrderFlag
ORDER BY
    OrderMonth,
    OnlineOrderFlag
;
```

| OrderMonth | OnlineOrderFlag |   TotalSales |
| :--------- | :-------------- | -----------: |
| 2013-01    | false           | 1761132.8322 |
| 2013-01    | true            |  578928.7199 |
| 2013-02    | false           | 2101152.5476 |
| 2013-02    | true            |  499066.3191 |
| 2013-03    | false           | 3244501.4287 |
| 2013-03    | true            |  587104.5102 |
| 2013-04    | false           | 2239156.6675 |
| 2013-04    | true            |  601554.5059 |
| 2013-05    | false           | 3019173.6253 |
| 2013-05    | true            |  638911.3208 |
| 2013-06    | false           | 4775809.3027 |
| 2013-06    | true            |  950455.9608 |

Adding the `ROLLUP` modifier to the `GROUP BY` clause will add subtotals for the order months and a grand total:

```sql
SELECT
    FORMAT(OrderDate, 'yyyy-MM') AS OrderMonth,
    OnlineOrderFlag,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE '2013-01-01' <= OrderDate AND OrderDate < '2013-07-01'
GROUP BY ROLLUP (
    FORMAT(OrderDate, 'yyyy-MM'),
    OnlineOrderFlag
)
ORDER BY
    OrderMonth,
    OnlineOrderFlag
;
```

| OrderMonth | OnlineOrderFlag |    TotalSales |
| :--------- | :-------------- | ------------: |
| _null_     | _null_          | 20996947.7407 |
| 2013-01    | _null_          |  2340061.5521 |
| 2013-01    | false           |  1761132.8322 |
| 2013-01    | true            |   578928.7199 |
| 2013-02    | _null_          |  2600218.8667 |
| 2013-02    | false           |  2101152.5476 |
| 2013-02    | true            |   499066.3191 |
| 2013-03    | _null_          |  3831605.9389 |
| 2013-03    | false           |  3244501.4287 |
| 2013-03    | true            |   587104.5102 |
| 2013-04    | _null_          |  2840711.1734 |
| 2013-04    | false           |  2239156.6675 |
| 2013-04    | true            |   601554.5059 |
| 2013-05    | _null_          |  3658084.9461 |
| 2013-05    | false           |  3019173.6253 |
| 2013-05    | true            |   638911.3208 |
| 2013-06    | _null_          |  5726265.2635 |
| 2013-06    | false           |  4775809.3027 |
| 2013-06    | true            |   950455.9608 |

> [!WARNING]
>
> Did you notice that there were subtotals for the order months, but no subtotals for the `OnlineOrderFlag` column? This is because, like with Excel's pivot tables, the order of the columns is significant!
>
> If we switched the order of the columns in the `GROUP BY` clause, the subtotals for `OnlineOrderFlag` would be calculated but not the subtotals for the order months.
>
> The subtotals that are generated follow the same rules as Excel's pivot tables.

> [!SUCCESS]
>
> SQL has called this modifier "rollup" because it rolls up the values into subtotals and grand totals!

### There's an alternative syntax: `WITH ROLLUP`

Instead of specifying `ROLLUP` immediately after the `GROUP BY` text and listing the grouping columns in brackets, we could instead just add the text `WITH ROLLUP` after the list of columns:

```sql
SELECT
    FORMAT(OrderDate, 'yyyy-MM') AS OrderMonth,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE '2013-01-01' <= OrderDate AND OrderDate < '2013-07-01'
GROUP BY FORMAT(OrderDate, 'yyyy-MM') WITH ROLLUP
ORDER BY OrderMonth
;
```

Although this syntax is supported, it's not the standard syntax to use and is only included for backwards compatibility.

You should stick to the standard syntax of adding `ROLLUP` immediately after the `GROUP BY` text and listing the grouping columns in brackets.

## Further reading

Check out the [official Microsoft documentation](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-group-by-transact-sql#group-by-rollup) for more information on `ROLLUP` at:

- [https://learn.microsoft.com/en-us/sql/t-sql/queries/select-group-by-transact-sql#group-by-rollup](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-group-by-transact-sql#group-by-rollup)

The video version of this content is also available at:

- [https://youtu.be/65EFEtjYL9E](https://youtu.be/65EFEtjYL9E)

### Additional grouping functions

There are additional functions which are outside the scope of this course to distinguish between `NULL` values generated by the subtotals/grand totals and `NULL` values that are in the original data.

They are the `GROUPING` and `GROUPING_ID` functions which help identify which rows correspond to different levels of the `ROLLUP` hierarchy:

- [https://learn.microsoft.com/en-us/sql/t-sql/functions/grouping-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/functions/grouping-transact-sql)
- [https://learn.microsoft.com/en-us/sql/t-sql/functions/grouping-id-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/functions/grouping-id-transact-sql)

> [!ERROR]
>
> This is a contrived example to show the additional grouping functions.
>
> ```sql
> SELECT
>     GROUPING(FORMAT(OrderDate, 'yyyy-MM')) AS IsOrderDateSubtotal,
>     GROUPING(OnlineOrderFlag) AS IsOnlineOrderFlagSubtotal,
>     GROUPING_ID(FORMAT(OrderDate, 'yyyy-MM'), OnlineOrderFlag) AS GroupingId,
>
>     FORMAT(OrderDate, 'yyyy-MM') AS OrderMonth,
>     OnlineOrderFlag,
>     SUM(TotalDue) AS TotalSales
> FROM Sales.SalesOrderHeader
> WHERE '2013-01-01' <= OrderDate AND OrderDate < '2013-07-01'
> GROUP BY ROLLUP (
>     FORMAT(OrderDate, 'yyyy-MM'),
>     OnlineOrderFlag
> )
> ORDER BY
>     OrderMonth,
>     OnlineOrderFlag
> ;
> ```
