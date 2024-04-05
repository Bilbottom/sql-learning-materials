# Subqueries 🧩

> [!SUCCESS]
>
> Subqueries are undoubtedly one of the most powerful features in SQL -- but with great power comes great responsibility.

> [!WARNING]
>
> Excel doesn't really have an equivalent to subqueries (without using advanced Excel features). Be warned that this therefore may be a bit tricky to get used to!

## Subqueries are "nested" queries

[Subqueries](https://learn.microsoft.com/en-us/sql/relational-databases/performance/subqueries) are one of the awesome things about SQL. They are queries "nested" within other queries.

This allows you to do some pretty cool things, but is also easy to abuse! Make sure you don't go overboard with subqueries.

The most common place to use a subquery is in the `FROM` clause to use the output of another query as if it were a table:

```sql
SELECT *
FROM (
    SELECT
        BusinessEntityID AS ID,
        FirstName AS Forename,
        LastName AS Surname
    FROM Person.Person
    WHERE BusinessEntityID <= 5
) AS People
WHERE Forename IN ('Ken', 'Rob')
;
```

|  ID | Forename | Surname |
| --: | :------- | :------ |
|   1 | Ken      | Sánchez |
|   4 | Rob      | Walters |

In the example above, the subquery is _the query inside the parentheses_. This subquery is used as if it were a table in the main/outer query.

To help understand the example, you first need to know what the output of the subquery is:

```sql
SELECT
    BusinessEntityID AS ID,
    FirstName AS Forename,
    LastName AS Surname
FROM Person.Person
WHERE BusinessEntityID <= 5
;
```

|  ID | Forename | Surname    |
| --: | :------- | :--------- |
|   1 | Ken      | Sánchez    |
|   2 | Terri    | Duffy      |
|   3 | Roberto  | Tamburello |
|   4 | Rob      | Walters    |
|   5 | Gail     | Erickson   |

When we use this in the `FROM` clause, we're pretending that it's like a table that already exists -- just this table only has five rows, and the columns are called `ID`, `Forename`, and `Surname`.

Since the subquery is used as if it were a table, we need to use the column names as they are in the subquery. This is why we use `Forename` in the outer `WHERE` clause (`WHERE Forename IN ('Ken', 'Rob')`) instead of `FirstName`.

> [!NOTE]
>
> When you use a subquery in the `FROM` clause in Microsoft SQL Server, you need to give it an alias. This is why we have `AS People` at the end of the subquery.
>
> This is not the case in all SQL flavours, but it's a good habit to get into.

### Subqueries are good for using calculated columns

One of the reasons we like to use subqueries is to use calculated columns in places that we can't use them directly.

We've seen that if we want to use a calculated column in places like the `WHERE` and `GROUP BY` clauses, we need to use the same calculation in the `SELECT` clause:

```sql
SELECT
    FORMAT(OrderDate, 'yyyy-MM') AS OrderMonth,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE FORMAT(OrderDate, 'yyyy-MM') IN ('2013-01', '2013-02', '2013-03')
GROUP BY FORMAT(OrderDate, 'yyyy-MM')
ORDER BY OrderMonth
;
```

If we instead do the calculation in a subquery, we can use the calculated column in the `WHERE` and `GROUP BY` clauses without having to repeat the calculation:

```sql
SELECT
    OrderMonth,
    SUM(TotalDue) AS TotalSales
FROM (
    SELECT
        FORMAT(OrderDate, 'yyyy-MM') AS OrderMonth,
        TotalDue
    FROM Sales.SalesOrderHeader
) AS Orders
WHERE OrderMonth IN ('2013-01', '2013-02', '2013-03')
GROUP BY OrderMonth
ORDER BY OrderMonth
;
```

This isn't _super_ helpful in the example above, but it would be in cases where the calculation is more complex.

## Subqueries can be used in other places too

Although the most common place to use subqueries is in the `FROM` clause, they can also be used in other places like the `WHERE` and `SELECT` clauses (plus others).

However, there are different rules for using subqueries in these places: when we use the subquery in the `FROM` clause, we return _an entire table_; when we use the subquery in the `WHERE` or `SELECT` clauses, we return _a single value_.

We'll see advanced examples of these in [the correlated subqueries section](../advanced-concepts/correlated-subqueries.md).

### Subqueries in the `WHERE` clause

A good use of a subquery in the `WHERE` clause is to check if a value meets some condition relative to the rest of the values.

For example, the following query returns the sales orders whose total due is greater than the _average_ total due for the table:

```sql
SELECT TOP 5
    SalesOrderID,
    OrderDate,
    TotalDue
FROM Sales.SalesOrderHeader
WHERE TotalDue > (
    /* This produces a single value that we can compare against */
    SELECT AVG(TotalDue)
    FROM Sales.SalesOrderHeader
)
;
```

| SalesOrderID | OrderDate               |   TotalDue |
| -----------: | :---------------------- | ---------: |
|        43659 | 2011-05-31 00:00:00.000 | 23153.2339 |
|        43661 | 2011-05-31 00:00:00.000 | 36865.8012 |
|        43662 | 2011-05-31 00:00:00.000 | 32474.9324 |
|        43664 | 2011-05-31 00:00:00.000 | 27510.4109 |
|        43665 | 2011-05-31 00:00:00.000 | 16158.6961 |

### Subqueries in the `SELECT` clause

Similarly, we can use subqueries in the `SELECT` clause to keep track of some aggregate value for each row.

For example, the following query returns the sales orders and the _average_ total due for the table:

```sql
SELECT TOP 5
    SalesOrderID,
    OrderDate,
    TotalDue,
    (
        /* This produces a single value that we can use in a column */
        SELECT AVG(TotalDue)
        FROM Sales.SalesOrderHeader
    ) AS AverageTotalDue
FROM Sales.SalesOrderHeader
;
```

| SalesOrderID | OrderDate               |   TotalDue | AverageTotalDue |
| -----------: | :---------------------- | ---------: | --------------: |
|        43659 | 2011-05-31 00:00:00.000 | 23153.2339 |       3915.9951 |
|        43660 | 2011-05-31 00:00:00.000 |  1457.3288 |       3915.9951 |
|        43661 | 2011-05-31 00:00:00.000 | 36865.8012 |       3915.9951 |
|        43662 | 2011-05-31 00:00:00.000 | 32474.9324 |       3915.9951 |
|        43663 | 2011-05-31 00:00:00.000 |   472.3108 |       3915.9951 |

> [!INFO]
>
> We'll see another way to do this example in [the window functions section](window-functions.md), but it's good to know that subqueries can be used in this way too.

## Common tables expressions (CTEs) are another flavour of subquery

Rather than using subqueries directly inside the `SELECT` statements, SQL allows us to save the subquery as [a "common table expression" (CTE)](https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql) and then use the CTE in the `SELECT` statements.

To define a CTE, we use the `WITH` keyword followed by the name of the CTE and the subquery in parentheses. You can specify multiple CTEs after the `WITH` text by separating them with commas.

For example, we saw the following query earlier:

```sql
SELECT
    OrderMonth,
    SUM(TotalDue) AS TotalSales
FROM (
    SELECT
        FORMAT(OrderDate, 'yyyy-MM') AS OrderMonth,
        TotalDue
    FROM Sales.SalesOrderHeader
) AS Orders
WHERE OrderMonth IN ('2013-01', '2013-02', '2013-03')
GROUP BY OrderMonth
ORDER BY OrderMonth
;
```

We could instead save the `Orders` subquery as a CTE and then use the CTE in the `FROM` clause:

```sql
WITH Orders AS (
    SELECT
        FORMAT(OrderDate, 'yyyy-MM') AS OrderMonth,
        TotalDue
    FROM Sales.SalesOrderHeader
)

SELECT
    OrderMonth,
    SUM(TotalDue) AS TotalSales
FROM Orders
WHERE OrderMonth IN ('2013-01', '2013-02', '2013-03')
GROUP BY OrderMonth
ORDER BY OrderMonth
;
```

> [!TIP]
>
> In general, using CTEs (versus using subqueries directly) is a good habit to get into as it makes your queries easier to read and understand.

> [!WARNING]
>
> Subqueries defined as CTEs are always treated as if they were tables, so although it was an easy "lift-and-shift" for the subquery in the `FROM` clause, it wouldn't be as simple for subqueries in the `WHERE` and `SELECT` clauses.

## Further reading

Check out the [official Microsoft documentation](https://learn.microsoft.com/en-us/sql/relational-databases/performance/subqueries) for more information on subqueries at:

- [https://learn.microsoft.com/en-us/sql/relational-databases/performance/subqueries](https://learn.microsoft.com/en-us/sql/relational-databases/performance/subqueries)

The video version of this content is also available at:

- [https://youtu.be/pcD_7n7zKFw](https://youtu.be/pcD_7n7zKFw)
