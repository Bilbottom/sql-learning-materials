# Advanced aggregations 🥇

> [!SUCCESS]
>
> We saw in [the pivot table section](../main-concepts/rollup.md) that we can extend the `GROUP BY` clause with the `ROLLUP` modifier.
>
> There are two additional modifiers that we can use to extend the `GROUP BY` clause with even more flexibility: `GROUPING SETS` and `CUBE`.

> [!WARNING]
>
> The `GROUPING SETS` and `CUBE` modifiers are advanced, and there aren't Excel equivalents for these (without using advanced Excel features).
>
> Make sure that you are comfortable with the main concepts before diving into these advanced concepts.

## Let's start with a pivot table recap

We saw the `ROLLUP` modifier in [the pivot table section](../main-concepts/rollup.md) which allows us to create subtotals and grand totals in our `GROUP BY` clause.

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

The output of this query would include subtotals for each combination of `OrderMonth` and `OnlineOrderFlag`, as well as a grand total for each `OrderMonth` and a grand total for the entire dataset:

| OrderMonth | OnlineOrderFlag |    TotalSales |                                |
| :--------- | :-------------- | ------------: | ------------------------------ |
| _null_     | _null_          | 20996947.7407 | ← This is the grand total      |
| 2013-01    | _null_          |  2340061.5521 | ← This is the 2013-01 subtotal |
| 2013-01    | false           |  1761132.8322 |                                |
| 2013-01    | true            |   578928.7199 |                                |
| 2013-02    | _null_          |  2600218.8667 | ← This is the 2013-02 subtotal |
| 2013-02    | false           |  2101152.5476 |                                |
| 2013-02    | true            |   499066.3191 |                                |
| 2013-03    | _null_          |  3831605.9389 | ← This is the 2013-03 subtotal |
| 2013-03    | false           |  3244501.4287 |                                |
| 2013-03    | true            |   587104.5102 |                                |
| 2013-04    | _null_          |  2840711.1734 | ← This is the 2013-04 subtotal |
| 2013-04    | false           |  2239156.6675 |                                |
| 2013-04    | true            |   601554.5059 |                                |
| 2013-05    | _null_          |  3658084.9461 | ← This is the 2013-05 subtotal |
| 2013-05    | false           |  3019173.6253 |                                |
| 2013-05    | true            |   638911.3208 |                                |
| 2013-06    | _null_          |  5726265.2635 | ← This is the 2013-06 subtotal |
| 2013-06    | false           |  4775809.3027 |                                |
| 2013-06    | true            |   950455.9608 |                                |

One thing you might notice is that we only have the subtotals for `OrderMonth`. Where are the subtotals for `OnlineOrderFlag`?

As mentioned in [the pivot tables section](../main-concepts/rollup.md), the `ROLLUP` modifier follows the same rules as Excel's pivot tables and don't create subtotals for _every_ column.

This is where the `GROUPING SETS` modifier comes in.

## `GROUPING SETS` allow us to specify the subtotals we want

We use the `GROUPING SETS` modifier in a very similar way to the `ROLLUP` modifier. We write `GROUPING SETS` after the `GROUP BY`, but rather than specify a list of columns, we specify a _list of lists of columns_.

I'll say that again: we specify a _list of lists of columns_.

This is a bit funky 😝

Each list of columns in the `GROUPING SETS` clause will create a subtotal for the combination of columns in that list. To specify a grand total, we use an empty list.

To see this, let's rewrite the previous query using `GROUPING SETS` instead of `ROLLUP`:

```sql
SELECT
    FORMAT(OrderDate, 'yyyy-MM') AS OrderMonth,
    OnlineOrderFlag,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE '2013-01-01' <= OrderDate AND OrderDate < '2013-07-01'
GROUP BY GROUPING SETS (
    (),
    (FORMAT(OrderDate, 'yyyy-MM')),
    (FORMAT(OrderDate, 'yyyy-MM'), OnlineOrderFlag)
)
ORDER BY
    OrderMonth,
    OnlineOrderFlag
;
```

Specifically:

- `()` corresponds to the grand total.
- `(FORMAT(OrderDate, 'yyyy-MM'))` corresponds to the subtotals for `OrderMonth`.
- `(FORMAT(OrderDate, 'yyyy-MM'), OnlineOrderFlag)` corresponds to the totals for each combination of `OrderMonth` and `OnlineOrderFlag`.

Specifying the subtotals explicitly like this gives us more control over the output of the query. For example, it's super easy to add a subtotal for `OnlineOrderFlag` by adding another list to the `GROUPING SETS` clause:

```sql
SELECT
    FORMAT(OrderDate, 'yyyy-MM') AS OrderMonth,
    OnlineOrderFlag,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE '2013-01-01' <= OrderDate AND OrderDate < '2013-07-01'
GROUP BY GROUPING SETS (
    (),
    (FORMAT(OrderDate, 'yyyy-MM')),
    (OnlineOrderFlag),
    (FORMAT(OrderDate, 'yyyy-MM'), OnlineOrderFlag)
)
ORDER BY
    OrderMonth,
    OnlineOrderFlag
;
```

| OrderMonth | OnlineOrderFlag |    TotalSales |               |
| :--------- | :-------------- | ------------: | ------------- |
| _null_     | _null_          | 20996947.7407 |               |
| _null_     | false           | 17140926.4040 | ← This is new |
| _null_     | true            |  3856021.3367 | ← This is new |
| 2013-01    | _null_          |  2340061.5521 |               |
| 2013-01    | false           |  1761132.8322 |               |
| 2013-01    | true            |   578928.7199 |               |
| 2013-02    | _null_          |  2600218.8667 |               |
| 2013-02    | false           |  2101152.5476 |               |
| 2013-02    | true            |   499066.3191 |               |
| 2013-03    | _null_          |  3831605.9389 |               |
| 2013-03    | false           |  3244501.4287 |               |
| 2013-03    | true            |   587104.5102 |               |
| 2013-04    | _null_          |  2840711.1734 |               |
| 2013-04    | false           |  2239156.6675 |               |
| 2013-04    | true            |   601554.5059 |               |
| 2013-05    | _null_          |  3658084.9461 |               |
| 2013-05    | false           |  3019173.6253 |               |
| 2013-05    | true            |   638911.3208 |               |
| 2013-06    | _null_          |  5726265.2635 |               |
| 2013-06    | false           |  4775809.3027 |               |
| 2013-06    | true            |   950455.9608 |               |

Since we control exactly which subtotals we want, we can create a much more customised output than we could with `ROLLUP`!

## `CUBE` is like `ROLLUP` but for every combination of columns

In the last example above, we added a subtotal for `OnlineOrderFlag` by adding another list to the `GROUPING SETS` clause. This meant that we were creating subtotals for every combination of `OrderMonth` and `OnlineOrderFlag`:

- `()` for neither (the grand total).
- `(FORMAT(OrderDate, 'yyyy-MM'))` for just `OrderMonth`.
- `(OnlineOrderFlag)` for just `OnlineOrderFlag`.
- `(FORMAT(OrderDate, 'yyyy-MM'), OnlineOrderFlag)` for both.

With two columns, we write four lists in the `GROUPING SETS` clause. With three columns, we'd write eight lists. With four columns, we'd write sixteen lists... So this can easily get out of hand!

The `CUBE` modifier is like `ROLLUP` but for _every_ combination of columns. It's a shortcut for writing out all the combinations of columns in the `GROUPING SETS` clause. It's also like `ROLLUP` because we write a list of columns, not a list of lists of columns.

To see this, let's rewrite the previous query using `CUBE` instead of `GROUPING SETS`:

```sql
SELECT
    FORMAT(OrderDate, 'yyyy-MM') AS OrderMonth,
    OnlineOrderFlag,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE '2013-01-01' <= OrderDate AND OrderDate < '2013-07-01'
GROUP BY CUBE (
    FORMAT(OrderDate, 'yyyy-MM'),
    OnlineOrderFlag
)
ORDER BY
    OrderMonth,
    OnlineOrderFlag
;
```

This will give us the same output as the previous query, but we didn't have to write out all the combinations of columns in the `GROUPING SETS` clause.

## We can still use `GROUPING`/`GROUPING_ID` to identify subtotals

Like with `ROLLUP`, we can use the `GROUPING` and `GROUPING_ID` functions to identify which columns are subtotals. For example, here are the same queries as above but with the `GROUPING_ID` function added to the `SELECT` clause (they have the same output, so only one is shown):

```sql
SELECT
    GROUPING_ID(FORMAT(OrderDate, 'yyyy-MM'), OnlineOrderFlag) AS GroupingId,
    FORMAT(OrderDate, 'yyyy-MM') AS OrderMonth,
    OnlineOrderFlag,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE '2013-01-01' <= OrderDate AND OrderDate < '2013-07-01'
GROUP BY GROUPING SETS (
    (),
    (FORMAT(OrderDate, 'yyyy-MM')),
    (OnlineOrderFlag),
    (FORMAT(OrderDate, 'yyyy-MM'), OnlineOrderFlag)
)
ORDER BY
    OrderMonth,
    OnlineOrderFlag
;
```

```sql
SELECT
    GROUPING_ID(FORMAT(OrderDate, 'yyyy-MM'), OnlineOrderFlag) AS GroupingId,
    FORMAT(OrderDate, 'yyyy-MM') AS OrderMonth,
    OnlineOrderFlag,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE '2013-01-01' <= OrderDate AND OrderDate < '2013-07-01'
GROUP BY CUBE (
    FORMAT(OrderDate, 'yyyy-MM'),
    OnlineOrderFlag
)
ORDER BY
    OrderMonth,
    OnlineOrderFlag
;
```

| GroupingId | OrderMonth | OnlineOrderFlag |    TotalSales |
| ---------: | :--------- | :-------------- | ------------: |
|          3 | _null_     | _null_          | 20996947.7407 |
|          2 | _null_     | false           | 17140926.4040 |
|          2 | _null_     | true            |  3856021.3367 |
|          1 | 2013-01    | _null_          |  2340061.5521 |
|          0 | 2013-01    | false           |  1761132.8322 |
|          0 | 2013-01    | true            |   578928.7199 |
|          1 | 2013-02    | _null_          |  2600218.8667 |
|          0 | 2013-02    | false           |  2101152.5476 |
|          0 | 2013-02    | true            |   499066.3191 |
|          1 | 2013-03    | _null_          |  3831605.9389 |
|          0 | 2013-03    | false           |  3244501.4287 |
|          0 | 2013-03    | true            |   587104.5102 |
|          1 | 2013-04    | _null_          |  2840711.1734 |
|          0 | 2013-04    | false           |  2239156.6675 |
|          0 | 2013-04    | true            |   601554.5059 |
|          1 | 2013-05    | _null_          |  3658084.9461 |
|          0 | 2013-05    | false           |  3019173.6253 |
|          0 | 2013-05    | true            |   638911.3208 |
|          1 | 2013-06    | _null_          |  5726265.2635 |
|          0 | 2013-06    | false           |  4775809.3027 |
|          0 | 2013-06    | true            |   950455.9608 |

## "Cubes" are actually a well-known concept

> [!WARNING]
>
> This is no longer an SQL concept; this is a general concept in mathematics and computer science.

The `CUBE` modifier creates what's known as an _Online Analytical Processing_ (OLAP) cube.

- [https://en.wikipedia.org/wiki/OLAP_cube](https://en.wikipedia.org/wiki/OLAP_cube)

These are used in data warehousing and business intelligence to enable more performant reporting and analytics. They're a bit more advanced than what we're covering here, but it's good to know that the SQL `CUBE` modifier is based on a well-known concept.

> [!TIP]
>
> If you've used Excel's [Power Pivot](https://support.microsoft.com/en-gb/office/power-pivot-overview-and-learning-f9001958-7901-4caa-ad80-028a6d2432ed), you've already used OLAP cubes!
>
> Power Pivot creates OLAP cubes behind the scenes so that using the power functions (like [`CUBEVALUE`](https://support.microsoft.com/en-gb/office/cubevalue-function-8733da24-26d1-4e34-9b3a-84a8f00dcbe0)) can just "lookup" from these OLAP cubes.

## Further reading

Check out the [official Microsoft documentation](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-group-by-transact-sql) for more information on `GROUPING SETS` and `CUBE` at:

- [https://learn.microsoft.com/en-us/sql/t-sql/queries/select-group-by-transact-sql#group-by-grouping-sets--](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-group-by-transact-sql#group-by-grouping-sets--)
- [https://learn.microsoft.com/en-us/sql/t-sql/queries/select-group-by-transact-sql#group-by-cube--](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-group-by-transact-sql#group-by-cube--)
