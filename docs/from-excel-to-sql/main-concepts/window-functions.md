# Window functions 📈

> [!SUCCESS]
>
> Windows functions allow us to summarise rows _without_ having to use the `GROUP BY` clause.
>
> There are two ways to use window functions, and we'll see that both are very similar to row aggregations that we do in Excel!

> [!WARNING]
>
> Window functions are widely regarded as an advanced concept in SQL. Hopefully this page will show that they're not as scary as people make them seem!

## Window functions are another way to summarise rows

We saw in [the aggregations section](group-by.md) that we can use the `GROUP BY` clause to summarise rows. An important result of this is that _the number of rows is reduced_.

However, there are times when we want to summarise rows _without_ reducing the number of rows; that is, without having to use `GROUP BY`.

This is where window functions come in: they summarise rows _without_ reducing the row count.

There are three extremely common use cases for window functions:

- Summarising entire columns
- Calculating running totals
- Calculating moving averages

I'll bet you've done these in Excel before! 😝

### There's some terminology to be aware of

> [!INFO]
>
> Although we've been throwing around the term "window function", the actual SQL feature that we use to achieve this is the `OVER` clause.

Before going into an example, there's a bit of terminology to clarify.

_Window functions_ are functions that can be used with the `OVER` clause, such as:

- [`ROW_NUMBER`](https://learn.microsoft.com/en-us/sql/t-sql/functions/row-number-transact-sql)
- [`LAG`](https://learn.microsoft.com/en-us/sql/t-sql/functions/lag-transact-sql)
- [`FIRST_VALUE`](https://learn.microsoft.com/en-us/sql/t-sql/functions/first-value-transact-sql)

The "aggregate functions" we've seen so far (like `SUM`, `AVG`, `COUNT`, etc.) are designed to be used with the `GROUP BY` clause, but many of them can also be used with the `OVER` clause. This means that these aggregate functions are _also_ window functions!

### The `OVER` clause is the key to window functions

So... how do we use window functions?

Since window functions don't reduce the number of rows, we use them in the `SELECT` clause to add a new column to the result set just like we would if we were doing any other kind of column calculation.

Specifically, we write the window function followed by the `OVER` clause, which is followed by a set of parentheses. Inside the parentheses, we can specify the _window_ over which we want to perform the calculation.

The following example shows how to get the count of rows in the `Person.Person` table alongside showing the first few rows and columns:

```sql
SELECT TOP 5
    BusinessEntityID,
    FirstName,
    LastName,
    COUNT(*) OVER () AS TotalRows
FROM Person.Person
ORDER BY BusinessEntityID
;
```

| BusinessEntityID | FirstName | LastName   | TotalRows |
| ---------------: | :-------- | :--------- | --------: |
|                1 | Ken       | Sánchez    |     19972 |
|                2 | Terri     | Duffy      |     19972 |
|                3 | Roberto   | Tamburello |     19972 |
|                4 | Rob       | Walters    |     19972 |
|                5 | Gail      | Erickson   |     19972 |

The parentheses after `OVER` are important (even if they're empty). We'll go through what goes inside the parentheses shortly.

To confirm that the `TotalRows` number is correct, we can verify it with a separate query:

```sql
SELECT COUNT(*) AS TotalRows
FROM Person.Person
;
```

| TotalRows |
| --------: |
|     19972 |

Looks good!

> [!WARNING]
>
> We used the `TOP 5` in the query with the window function to limit the number of rows returned, so why did we get 19972 instead of 5?
>
> This is to do with the order that SQL processes the query, which is (briefly) covered in [the logical processing order section](logical-processing-order.md) -- `TOP` is processed _after_ `OVER`!

### Converting a subquery to a window function

Remember the example below from [the subqueries section](subqueries.md)?

```sql
SELECT TOP 5
    SalesOrderID,
    OrderDate,
    TotalDue,
    (
        SELECT AVG(TotalDue)
        FROM Sales.SalesOrderHeader
    ) AS AverageTotalDue
FROM Sales.SalesOrderHeader
;
```

We can rewrite this example to use `AVG` with `OVER` instead of the subquery:

```sql
SELECT TOP 5
    SalesOrderID,
    OrderDate,
    TotalDue,
    AVG(TotalDue) OVER () AS AverageTotalDue
FROM Sales.SalesOrderHeader
;
```

> [!TIP]
>
> We've just seen that two very different features -- subqueries and window functions -- can be used to achieve the same result. The natural question is: which one should you use?
>
> The answer is: it depends on the situation. However, my personal preference is to use window functions over subqueries until I have a reason not to.

## Defining the partition of a window function

The examples above just specify `OVER` with empty parentheses. This is the simplest form of the `OVER` clause, and it means that the window function is applied to _all_ rows in the result set.

The output that this produces is equivalent to summarising the entire column, which was proven in the first example by comparing the `TotalRows` column to the count of rows in the table.

However, just like how we can `GROUP BY` specific columns, we can also specify a _window_ over specific columns. We do this by writing `PARTITION BY` inside the parentheses of the `OVER` clause, followed by the column(s) that we want to partition by. Although we write `PARTITION BY`, this is just like doing `GROUP BY`!

The following example shows how to get the count of rows in the `Person.Person` table partitioned by the `EmailPromotion` column:

```sql
SELECT TOP 10
    BusinessEntityID,
    FirstName,
    LastName,
    EmailPromotion,
    COUNT(*) OVER (PARTITION BY EmailPromotion) AS TotalRowsPerEmailPromotion
FROM Person.Person
ORDER BY BusinessEntityID
;
```

| BusinessEntityID | FirstName | LastName   | EmailPromotion | TotalRowsPerEmailPromotion |
| ---------------: | :-------- | :--------- | -------------: | -------------------------: |
|                1 | Ken       | Sánchez    |              0 |                      11158 |
|                2 | Terri     | Duffy      |              1 |                       5044 |
|                3 | Roberto   | Tamburello |              0 |                      11158 |
|                4 | Rob       | Walters    |              0 |                      11158 |
|                5 | Gail      | Erickson   |              0 |                      11158 |
|                6 | Jossef    | Goldberg   |              0 |                      11158 |
|                7 | Dylan     | Miller     |              2 |                       3770 |
|                8 | Diane     | Margheim   |              0 |                      11158 |
|                9 | Gigi      | Matthew    |              0 |                      11158 |
|               10 | Michael   | Raheem     |              2 |                       3770 |

Notice that the `TotalRowsPerEmailPromotion` column shows the count of rows for each `EmailPromotion` value, and it just repeats that count for each row with the same `EmailPromotion` value. This is precisely why using `PARTITION BY` is like using `GROUP BY` -- it does the grouping just like it would if we were using `GROUP BY`, but it doesn't reduce the number of rows!

> [!TIP]
>
> When we use `PARTITION BY` in a window function, we're splitting the result set into _partitions_ based on the column(s) that we specify. The window function is then applied to each partition separately.

> [!SUCCESS]
>
> When we create partitions, this is like using Excel's "IF" summary functions over an entire column, such as `=SUMIF(A:A, A2)`.

## There are two other ways to use window functions

The examples above show how to use window functions over different partitions (including a single partition, the entire table).

Other window functions are designed to be used with the rows considered in some order, so we can also specify `ORDER BY` inside the parentheses of the `OVER` clause.

A great example of this is the `LAG` function which looks "one row up" based on the order that we specify. For example, the following query shows the first few people in the `Person.Person` table with the first names of the person who came before them (based on the `BusinessEntityID` column):

```sql
SELECT TOP 5
    BusinessEntityID,
    FirstName,
    LastName,
    LAG(FirstName) OVER (ORDER BY BusinessEntityID) AS PreviousFirstName
FROM Person.Person
ORDER BY BusinessEntityID
;
```

| BusinessEntityID | FirstName | LastName   | PreviousFirstName |
| ---------------: | :-------- | :--------- | :---------------- |
|                1 | Ken       | Sánchez    | _null_            |
|                2 | Terri     | Duffy      | Ken               |
|                3 | Roberto   | Tamburello | Terri             |
|                4 | Rob       | Walters    | Roberto           |
|                5 | Gail      | Erickson   | Rob               |

This is just like using a relative cell reference in Excel!

Although this isn't a super helpful example, this demonstrates a case where we need to tell SQL which order to use to understand "previous" and "next" rows. There are technical reasons for it that we won't go into, but SQL will _not_ assume any order unless we specify it.

With this in mind, there are two types of windows that we can specify:

- Cumulative windows, which are things like "all rows up to this one" and are useful for calculating running totals
- Sliding windows, which are things like "the last three rows" and are useful for calculating moving averages

### Cumulative windows are great for running totals

One of the most common things to do in Excel is to calculate running totals.

We can do this in SQL too by using `SUM` with the `OVER` clause, making sure that we specify a row order:

```sql
SELECT TOP 10
    SalesOrderID,
    TotalDue,
    SUM(TotalDue) OVER (ORDER BY SalesOrderID) AS RunningTotal
FROM Sales.SalesOrderHeader
ORDER BY SalesOrderID
;
```

| SalesOrderID |   TotalDue | RunningTotal |
| -----------: | ---------: | -----------: |
|        43659 | 23153.2339 |   23153.2339 |
|        43660 |  1457.3288 |   24610.5627 |
|        43661 | 36865.8012 |   61476.3639 |
|        43662 | 32474.9324 |   93951.2963 |
|        43663 |   472.3108 |   94423.6071 |
|        43664 | 27510.4109 |  121934.0180 |
|        43665 | 16158.6961 |  138092.7141 |
|        43666 |  5694.8564 |  143787.5705 |
|        43667 |  6876.3649 |  150663.9354 |
|        43668 | 40487.7233 |  191151.6587 |

There are a few ways that you could do this in Excel. The SQL approach is just like using the formula `=SUM($B$2:B2)` in cell `C2` and dragging it down (assuming that the `TotalDue` column is in column `B` and the `RunningTotal` column is in column `C`).

In contrast, if we _didn't_ specify `ORDER BY` inside the parentheses of the `OVER` clause, the `SUM` would be calculated over the entire table:

```sql
SELECT TOP 10
    SalesOrderID,
    TotalDue,
    SUM(TotalDue) OVER () AS RunningTotal  /* This is now a misnomer */
FROM Sales.SalesOrderHeader
ORDER BY SalesOrderID
;
```

| SalesOrderID |   TotalDue |   RunningTotal |
| -----------: | ---------: | -------------: |
|        43659 | 23153.2339 | 123216786.1159 |
|        43660 |  1457.3288 | 123216786.1159 |
|        43661 | 36865.8012 | 123216786.1159 |
|        43662 | 32474.9324 | 123216786.1159 |
|        43663 |   472.3108 | 123216786.1159 |
|        43664 | 27510.4109 | 123216786.1159 |
|        43665 | 16158.6961 | 123216786.1159 |
|        43666 |  5694.8564 | 123216786.1159 |
|        43667 |  6876.3649 | 123216786.1159 |
|        43668 | 40487.7233 | 123216786.1159 |

This is quite a different result!

### Sliding windows are great for moving averages

Another common thing to do in Excel is to calculate moving averages.

We can do this in SQL too by using `AVG` with the `OVER` clause, making sure that we specify a row order _and a window size_. The "window size" is some more new syntax, so let's go through an example to see how it works.

The following query shows the first few orders in the `Sales.SalesOrderHeader` table with the moving average of the `TotalDue` column over the last three orders (based on the `SalesOrderID` column):

```sql
SELECT TOP 10
    SalesOrderID,
    TotalDue,
    AVG(TotalDue) OVER (
        ORDER BY SalesOrderID
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS MovingAverage
FROM Sales.SalesOrderHeader
ORDER BY SalesOrderID
;
```

| SalesOrderID |   TotalDue | MovingAverage |
| -----------: | ---------: | ------------: |
|        43659 | 23153.2339 |    23153.2339 |
|        43660 |  1457.3288 |    12305.2813 |
|        43661 | 36865.8012 |    20492.1213 |
|        43662 | 32474.9324 |    23599.3541 |
|        43663 |   472.3108 |    23271.0148 |
|        43664 | 27510.4109 |    20152.5513 |
|        43665 | 16158.6961 |    14713.8059 |
|        43666 |  5694.8564 |    16454.6544 |
|        43667 |  6876.3649 |     9576.6391 |
|        43668 | 40487.7233 |    17686.3148 |

To compare this to Excel, this is just like using the formula `=AVERAGE(B2:B4)` in cell `C4` and dragging it down (assuming that the `TotalDue` column is in column `B` and the `MovingAverage` column is in column `C`).

To define the sliding window (the window size), we wrote:

```sql
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
```

This sounds a bit funny, but should be fairly intuitive:

- The `ROWS BETWEEN` tells SQL that we're going to define a window based on the number of rows
- The `2 PRECEDING` means "two rows _before_ the current row"
- The `CURRENT ROW` part is clear and means "the current row" 😝

Altogether, this means "the last three rows".

We could also look a few rows _after_ the current row by using `FOLLOWING` instead of `PRECEDING`; the following window would be "the current row and the next two rows":

```sql
ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
```

In fact, we can also specify the cumulative window that we saw earlier by using `UNBOUNDED PRECEDING` (this is the default window size):

```sql
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
```

> [!WARNING]
>
> The syntax for defining window functions is actually very flexible, and there are a few different ways to specify the window. The examples above are just the most common ways to do it to keep things simple for this course.

## Define common windows with the `WINDOW` clause

If you find yourself using the same window definition in multiple places of the same statement, you can define it once in the `WINDOW` clause and then reference it by name:

```sql
SELECT TOP 10
    SalesOrderID,
    AVG(SubTotal) OVER LastThreeSalesOrderIDs AS SubTotalMovingAverage,
    AVG(TaxAmt) OVER LastThreeSalesOrderIDs AS TaxAmtMovingAverage,
    AVG(Freight) OVER LastThreeSalesOrderIDs AS FreightMovingAverage,
    AVG(TotalDue) OVER LastThreeSalesOrderIDs AS TotalDueMovingAverage
FROM Sales.SalesOrderHeader
WINDOW LastThreeSalesOrderIDs AS (
    ORDER BY SalesOrderID
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
)
```

| SalesOrderID | SubTotalMovingAverage | TaxAmtMovingAverage | FreightMovingAverage | TotalDueMovingAverage |
| -----------: | --------------------: | ------------------: | -------------------: | --------------------: |
|        43659 |            20565.6206 |           1971.5149 |             616.0984 |            23153.2339 |
|        43660 |            10929.9367 |           1047.8816 |             327.4630 |            12305.2813 |
|        43661 |            18195.4507 |           1749.8442 |             546.8263 |            20492.1213 |
|        43662 |            20951.0868 |           2017.7275 |             630.5398 |            23599.3541 |
|        43663 |            20659.4888 |           1989.7341 |             621.7919 |            23271.0148 |
|        43664 |            17894.8655 |           1720.1416 |             537.5442 |            20152.5513 |
|        43665 |            13068.2796 |           1253.7343 |             391.7919 |            14713.8059 |
|        43666 |            14613.9565 |           1402.4365 |             438.2614 |            16454.6544 |
|        43667 |             8505.4476 |            816.1459 |             255.0456 |             9576.6391 |
|        43668 |            15702.5759 |           1511.4201 |             472.3188 |            17686.3148 |

## You can use `PARTITION BY` and `ORDER BY` together

Wherever you're defining a window, you can use `PARTITION BY` and `ORDER BY` together to define the window.

There are a few use-cases for this, but a great one is to compute within-year running totals.

Consider the following query which shows the quarterly sales totals for 2012 and 2013:

```sql
SELECT
    YEAR(OrderDate) AS OrderYear,
    DATEPART(QUARTER, OrderDate) AS OrderQuarter,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) IN (2012, 2013)
GROUP BY
    YEAR(OrderDate),
    DATEPART(QUARTER, OrderDate)
ORDER BY
    OrderYear,
    OrderQuarter
;
```

| OrderYear | OrderQuarter |    TotalSales |
| --------: | -----------: | ------------: |
|      2012 |            1 |  9443736.8161 |
|      2012 |            2 |  9935495.1729 |
|      2012 |            3 | 10164406.8281 |
|      2012 |            4 |  8132061.4949 |
|      2013 |            1 |  8771886.3577 |
|      2013 |            2 | 12225061.3830 |
|      2013 |            3 | 14339319.1851 |
|      2013 |            4 | 13629621.0374 |

We'll whack this [into a CTE](subqueries.md#common-tables-expressions-ctes-are-another-flavour-of-subquery) to make using it easier, and then we can use the `ORDER BY` and `PARTITION BY` clauses to calculate the running total for each year:

```sql
WITH YearlySales AS (
    SELECT
        YEAR(OrderDate) AS OrderYear,
        DATEPART(QUARTER, OrderDate) AS OrderQuarter,
        SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) IN (2012, 2013)
    GROUP BY
        YEAR(OrderDate),
        DATEPART(QUARTER, OrderDate)
)

SELECT
    OrderYear,
    OrderQuarter,
    TotalSales,
    SUM(TotalSales) OVER (
        PARTITION BY OrderYear
        ORDER BY OrderQuarter
    ) AS WithinYearRunningTotal
FROM YearlySales
ORDER BY
    OrderYear,
    OrderQuarter
;
```

| OrderYear | OrderQuarter |    TotalSales | WithinYearRunningTotal |
| --------: | -----------: | ------------: | ---------------------: |
|      2012 |            1 |  9443736.8161 |           9443736.8161 |
|      2012 |            2 |  9935495.1729 |          19379231.9890 |
|      2012 |            3 | 10164406.8281 |          29543638.8171 |
|      2012 |            4 |  8132061.4949 |          37675700.3120 |
|      2013 |            1 |  8771886.3577 |           8771886.3577 |
|      2013 |            2 | 12225061.3830 |          20996947.7407 |
|      2013 |            3 | 14339319.1851 |          35336266.9258 |
|      2013 |            4 | 13629621.0374 |          48965887.9632 |

Super simple!

## Further reading

Check out the [official Microsoft documentation](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-over-clause-transact-sql) for more information on the `OVER` clause at:

- [https://learn.microsoft.com/en-us/sql/t-sql/queries/select-over-clause-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-over-clause-transact-sql)

Microsoft SQL Server splits the window functions into two categories (other than aggregate functions), _ranking functions_ and _analytic functions_:

- [https://learn.microsoft.com/en-us/sql/t-sql/functions/ranking-functions-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/functions/ranking-functions-transact-sql)
- [https://learn.microsoft.com/en-us/sql/t-sql/functions/analytic-functions-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/functions/analytic-functions-transact-sql)

The video version of this content is also available at:

- [https://youtu.be/8e4mQfEDJDk](https://youtu.be/8e4mQfEDJDk)
