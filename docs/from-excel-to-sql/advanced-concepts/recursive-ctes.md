# Recursive CTEs 🔁

> [!SUCCESS]
>
> Recursive CTEs are a great way to generate data and to flatten hierarchical data.

> [!WARNING]
>
> Recursive CTEs are advanced, and while there is _almost_ an Excel equivalent for one type of recursive CTE, the Excel equivalent is not as flexible as the SQL version.
>
> Make sure that you are comfortable with the main concepts before diving into these advanced concepts.

## A recursive CTE is one that references itself

> [!NOTE]
>
> When you use a recursive CTE, it will keep "re-running"/iterating the CTE and adding new rows until the CTE is told to stop.

We saw in [the subqueries section](../main-concepts/subqueries.md#common-tables-expressions-ctes-are-another-flavour-of-subquery) that subqueries can be defined in the `WITH` clause at the top of a query:

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

The `Orders` CTE references the `Sales.SalesOrderHeader` table, which is then referenced by the `SELECT` statement.

```mermaid
flowchart LR
    A[Sales.SalesOrderHeader] --> B[Orders] --> C[SELECT]
```

[A recursive CTE](https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql#guidelines-for-defining-and-using-recursive-common-table-expressions) is one that references itself. This sounds a bit weird, but it has two main uses:

1. To generate rows of data, e.g. a sequence of numbers or a date range
2. To flatten hierarchical data, e.g. an organisation's structure

### The "shape" of a recursive CTE

We'll use the following recursive CTE as an example. For now, we'll just focus on how it's written and will explain what it does later.

```sql
WITH Numbers AS (
        SELECT 1 AS Number
    UNION ALL
        SELECT Number + 1
        FROM Numbers
        WHERE Number < 5
)

SELECT *
FROM Numbers
;
```

| Number |
| -----: |
|      1 |
|      2 |
|      3 |
|      4 |
|      5 |

There are four parts to a recursive CTE:

1. The anchor `SELECT` statement
2. The `UNION ALL` keywords
3. The recursive `SELECT` statement
4. The termination condition in the `WHERE` clause

#### The anchor `SELECT` statement

For a CTE to be able to reference itself, it has to have a starting point 😝

In the example above, the starting point/anchor statement is:

```sql
SELECT 1 AS Number
```

This creates a single row with a single column whose value is `1`.

#### The `UNION ALL` keywords

A recursive CTE will append new rows to the bottom of the existing rows, so it needs a `UNION`.

However, you **must** use `UNION ALL` and not just `UNION`. This is a requirement of SQL, not just a recommendation.

#### The recursive `SELECT` statement

The recursive `SELECT` statement is the one that references the CTE itself.

In the example above, the recursive statement is:

```sql
SELECT Number + 1
FROM Numbers
WHERE Number < 5
```

The `SELECT` clause in this statement contains the logic that you want to apply with each "re-run"/iteration. In this case, we're adding `1` to the `Number` column.

The `FROM` clause is explicitly where we reference the CTE itself. If we don't reference the CTE itself within the CTE, it won't be recursive 😄

#### The termination condition in the `WHERE` clause

The `WHERE` clause in the recursive `SELECT` statement is the condition that tells the CTE to stop.

This is _super_ important: if you don't have a termination condition, the CTE will not stop running!

In the example above, the termination condition is:

```sql
WHERE Number < 5
```

This tells the CTE to stop when the `Number` column is less than `5`. Note that, because of the way that SQL processes the `WHERE` clause, the last loop will be when `Number` is `4` but _the `SELECT` clause will still add `1` to it_, so the final number in `Number` will be `5`.

#### Putting it all together

The query below is the same as the one above, but it has comments to show where each part of the recursive CTE is.

```sql
WITH Numbers AS (
        /* 1. The anchor SELECT statement */
        SELECT 1 AS Number
    /* 2. The UNION ALL keywords */
    UNION ALL
        /* 3. The recursive SELECT statement */
        SELECT Number + 1
        FROM Numbers
        /* 4. The termination condition in the WHERE clause */
        WHERE Number < 5
)

SELECT *
FROM Numbers
;
```

> [!WARNING]
>
> In some SQL flavours, you have to explicitly write `RECURSIVE` after the `WITH` keyword to tell SQL that the CTE is recursive.
>
> This is not necessary (and not even allowed!) in Microsoft SQL Server.

## Generating data with a recursive CTE

The simplest example of a recursive CTE is one that generates a sequence of numbers. This is precisely what the example above does!

There's two Excel equivalents to this:

### There are two Excel equivalents

- The **Series** feature
- The `SEQUENCE` function

[The **Series** feature](https://support.microsoft.com/en-gb/office/project-values-in-a-series-5311f5cf-149e-4d06-81dd-5aaad87e5400) is in the **Home** tab, in the **Editing** group, and is called **Series...** (under AutoSum). This is not available in the Web version of Excel; Microsoft recommend dragging [the fill handle instead](https://support.microsoft.com/en-gb/office/fill-data-automatically-in-worksheet-cells-74e31bdd-d993-45da-aa82-35a236c5b5db).

[The `SEQUENCE` function](https://support.microsoft.com/en-gb/office/sequence-function-57467a98-57e0-4817-9f14-2eb78519ca90) is a function to do the same as the **Series** feature and the fill handle.

### Breaking down the data generation example

We've gone through _how_ the query is written, but we haven't explained _what_ it does.

#### The anchor `SELECT` statement

The anchor `SELECT` statement is only run once, and it's the starting point for the CTE.

In our example, the anchor `SELECT` statement is:

```sql
SELECT 1 AS Number
```

| Number |
| -----: |
|      1 |

This is the starting point for the recursive CTE and is the first row to be passed to the recursive `SELECT` statement.

#### The recursive `SELECT` statement

The first time that the recursive `SELECT` statement is run, it'll use the row from the anchor `SELECT` statement as its input; the rest of the time, it'll use the rows from the previous iteration (this will be significant in the hierarchy flattening example).

As a reminder, the recursive `SELECT` statement is:

```sql
SELECT Number + 1
FROM Numbers
WHERE Number < 5
```

We start with a single row from the anchor statement, so the first iteration of the recursive statement takes the `1` (which is less than `5`) and adds `1` to it to get `2`, so after this iteration the CTE is:

| Number |                 |
| -----: | --------------- |
|      1 | ← anchor        |
|      2 | ← 1st iteration |

Now the recursive `SELECT` statement is run again, but this time it uses the row from the first iteration as its input. It takes the `2` (which is less than `5`) and adds `1` to it to get `3`, so after this iteration the CTE is:

| Number |                 |
| -----: | --------------- |
|      1 | ← anchor        |
|      2 | ← 1st iteration |
|      3 | ← 2nd iteration |

This process continues for a third iteration, using only the row from the previous iteration (the `3`):

| Number |                 |
| -----: | --------------- |
|      1 | ← anchor        |
|      2 | ← 1st iteration |
|      3 | ← 2nd iteration |
|      4 | ← 3rd iteration |

The process continues for a fourth iteration, using only the row from the previous iteration (the `4`):

| Number |                 |
| -----: | --------------- |
|      1 | ← anchor        |
|      2 | ← 1st iteration |
|      3 | ← 2nd iteration |
|      4 | ← 3rd iteration |
|      5 | ← 4th iteration |

Finally, when the process attempts to run a fifth iteration using `5`, the `WHERE` condition `Number < 5` is no longer met. No rows are generated during this iteration, so the CTE stops running and the final result is:

| Number |
| -----: |
|      1 |
|      2 |
|      3 |
|      4 |
|      5 |

### Generating a date range

The same principle can be applied to generate a date range. The following query generates a date range from `2023-01-01` to `2023-01-31`:

```sql
WITH Dates AS (
        SELECT CAST('2023-01-01' AS DATE) AS Date
    UNION ALL
        SELECT DATEADD(DAY, 1, Date)
        FROM Dates
        WHERE Date < '2023-01-31'
)

SELECT *
FROM Dates
;
```

| Date       |
| :--------- |
| 2023-01-01 |
| 2023-01-02 |
| 2023-01-03 |
| 2023-01-04 |
| 2023-01-05 |
| 2023-01-06 |
| 2023-01-07 |
| 2023-01-08 |
| 2023-01-09 |
| 2023-01-10 |
| 2023-01-11 |
| 2023-01-12 |
| 2023-01-13 |
| 2023-01-14 |
| 2023-01-15 |
| 2023-01-16 |
| 2023-01-17 |
| 2023-01-18 |
| 2023-01-19 |
| 2023-01-20 |
| 2023-01-21 |
| 2023-01-22 |
| 2023-01-23 |
| 2023-01-24 |
| 2023-01-25 |
| 2023-01-26 |
| 2023-01-27 |
| 2023-01-28 |
| 2023-01-29 |
| 2023-01-30 |
| 2023-01-31 |

Can you think of any other ranges that you'd want to generate?

> [!TIP]
>
> If you're working with a good data set, you'll hopefully have a table of dates that you can use instead of generating them (often called a "calendar table" or a "date dimension").
>
> However, not all data sets will have this, so generating a date range on the fly can be super useful!

## Flattening hierarchical data with a recursive CTE

> [!WARNING]
>
> There is no Excel equivalent to this, so wrapping your head around this will probably be a bit more difficult than the data generation example.

Flattening hierarchical data is the other main use of a recursive CTE.

There are lots of examples of hierarchical data:

- An organisation's structure, where each employee has a manager and each manager has a manager
- A family tree, where each person has parents and each parent has parents
- A file system, where each file is in a folder and each folder is in a folder

We'll focus on the first example: an organisation's structure.

The AdventureWorks database doesn't have a table for an organisation's structure, so we'll use the following CTE ([adapted from the Microsoft docs](https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql#d-use-a-recursive-common-table-expression-to-display-multiple-levels-of-recursion)) to create a table of employees and their managers:

```sql
WITH Organisation AS (
    SELECT *
    FROM (VALUES
        (1,   N'Ken Sánchez',    N'Chief Executive Officer',      NULL),
        (273, N'Brian Welcker',  N'Vice President of Sales',      1),
        (274, N'Stephen Jiang',  N'North American Sales Manager', 273),
        (275, N'Michael Blythe', N'Sales Representative',         274),
        (276, N'Linda Mitchell', N'Sales Representative',         274),
        (285, N'Syed Abbas',     N'Pacific Sales Manager',        273),
        (286, N'Lynn Tsoflias',  N'Sales Representative',         285),
        (16,  N'David Bradley',  N'Marketing Manager',            273),
        (23,  N'Mary Gibson',    N'Marketing Specialist',         16)
    ) AS V(EmployeeID, Name, Title, ManagerID)
)

SELECT *
FROM Organisation
;
```

| EmployeeID | Name           | Title                        | ManagerID |
| ---------: | :------------- | :--------------------------- | --------: |
|          1 | Ken Sánchez    | Chief Executive Officer      |    _null_ |
|        273 | Brian Welcker  | Vice President of Sales      |         1 |
|        274 | Stephen Jiang  | North American Sales Manager |       273 |
|        275 | Michael Blythe | Sales Representative         |       274 |
|        276 | Linda Mitchell | Sales Representative         |       274 |
|        285 | Syed Abbas     | Pacific Sales Manager        |       273 |
|        286 | Lynn Tsoflias  | Sales Representative         |       285 |
|         16 | David Bradley  | Marketing Manager            |       273 |
|         23 | Mary Gibson    | Marketing Specialist         |        16 |

This table has the employee ID and their manager's ID, so it would be quite easy to write a query to get the manager's name for each employee -- just do a self-join:

```sql
WITH Organisation AS (...)

SELECT
    Employee.EmployeeID,
    Employee.Name,
    Employee.ManagerID,
    Manager.Name AS ManagerName
FROM Organisation AS Employee
    LEFT JOIN Organisation AS Manager
        ON Employee.ManagerID = Manager.EmployeeID
;
```

| EmployeeID | Name           | ManagerID | ManagerName   |
| ---------: | :------------- | --------: | :------------ |
|          1 | Ken Sánchez    |    _null_ | _null_        |
|        273 | Brian Welcker  |         1 | Ken Sánchez   |
|        274 | Stephen Jiang  |       273 | Brian Welcker |
|        275 | Michael Blythe |       274 | Stephen Jiang |
|        276 | Linda Mitchell |       274 | Stephen Jiang |
|        285 | Syed Abbas     |       273 | Brian Welcker |
|        286 | Lynn Tsoflias  |       285 | Syed Abbas    |
|         16 | David Bradley  |       273 | Brian Welcker |
|         23 | Mary Gibson    |        16 | David Bradley |

What if we wanted to know the hierarchy level of each employee (with the CEO as `1`)?

Well, we could try some subqueries and unions, but this would be _a lot_ to write:

```sql
WITH Organisation AS (...),

Level1 AS (
    SELECT
        1 AS EmployeeLevel,
        EmployeeID,
        ManagerID,
        Name
    FROM Organisation
    WHERE ManagerID IS NULL  /* The CEO */
),

Level2 AS (
    SELECT
        2 AS EmployeeLevel,
        EmployeeID,
        ManagerID,
        Name
    FROM Organisation
    WHERE ManagerID IN (
        SELECT EmployeeID
        FROM Level1
    )
),

Level3 AS (
    SELECT
        3 AS EmployeeLevel,
        EmployeeID,
        ManagerID,
        Name
    FROM Organisation
    WHERE ManagerID IN (
        SELECT EmployeeID
        FROM Level2
    )
),

Level4 AS (
    SELECT
        4 AS EmployeeLevel,
        EmployeeID,
        ManagerID,
        Name
    FROM Organisation
    WHERE ManagerID IN (
        SELECT EmployeeID
        FROM Level3
    )
)

    SELECT * FROM Level1
UNION
    SELECT * FROM Level2
UNION
    SELECT * FROM Level3
UNION
    SELECT * FROM Level4
;
```

Not only is this a lot to write, but it's also not very flexible. We needed to know how many levels there were in the hierarchy to write this query, and if the hierarchy changes, we'd need to change the query.

This is where a recursive CTE comes in handy!

The recursive CTE will keep going until it runs out of rows, so it doesn't need to know how many levels there are in the hierarchy beforehand.

```sql
WITH Organisation AS (...),

Levels AS (
        SELECT
            1 AS EmployeeLevel,
            EmployeeID,
            ManagerID,
            Name
        FROM Organisation
        WHERE ManagerID IS NULL  /* The CEO */
    UNION ALL
        SELECT
            Levels.EmployeeLevel + 1,
            Organisation.EmployeeID,
            Organisation.ManagerID,
            Organisation.Name
        FROM Organisation
            INNER JOIN Levels
                ON Organisation.ManagerID = Levels.EmployeeID
)

SELECT *
FROM Levels
;
```

| EmployeeLevel | EmployeeID | ManagerID | Name           |
| ------------: | ---------: | --------: | :------------- |
|             1 |          1 |    _null_ | Ken Sánchez    |
|             2 |        273 |         1 | Brian Welcker  |
|             3 |        274 |       273 | Stephen Jiang  |
|             3 |        285 |       273 | Syed Abbas     |
|             3 |         16 |       273 | David Bradley  |
|             4 |         23 |        16 | Mary Gibson    |
|             4 |        286 |       285 | Lynn Tsoflias  |
|             4 |        275 |       274 | Michael Blythe |
|             4 |        276 |       274 | Linda Mitchell |

This query is definitely shorter than the subquery/union version, but it's more complex than the data generation example; there are a few differences to call out and explain.

### The anchor `SELECT` statement

The anchor statement this time is:

```sql
SELECT
    1 AS EmployeeLevel,
    EmployeeID,
    ManagerID,
    Name
FROM Organisation
WHERE ManagerID IS NULL  /* The CEO */
```

| EmployeeLevel | EmployeeID | ManagerID | Name        |
| ------------: | ---------: | --------: | :---------- |
|             1 |          1 |    _null_ | Ken Sánchez |

In contrast to the data generation example, we want to start with an actual employee. In this case, we want to start at the top of the hierarchy (the CEO) which is why we:

- Select from the `Organisation` table/CTE
- Filter for the row where `ManagerID` is `NULL`

This `WHERE` clause is just to set up the anchor node; this clause _is not_ used in the recursive `SELECT` statement.

We do, however, set the starting point for the `EmployeeLevel` column to `1` in the anchor statement.

### The recursive `SELECT` statement

The recursive statement is:

```sql
SELECT
    Levels.EmployeeLevel + 1,
    Organisation.EmployeeID,
    Organisation.ManagerID,
    Organisation.Name
FROM Organisation
    INNER JOIN Levels
        ON Organisation.ManagerID = Levels.EmployeeID
```

The `Levels.EmployeeLevel + 1` line should be fairly intuitive: it's just adding `1` to the `EmployeeLevel` column from the previous iteration, just like in the data generation example.

The `INNER JOIN` clause is where the magic happens. This is actually doing two things for us:

1. It's how we know which rows to use from the `Organisation` table/CTE for this iteration. This example also shows that the recursive CTE can be referenced in a `JOIN` clause instead of just in the `FROM` clause.
2. By being an `INNER JOIN`, it's also the termination condition for the CTE! When there are no more rows to join, the CTE will stop running. This is why we don't need a `WHERE` clause in the recursive `SELECT` statement.

### Breaking down the hierarchy flattening example

This is still probably a bit confusing, so let's break it down with the first few iterations.

#### The anchor is the CEO

We've already seen that the anchor statement gives us the CEO:

| EmployeeLevel | EmployeeID | ManagerID | Name        |
| ------------: | ---------: | --------: | :---------- |
|             1 |          1 |    _null_ | Ken Sánchez |

#### The first iteration is the CEO's direct report(s)

The first iteration of the recursive statement will use the CEO's `EmployeeID` to find the employees who report to the CEO, and it'll increment the `EmployeeLevel` by `1`:

| EmployeeLevel | EmployeeID | ManagerID | Name          |
| ------------: | ---------: | --------: | :------------ |
|             2 |        273 |         1 | Brian Welcker |

At this point, the CTE will be:

| EmployeeLevel | EmployeeID | ManagerID | Name          |                 |
| ------------: | ---------: | --------: | :------------ | --------------- |
|             1 |          1 |    _null_ | Ken Sánchez   | ← anchor        |
|             2 |        273 |         1 | Brian Welcker | ← 1st iteration |

#### The second iteration is the first iteration's direct report(s)

The second iteration will use the output of the first iteration, namely Brian Welcker, and find their direct reports (and increment the `EmployeeLevel` by `1`):

| EmployeeLevel | EmployeeID | ManagerID | Name          |
| ------------: | ---------: | --------: | :------------ |
|             3 |        274 |       273 | Stephen Jiang |
|             3 |        285 |       273 | Syed Abbas    |
|             3 |         16 |       273 | David Bradley |

At this point, the CTE will be:

| EmployeeLevel | EmployeeID | ManagerID | Name          |                 |
| ------------: | ---------: | --------: | :------------ | --------------- |
|             1 |          1 |    _null_ | Ken Sánchez   | ← anchor        |
|             2 |        273 |         1 | Brian Welcker | ← 1st iteration |
|             3 |        274 |       273 | Stephen Jiang | ← 2nd iteration |
|             3 |        285 |       273 | Syed Abbas    | ← 2nd iteration |
|             3 |         16 |       273 | David Bradley | ← 2nd iteration |

This is a case that we haven't seen yet: this iteration has produced multiple rows. This means that _all three_ of these rows will be used in the next iteration.

#### The third iteration is the second iteration's direct report(s)

The third iteration will use the output of the second iteration, namely Stephen Jiang, Syed Abbas, and David Bradley, and find their direct reports (and increment the `EmployeeLevel` by `1`):

| EmployeeLevel | EmployeeID | ManagerID | Name           |
| ------------: | ---------: | --------: | :------------- |
|             4 |         23 |        16 | Mary Gibson    |
|             4 |        286 |       285 | Lynn Tsoflias  |
|             4 |        275 |       274 | Michael Blythe |
|             4 |        276 |       274 | Linda Mitchell |

At this point, the CTE will be:

| EmployeeLevel | EmployeeID | ManagerID | Name           |                 |
| ------------: | ---------: | --------: | :------------- | --------------- |
|             1 |          1 |    _null_ | Ken Sánchez    | ← anchor        |
|             2 |        273 |         1 | Brian Welcker  | ← 1st iteration |
|             3 |        274 |       273 | Stephen Jiang  | ← 2nd iteration |
|             3 |        285 |       273 | Syed Abbas     | ← 2nd iteration |
|             3 |         16 |       273 | David Bradley  | ← 2nd iteration |
|             4 |         23 |        16 | Mary Gibson    | ← 3rd iteration |
|             4 |        286 |       285 | Lynn Tsoflias  | ← 3rd iteration |
|             4 |        275 |       274 | Michael Blythe | ← 3rd iteration |
|             4 |        276 |       274 | Linda Mitchell | ← 3rd iteration |

#### The fourth iteration will terminate the loop

When the fourth iteration is run, it will look for the direct reports of Mary Gibson, Lynn Tsoflias, Michael Blythe, and Linda Mitchell by using the `INNER JOIN`.

Since there are no direct reports for these employees, the `INNER JOIN` will not produce any rows, and the CTE will stop running!

Therefore, the final result is:

| EmployeeLevel | EmployeeID | ManagerID | Name           |
| ------------: | ---------: | --------: | :------------- |
|             1 |          1 |    _null_ | Ken Sánchez    |
|             2 |        273 |         1 | Brian Welcker  |
|             3 |        274 |       273 | Stephen Jiang  |
|             3 |        285 |       273 | Syed Abbas     |
|             3 |         16 |       273 | David Bradley  |
|             4 |         23 |        16 | Mary Gibson    |
|             4 |        286 |       285 | Lynn Tsoflias  |
|             4 |        275 |       274 | Michael Blythe |
|             4 |        276 |       274 | Linda Mitchell |

### Other hierarchy flattening examples

If you want to see some more hierarchy flattening examples, check out the Microsoft documentation's examples (it has some good ones!):

- [https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql#use-a-recursive-common-table-expression-to-display-two-levels-of-recursion](https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql#use-a-recursive-common-table-expression-to-display-two-levels-of-recursion)
- [https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql#use-a-recursive-common-table-expression-to-display-a-hierarchical-list](https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql#use-a-recursive-common-table-expression-to-display-a-hierarchical-list)
- [https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql#e-use-a-common-table-expression-to-selectively-step-through-a-recursive-relationship-in-a-select-statement](https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql#e-use-a-common-table-expression-to-selectively-step-through-a-recursive-relationship-in-a-select-statement)
- [https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql#h-use-multiple-anchor-and-recursive-members](https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql#h-use-multiple-anchor-and-recursive-members)
- [https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql#bkmkUsingAnalyticalFunctionsInARecursiveCTE](https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql#bkmkUsingAnalyticalFunctionsInARecursiveCTE)

> [!TIP]
>
> You might be thinking: _what if the recursive CTE never hits the termination condition_?
>
> Microsoft SQL Server will stop the CTE after 100 iterations, so you won't get an infinite loop.
>
> You might then be thinking: _what if I want more than 100 iterations_?
>
> Microsoft SQL Server allows you to change this with the `MAXRECURSION` option:
>
> ```sql
> WITH SomeRecursiveCTE AS (...)
>
> SELECT *
> FROM SomeRecursiveCTE
> OPTION (MAXRECURSION 500)
> ;
> ```

## A quick note for the programmers

> [!WARNING]
>
> If you've never done any programming before, skip this bit!

If you've used other programming languages, you might be thinking that recursive CTEs are similar to loops. You'd be right!

Just like how correlated subqueries can be thought of as [for-loops](https://en.wikipedia.org/wiki/For_loop), recursive CTEs can be thought of as [while-loops](https://en.wikipedia.org/wiki/While_loop) that run while a condition is met.

This is why recursive CTEs can be slow if used inappropriately: they can run a lot of times!

## Some fun recursive CTE examples

> [!WARNING]
>
> These are just for fun. If you're not comfortable with the main concepts, don't worry about these examples!

### Generating a Fibonacci sequence

The Fibonacci sequence is a sequence of numbers where each number is the sum of the two preceding ones. For example, the first few terms are:

- **1**
- **1**
- **2** (1 + 1)
- **3** (1 + 2)
- **5** (2 + 3)
- **8** (3 + 5)
- ...

To generate the first `10` terms of the Fibonacci sequence, you can use the following recursive CTE:

```sql
WITH Fibonacci AS (
        SELECT
            1 AS n,
            1 AS f_n,  /* f(n) */
            0 AS f_n_1   /* f(n - 1) */
    UNION ALL
        SELECT
            n + 1 AS n,
            f_n + f_n_1 AS f_n,
            f_n AS f_n_1
        FROM Fibonacci
        WHERE n < 10
)

SELECT
    n,
    f_n
FROM Fibonacci
```

|   n | f_n |
| --: | --: |
|   1 |   1 |
|   2 |   1 |
|   3 |   2 |
|   4 |   3 |
|   5 |   5 |
|   6 |   8 |
|   7 |  13 |
|   8 |  21 |
|   9 |  34 |
|  10 |  55 |

### Generating the Mandelbrot set

> [!INFO]
>
> This example is taken from Graeme Job at:
>
> - [https://thedailywtf.com/articles/Stupid-Coding-Tricks-The-TSQL-Madlebrot](https://thedailywtf.com/articles/Stupid-Coding-Tricks-The-TSQL-Madlebrot)

The following beauty produces [the Mandelbrot set](https://en.wikipedia.org/wiki/Mandelbrot_set), a well-known [fractal](https://en.wikipedia.org/wiki/Fractal), and [the SQL is written by Graeme Job](https://thedailywtf.com/articles/Stupid-Coding-Tricks-The-TSQL-Madlebrot):

```sql
WITH
    XGEN(X, IX) AS (
        /* X DIM GENERATOR */
            SELECT
                CAST(-2.2 AS FLOAT) AS X,
                0 AS IX
        UNION ALL
            SELECT
                CAST(X + 0.031 AS FLOAT) AS X,
                IX + 1 AS IX
            FROM XGEN
            WHERE IX < 100
    ),
    YGEN(Y, IY) AS (
        /* Y DIM GENERATOR */
            SELECT
                CAST(-1.5 AS FLOAT) AS Y,
                0 AS IY
        UNION ALL
            SELECT
                CAST(Y + 0.031 AS FLOAT) AS Y,
                IY + 1 AS IY
            FROM YGEN
            WHERE IY < 100
    ),
    Z(IX, IY, CX, CY, X, Y, I) AS (
        /* Z POINT ITERATOR */
            SELECT
                IX,
                IY,
                X AS CX,
                Y AS CY,
                X,
                Y,
                0 AS I
            FROM XGEN, YGEN
        UNION ALL
            SELECT
                IX,
                IY,
                CX,
                CY,
                X * X - Y * Y + CX AS X,
                Y * X * 2 + CY,
                I + 1
            FROM Z
            WHERE X * X + Y * Y < 16
              AND I < 100
    )

SELECT
    TRANSLATE(
        (
            X0 +X1 +X2 +X3 +X4 +X5 +X6 +X7 +X8 +X9 +X10+X11+X12+X13+X14+X15+X16+X17+X18+X19+
            X20+X21+X22+X23+X24+X25+X26+X27+X28+X29+X30+X31+X32+X33+X34+X35+X36+X37+X38+X39+
            X40+X41+X42+X43+X44+X45+X46+X47+X48+X49+X50+X51+X52+X53+X54+X55+X56+X57+X58+X59+
            X60+X61+X62+X63+X64+X65+X66+X67+X68+X69+X70+X71+X72+X73+X74+X75+X76+X77+X78+X79+
            X80+X81+X82+X83+X84+X85+X86+X87+X88+X89+X90+X91+X92+X93+X94+X95+X96+X97+X98+X99
        ),
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        ' .,,,-----++++%%%%@@@@### '
    )
FROM (
    SELECT
        'X' + CAST(IX AS VARCHAR) AS IX,
        IY,
        SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ', ISNULL(NULLIF(I, 0), 1), 1) AS I
    FROM Z
) AS ZT
PIVOT (
    MAX(I) FOR IX IN (
        X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10,X11,X12,X13,X14,X15,X16,X17,X18,X19,
        X20,X21,X22,X23,X24,X25,X26,X27,X28,X29,X30,X31,X32,X33,X34,X35,X36,X37,X38,X39,
        X40,X41,X42,X43,X44,X45,X46,X47,X48,X49,X50,X51,X52,X53,X54,X55,X56,X57,X58,X59,
        X60,X61,X62,X63,X64,X65,X66,X67,X68,X69,X70,X71,X72,X73,X74,X75,X76,X77,X78,X79,
        X80,X81,X82,X83,X84,X85,X86,X87,X88,X89,X90,X91,X92,X93,X94,X95,X96,X97,X98,X99
    )
) AS PZT
;
```

The output doesn't look great here, so give it a run yourself!

## Further reading

Check out the [official Microsoft documentation](https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql#guidelines-for-defining-and-using-recursive-common-table-expressions) for more information on recursive CTEs at:

- [https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql#guidelines-for-defining-and-using-recursive-common-table-expressions](https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql#guidelines-for-defining-and-using-recursive-common-table-expressions)

### Some links for Excel stuff

The **Series** feature and the fill handles are documented at:

- [https://support.microsoft.com/en-gb/office/project-values-in-a-series-5311f5cf-149e-4d06-81dd-5aaad87e5400](https://support.microsoft.com/en-gb/office/project-values-in-a-series-5311f5cf-149e-4d06-81dd-5aaad87e5400)
- [https://support.microsoft.com/en-gb/office/fill-data-automatically-in-worksheet-cells-74e31bdd-d993-45da-aa82-35a236c5b5db](https://support.microsoft.com/en-gb/office/fill-data-automatically-in-worksheet-cells-74e31bdd-d993-45da-aa82-35a236c5b5db)

The `SEQUENCE` function can be super handy for generating sequences of numbers in Excel. The official documentation is at:

- [https://support.microsoft.com/en-gb/office/sequence-function-57467a98-57e0-4817-9f14-2eb78519ca90](https://support.microsoft.com/en-gb/office/sequence-function-57467a98-57e0-4817-9f14-2eb78519ca90)

However, the following tutorials are also super useful:

- [https://exceljet.net/functions/sequence-function](https://exceljet.net/functions/sequence-function)
- [https://exceljet.net/videos/the-sequence-function](https://exceljet.net/videos/the-sequence-function)
- [https://exceljet.net/formulas/sequence-of-days](https://exceljet.net/formulas/sequence-of-days)
- [https://exceljet.net/formulas/sequence-of-times](https://exceljet.net/formulas/sequence-of-times)
- [https://exceljet.net/formulas/sequence-of-months](https://exceljet.net/formulas/sequence-of-months)
- [https://exceljet.net/formulas/sequence-of-years](https://exceljet.net/formulas/sequence-of-years)
