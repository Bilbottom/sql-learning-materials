# Correlated subqueries 🌐

> [!SUCCESS]
>
> Correlated subqueries are a great way to "run a subquery" for each row in a table.
>
> This can be slow if used inappropriately, but there are some great places to use this!

> [!WARNING]
>
> Correlated subqueries are advanced, and there aren't Excel equivalents for them.
>
> Make sure that you are comfortable with the main concepts before diving into these advanced concepts.

## Correlated subqueries "run a subquery" for each row in a table

We saw subqueries in [the subqueries section](../main-concepts/subqueries.md), so what makes one "correlated"?

A subquery becomes a ["correlated subquery"](https://learn.microsoft.com/en-us/sql/relational-databases/performance/subqueries#correlated) if it _references a column from a table in the outer query_.

The subquery is then "run" for each row in the referenced column.

This can take a bit of getting used to, but it's a powerful tool when used appropriately.

## Converting joins into a correlated subquery

> [!WARNING]
>
> These are contrived examples to demonstrate the concept. You should stick to using `JOIN` for this kind of operation! 😝

### `Employee LEFT JOIN Department`

To ease into the concept, we'll see how we could convert a `JOIN` into a correlated subquery.

We saw the following query in [the `Employee LEFT JOIN Department` part](../main-concepts/join.md#employee-left-join-department) of [the joins section](../main-concepts/join.md):

```sql
SELECT
    Employee.EmployeeID,
    Employee.EmployeeName,
    Employee.DepartmentID,
    Department.DepartmentName
FROM Employee
    LEFT JOIN Department
        ON Employee.DepartmentID = Department.DepartmentID
;
```

| EmployeeID | EmployeeName | DepartmentID | DepartmentName |
| ---------: | :----------- | -----------: | :------------- |
|          1 | Alice        |            1 | Sales          |
|          2 | Bob          |            1 | Sales          |
|          3 | Charlie      |            2 | Marketing      |
|          4 | Dave         |            2 | Marketing      |
|          5 | Eve          |            3 | null           |

In this example, we're finding the `DepartmentName` in the `Department` table that matches the `DepartmentID` for each employee in the `Employee` table.

We could convert this into a correlated subquery like so:

```sql
SELECT
    EmployeeID,
    EmployeeName,
    DepartmentID,
    (
        SELECT DepartmentName
        FROM Department
        WHERE Department.DepartmentID = Employee.DepartmentID
    ) AS DepartmentName
FROM Employee
;
```

This isn't just a normal subquery: the `WHERE` clause references the `Employee` table which is outside the subquery!

Let's break down what's happening with each row in this table.

#### Employee 1

The first row is employee 1:

| EmployeeID | EmployeeName | DepartmentID |
| ---------: | :----------- | -----------: |
|          1 | Alice        |            1 |

Their `DepartmentID` is 1, so SQL will run the following subquery to find the `DepartmentName`:

```sql
SELECT DepartmentName
FROM Department
WHERE Department.DepartmentID = 1
;
```

| DepartmentName |
| :------------- |
| Sales          |

Therefore, the value `Sales` will be used for the `DepartmentName` for Alice.

#### Employee 2

The second row is employee 2:

| EmployeeID | EmployeeName | DepartmentID |
| ---------: | :----------- | -----------: |
|          2 | Bob          |            1 |

Their `DepartmentID` is also 1, so SQL will run the exact same subquery to find the `DepartmentName`; this means that Bob will also have `Sales` as their `DepartmentName`.

#### Employee 3

The third row is employee 3:

| EmployeeID | EmployeeName | DepartmentID |
| ---------: | :----------- | -----------: |
|          3 | Charlie      |            2 |

Their `DepartmentID` is 2, so SQL will run the following subquery to find the `DepartmentName`:

```sql
SELECT DepartmentName
FROM Department
WHERE Department.DepartmentID = 2
;
```

| DepartmentName |
| :------------- |
| Marketing      |

Therefore, the value `Marketing` will be used for the `DepartmentName` for Charlie.

#### Employee 4

The fourth row is employee 4:

| EmployeeID | EmployeeName | DepartmentID |
| ---------: | :----------- | -----------: |
|          4 | Dave         |            2 |

Their `DepartmentID` is also 2, so SQL will run the exact same subquery to find the `DepartmentName`; this means that Dave will also have `Marketing` as their `DepartmentName`.

#### Employee 5

The fifth row is employee 5:

| EmployeeID | EmployeeName | DepartmentID |
| ---------: | :----------- | -----------: |
|          5 | Eve          |            3 |

Their `DepartmentID` is 3, so SQL will run the following subquery to find the `DepartmentName`:

```sql
SELECT DepartmentName
FROM Department
WHERE Department.DepartmentID = 3
;
```

This subquery will return no rows, so the `NULL` value will be used for the `DepartmentName` for Eve.

#### Putting it all together

When we put all of these rows together, we get the following result:

| EmployeeID | EmployeeName | DepartmentID | DepartmentName |
| ---------: | :----------- | -----------: | :------------- |
|          1 | Alice        |            1 | Sales          |
|          2 | Bob          |            1 | Sales          |
|          3 | Charlie      |            2 | Marketing      |
|          4 | Dave         |            2 | Marketing      |
|          5 | Eve          |            3 | _null_         |

This is indeed identical to the result we got from the `LEFT JOIN` query!

### What about the other join examples?

We saw two other join examples in [the joins section](../main-concepts/join.md):

- An inner join: [Employee INNER JOIN Department](../main-concepts/join.md#employee-inner-join-department)
- A left join with multiple matches: [Employee LEFT JOIN Address](../main-concepts/join.md#employee-left-join-address)

Do you think we could convert these into correlated subqueries, too?

#### Employee INNER JOIN Department

If we try to convert the inner join into a correlated subquery, we get exactly the same result as the `LEFT JOIN` example unless we explicitly filter out the `NULL` values _after_ the subquery.

This means that correlated subqueries are more like `LEFT JOIN` than `INNER JOIN` in this context.

#### Employee LEFT JOIN Address

If we try to convert the left join with multiple matches into a correlated subquery, we'd end up with an error.

This is because the subquery would return [two rows for Eve](../main-concepts/join.md#employee-5_1), and subqueries used to define columns are only allowed to return a single value.

This is a good example of why correlated subqueries are less appropriate for joins!

## Using correlated subqueries for filtering

The examples above were contrived to demonstrate the concept, but they're not the best use cases for correlated subqueries.

The most common place that you'll see correlated subqueries being used is in the `WHERE` clause; these usually come in two forms:

- Relativity tests
- Existence tests

### Using correlated subqueries for relativity tests

It's typical to see correlated subqueries to be used to get the latest position of a record in a table that holds historical data.

For example, the `HumanResources.EmployeeDepartmentHistory` table holds the history of an employee's department. Let's take a look at the rows corresponding to employees 4, 16, 224, 234, and 250:

```sql
SELECT
    BusinessEntityID,
    DepartmentID,
    StartDate,
    EndDate
FROM HumanResources.EmployeeDepartmentHistory
WHERE BusinessEntityID IN (4, 16, 224, 234, 250)
ORDER BY BusinessEntityID, StartDate
;
```

| BusinessEntityID | DepartmentID | StartDate  | EndDate    |
| ---------------: | -----------: | :--------- | :--------- |
|                4 |            1 | 2007-12-05 | 2010-05-30 |
|                4 |            2 | 2010-05-31 | _null_     |
|               16 |            5 | 2007-12-20 | 2009-07-14 |
|               16 |            4 | 2009-07-15 | _null_     |
|              224 |            7 | 2009-01-07 | 2011-08-31 |
|              224 |            8 | 2011-09-01 | _null_     |
|              234 |           10 | 2009-01-31 | 2013-11-13 |
|              234 |           16 | 2013-11-14 | _null_     |
|              250 |            4 | 2011-02-25 | 2011-07-30 |
|              250 |           13 | 2011-07-31 | 2012-07-14 |
|              250 |            5 | 2012-07-15 | _null_     |

This table is nice for finding the latest department for each employee because we can just filter the rows where `EndDate` is `NULL`, but what if we didn't have the `EndDate` column and had to rely on just the `StartDate`?

We could use a correlated subquery to find the latest `StartDate` for each employee, and then use that to filter the rows:

```sql
SELECT
    BusinessEntityID,
    DepartmentID,
    StartDate
FROM HumanResources.EmployeeDepartmentHistory AS History
WHERE BusinessEntityID IN (4, 16, 224, 234, 250)
  AND StartDate = (
    SELECT MAX(StartDate)
    FROM HumanResources.EmployeeDepartmentHistory AS InnerHistory
    WHERE InnerHistory.BusinessEntityID = History.BusinessEntityID
  )
;
```

This is a bit more complex than the previous examples!

Not only is the subquery correlated, but it's also using an aggregate function (`MAX`) to find the latest `StartDate` for each employee.

Let's break down what's happening with each row in this table.

#### Employee 4

The first employee is 4, and they have two rows:

| BusinessEntityID | DepartmentID | StartDate  |
| ---------------: | -----------: | :--------- |
|                4 |            1 | 2007-12-05 |
|                4 |            2 | 2010-05-31 |

We know that we want to keep the row with the latest `StartDate`.

A correlated subquery is run _for each row_ in the `EmployeeDepartmentHistory` table, so the subquery is run twice for employee 4.

The subquery that is run for this employee (for _both_ their rows) is:

```sql
SELECT MAX(StartDate)
FROM HumanResources.EmployeeDepartmentHistory AS InnerHistory
WHERE InnerHistory.BusinessEntityID = 4
;
```

| MAX(StartDate) |
| :------------- |
| 2010-05-31     |

When the subquery is run for the first row, the `StartDate` is `2007-12-05`. This is not the result of the subquery, so the row is discarded.

Conversely, when the subquery is run for the second row, the `StartDate` is `2010-05-31` so this second row is kept.

#### Employee 16

The second employee is 16:

| BusinessEntityID | DepartmentID | StartDate  |
| ---------------: | -----------: | :--------- |
|               16 |            5 | 2007-12-20 |
|               16 |            4 | 2009-07-15 |

Similar to employee 4, a correlated subquery is run _for each row_ in the `EmployeeDepartmentHistory` table, so the subquery is also run twice for employee 16.

The subquery that is run for this employee (for _both_ their rows) is:

```sql
SELECT MAX(StartDate)
FROM HumanResources.EmployeeDepartmentHistory AS InnerHistory
WHERE InnerHistory.BusinessEntityID = 16
;
```

| MAX(StartDate) |
| :------------- |
| 2009-07-15     |

When the subquery is run for the first row, the `StartDate` is `2007-12-20`. This is not the result of the subquery, so the row is discarded.

Conversely, when the subquery is run for the second row, the `StartDate` is `2010-05-31` so this second row is kept.

#### Employees 224 and 234

Like the previous employees, employees 224 and 234 each have two rows, so the subquery is run twice for each of them too.

In both cases, the second row per employee is kept because it has the latest `StartDate`.

#### Employee 250

The fifth employee is 250:

| BusinessEntityID | DepartmentID | StartDate  |
| ---------------: | -----------: | :--------- |
|              250 |            4 | 2011-02-25 |
|              250 |           13 | 2011-07-31 |
|              250 |            5 | 2012-07-15 |

This employee has three rows, so the subquery is run three times for them.

The subquery that is run for this employee (for _all three_ of their rows) is:

```sql
SELECT MAX(StartDate)
FROM HumanResources.EmployeeDepartmentHistory AS InnerHistory
WHERE InnerHistory.BusinessEntityID = 250
;
```

| MAX(StartDate) |
| :------------- |
| 2012-07-15     |

When the subquery is run for the first row, the `StartDate` is `2011-02-25`. This is not the result of the subquery, so the row is discarded.

When the subquery is run for the second row, the `StartDate` is `2011-07-31`. Again, this is not the result of the subquery, so the row is discarded.

Finally, when the subquery is run for the third row, the `StartDate` is `2012-07-15` so this third row is kept.

#### Putting it all together

When we put all of these rows together, we get the following result:

| BusinessEntityID | DepartmentID | StartDate  |
| ---------------: | -----------: | :--------- |
|                4 |            2 | 2010-05-31 |
|               16 |            4 | 2009-07-15 |
|              224 |            8 | 2011-09-01 |
|              234 |           16 | 2013-11-14 |
|              250 |            5 | 2012-07-15 |

> [!TIP]
>
> There are other ways (not using correlated subqueries) to achieve this result, too. Can you think of any?

### Using correlated subqueries for existence tests

Another common place that you'll see correlated subqueries being used is to check whether a record exists.

In this case, the `EXISTS` keyword is used with the subquery to tell SQL to do the existence test.

For example, we could check which people in the `Person.Person` table have a record in the `HumanResources.JobCandidate` table:

```sql
SELECT
    BusinessEntityID,
    FirstName,
    LastName
FROM Person.Person
WHERE EXISTS (
    SELECT *
    FROM HumanResources.JobCandidate
    WHERE JobCandidate.BusinessEntityID = Person.BusinessEntityID
)
;
```

| BusinessEntityID | FirstName | LastName |
| ---------------: | :-------- | :------- |
|              212 | Peng      | Wu       |
|              274 | Stephen   | Jiang    |

As per [the Microsoft documentation](https://learn.microsoft.com/en-us/sql/relational-databases/performance/subqueries#exists):

> Notice that subqueries that are introduced with `EXISTS` are a bit different from other subqueries in the following ways:
>
> - The keyword `EXISTS` isn't preceded by a column name, constant, or other expression.
> - The select list of a subquery introduced by `EXISTS` almost always consists of an asterisk (`*`). There's no reason to list column names because you're just testing whether rows that meet the conditions specified in the subquery exist.
>
> The `EXISTS` keyword is important because frequently there's no alternative formulation without subqueries. Although some queries that are created with `EXISTS` can't be expressed any other way, many queries can use `IN` or a comparison operator modified by `ANY` or `ALL` to achieve similar results.

Our example is, in fact, an example of a query that can be expressed using `IN` instead of `EXISTS`:

```sql
SELECT
    BusinessEntityID,
    FirstName,
    LastName
FROM Person.Person
WHERE BusinessEntityID IN (
    SELECT BusinessEntityID
    FROM HumanResources.JobCandidate
)
;
```

So, what's an example of a query that _can't_ be expressed using `IN` instead of `EXISTS`?

It's rare, but you'd need `EXISTS` over `IN` to evaluate more complex conditions that can't be boiled down to an equality test.

For example, the following query can't be expressed using `IN`:

```sql
SELECT
    BusinessEntityID,
    FirstName,
    LastName,
    ModifiedDate
FROM Person.Person
WHERE EXISTS (
    SELECT *
    FROM HumanResources.JobCandidate
    WHERE JobCandidate.BusinessEntityID = Person.BusinessEntityID
      AND JobCandidate.ModifiedDate > Person.ModifiedDate
)
;
```

This query checks for people who have a record in the `HumanResources.JobCandidate` table that was modified more recently than their record in the `Person.Person` table.

This can't be expressed using `IN` because of the `JobCandidate.ModifiedDate > Person.ModifiedDate` condition.

This _could_, however, be expressed using a `LEFT JOIN` and a `WHERE` clause:

```sql
SELECT
    Person.BusinessEntityID,
    Person.FirstName,
    Person.LastName,
    Person.ModifiedDate
FROM Person.Person
    LEFT JOIN HumanResources.JobCandidate
        ON JobCandidate.BusinessEntityID = Person.BusinessEntityID
WHERE JobCandidate.BusinessEntityID IS NOT NULL
  AND JobCandidate.ModifiedDate > Person.ModifiedDate
;
```

Like with many SQL problems, the approach that you take will depend on the context, the performance of the approaches, and the readability of the code.

In this particular case, the `LEFT JOIN` is more performant than the `EXISTS` approach (on my personal computer, averaging 100,000 runs):

- The `LEFT JOIN` approach takes approximately 0.88 milliseconds to run (44%)
- The `EXISTS` approach takes approximately 1.11 milliseconds to run (56%)

However, the `EXISTS` approach is slightly more readable (in my opinion), so both approached have pros and cons.

> [!TIP]
>
> You'll encounter several ways to achieve the same output in SQL. There's rarely a "right" way to do something, so to figure out which approach you take, you should consider several things like:
>
> - The performance of the code
> - The readability of the code
> - The extensibility of the code
> - The preferences of your team/company
> - The tools that you have available to you
>
> This is not a complete list and there are many other things to consider, but it's a good starting point.

## A quick note for the programmers

> [!WARNING]
>
> If you've never done any programming before, skip this bit!

If you've used other programming languages, you might be thinking that correlated subqueries are similar to loops. You'd be right!

Correlated subqueries can be thought of as [for-loops](https://en.wikipedia.org/wiki/For_loop) that run for each row in a table.

This is why correlated subqueries can be slow if used inappropriately: they can run a lot of times!

## An extra example to get the brain juices flowing

> This example is taken from the following article:
>
> - [https://buttondown.email/jaffray/archive/sql-scoping-is-surprisingly-subtle-and-semantic/](https://buttondown.email/jaffray/archive/sql-scoping-is-surprisingly-subtle-and-semantic/)

Suppose we have the following tables:

`aa`

|   a |
| --: |
|   1 |
|   2 |
|   3 |

`xx`

|   x |
| --: |
|  10 |
|  20 |
|  30 |

What do you think the results of the following queries are?

```sql
SELECT (SELECT TOP 1 SUM(1)     FROM xx) FROM aa;
SELECT (SELECT TOP 1 SUM(a)     FROM xx) FROM aa;
SELECT (SELECT TOP 1 SUM(x)     FROM xx) FROM aa;
SELECT (SELECT TOP 1 SUM(a + x) FROM xx) FROM aa;
```

Here are the results:

<!-- prettier-ignore -->
??? note "Expand to show the results"
    |       `SELECT (SELECT TOP 1 SUM(1) FROM xx) FROM aa` |
    | ---------------------------------------------------: |
    |                                                    3 |
    |                                                    3 |
    |                                                    3 |

    |       `SELECT (SELECT TOP 1 SUM(a) FROM xx) FROM aa` |
    | ---------------------------------------------------: |
    |                                                    6 |

    |       `SELECT (SELECT TOP 1 SUM(x) FROM xx) FROM aa` |
    | ---------------------------------------------------: |
    |                                                   60 |
    |                                                   60 |
    |                                                   60 |

    |   `SELECT (SELECT TOP 1 SUM(a + x) FROM xx) FROM aa` |
    | ---------------------------------------------------: |
    |                                                   63 |
    |                                                   66 |
    |                                                   69 |

Weird, right? 🤯

See if you can wrap your head around what's going on here, and then check out [the article linked above](https://buttondown.email/jaffray/archive/sql-scoping-is-surprisingly-subtle-and-semantic/) for a great explanation of what's happening.

### The SQL for running this example

This data is not in the AdventureWorks database, so you can run this example using the SQL below (uncomment the line you want to run):

```sql
WITH

aa AS (
    SELECT *
    FROM (VALUES (1), (2), (3)) AS t(a)
),
xx AS (
    SELECT *
    FROM (VALUES (10), (20), (30)) AS t(x)
)

SELECT (SELECT TOP 1 SUM(1)     FROM xx) FROM aa
-- SELECT (SELECT TOP 1 SUM(a)     FROM xx) FROM aa
-- SELECT (SELECT TOP 1 SUM(x)     FROM xx) FROM aa
-- SELECT (SELECT TOP 1 SUM(a + x) FROM xx) FROM aa
;
```

## Further reading

Check out the [official Microsoft documentation](https://learn.microsoft.com/en-us/sql/relational-databases/performance/subqueries#correlated) for more information on correlated subqueries at:

- [https://learn.microsoft.com/en-us/sql/relational-databases/performance/subqueries#correlated](https://learn.microsoft.com/en-us/sql/relational-databases/performance/subqueries#correlated)

### Similarity to `CROSS APPLY`

There is a similarity between correlated subqueries and `CROSS APPLY`. This is outside the scope of this course, but you can read more about it at:

- [https://learn.microsoft.com/en-us/sql/t-sql/queries/from-transact-sql#using-apply](https://learn.microsoft.com/en-us/sql/t-sql/queries/from-transact-sql#using-apply)
- [https://learn.microsoft.com/en-us/sql/t-sql/queries/from-transact-sql#k-use-apply](https://learn.microsoft.com/en-us/sql/t-sql/queries/from-transact-sql#k-use-apply)
- [https://learn.microsoft.com/en-us/sql/t-sql/queries/from-transact-sqll-use-cross-apply](https://learn.microsoft.com/en-us/sql/t-sql/queries/from-transact-sql#l-use-cross-apply)
