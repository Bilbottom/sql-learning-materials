# Filtering 🚦

> [!SUCCESS]
>
> The `WHERE` clause is used to filter the rows in a query. It's like the "filter" feature in Excel!

> [!NOTE]
>
> The `WHERE` clause is optional. If you use it, it must come after the `FROM` clause.

## `WHERE` is how we filter rows

So far, we've been able to "open a file" by using `SELECT` and `FROM`.

To filter rows, use [the `WHERE` clause](https://learn.microsoft.com/en-us/sql/t-sql/queries/where-transact-sql) and specify the condition that you want to filter by.

Excel is convenient and gives us a pop-up box to select the values we want to filter by, but for SQL we have to write the condition ourselves. The way that we write the condition is similar to how we write the conditions for the `IF` function in Excel using the following operators:

- `<` (less than)
- `<=` (less than or equal to)
- `>` (greater than)
- `>=` (greater than or equal to)
- `=` (equals)
- `<>` (does not equal), also written as `!=`

For example, we could filter the `HumanResources.Department` table for people who have the first name `Rob` using:

```sql
SELECT
    DepartmentID,
    Name,
    GroupName
FROM HumanResources.Department
WHERE DepartmentID = 5
;
```

| DepartmentID | Name       | GroupName            |
| -----------: | :--------- | :------------------- |
|            5 | Purchasing | Inventory Management |

> [!TIP]
>
> The `WHERE` clause "sounds like" English, so the query above can be read as:
>
> > "**Select** the **department ID**, **name**, and **group name from** the **`HumanResources.Department`** table **where** the **department ID is 5**".

Similarly, we could filter the `HumanResources.Department` table for departments whose ID is less than or equal to `5` using:

```sql
SELECT
    DepartmentID,
    Name,
    GroupName
FROM HumanResources.Department
WHERE DepartmentID <= 5
;
```

| DepartmentID | Name        | GroupName                |
| -----------: | :---------- | :----------------------- |
|            1 | Engineering | Research and Development |
|            2 | Tool Design | Research and Development |
|            3 | Sales       | Sales and Marketing      |
|            4 | Marketing   | Sales and Marketing      |
|            5 | Purchasing  | Inventory Management     |

## Conditions can be combined with `AND` and `OR`

If you wanted to have multiple conditions in an `IF` statement in Excel, you'd need to use the `AND` or `OR` functions:

```
=IF(AND(A1 = "Alan", B1 <= 5), "Yes", "No")
```

In SQL, `AND` and `OR` aren't functions; they're keywords that you use to combine conditions in the `WHERE` clause.

For example, we could filter the `HumanResources.Department` table for departments whose ID is less than or equal to `5` _and_ the department group name is `Research and Development` with:

```sql
SELECT
    DepartmentID,
    Name,
    GroupName
FROM HumanResources.Department
WHERE DepartmentID <= 5 AND GroupName = 'Research and Development'
;
```

| DepartmentID | Name        | GroupName                |
| -----------: | :---------- | :----------------------- |
|            1 | Engineering | Research and Development |
|            2 | Tool Design | Research and Development |

> [!TIP]
>
> Combining conditions "sounds like" English, so the query above can be read as:
>
> > "**Select** the **department ID**, **name**, and **group name from** the **`HumanResources.Department`** table **where** the **department ID is less than or equal to 5 and** the **group name is `Research and Development`**".

Similarly, we could filter the `HumanResources.Department` table for departments whose group name is either `Sales and Marketing` or `Research and Development` using:

```sql
SELECT
    DepartmentID,
    Name,
    GroupName
FROM HumanResources.Department
WHERE GroupName = 'Sales and Marketing' OR GroupName = 'Research and Development'
;
```

| DepartmentID | Name                     | GroupName                |
| -----------: | :----------------------- | :----------------------- |
|            1 | Engineering              | Research and Development |
|            2 | Tool Design              | Research and Development |
|            3 | Sales                    | Sales and Marketing      |
|            4 | Marketing                | Sales and Marketing      |
|            6 | Research and Development | Research and Development |

It's common to use `IN` (and `NOT IN`) to streamline multiple `OR` conditions. For example, the previous query could be written as:

```sql
SELECT
    DepartmentID,
    Name,
    GroupName
FROM HumanResources.Department
WHERE GroupName IN ('Sales and Marketing', 'Research and Development')
;
```

Note that the `IN` keyword is followed by a list of values _in brackets separated by commas_.

You can combine `AND` and `OR` in the same `WHERE` clause, but it's a good idea to use brackets to make the order of operations clear. For example, the following query filters the `HumanResources.Department` table for departments whose ID is less than or equal to `5` _and_ the department group name is `Research and Development`, _or_ the department group name is ``:

```sql
SELECT
    DepartmentID,
    Name,
    GroupName
FROM HumanResources.Department
WHERE (DepartmentID <= 5 AND GroupName = 'Research and Development')
   OR DepartmentID = 10
;
```

| DepartmentID | Name        | GroupName                            |
| -----------: | :---------- | :----------------------------------- |
|            1 | Engineering | Research and Development             |
|            2 | Tool Design | Research and Development             |
|           10 | Finance     | Executive General and Administration |

## Use `IS` (`NOT`) `NULL` to filter `NULL` values

> [!WARNING]
>
> We'll learn more about `NULL` values in the [Data types](data-types.md) section, but for now, we'll mention that `NULL` is a special value that you'll sometimes see in SQL which represents a missing value similar to how `(blank)` is used in Excel.

Instead of using `=` or `!=` to filter `NULL` values, you need to use the special `IS NULL` or `IS NOT NULL` keywords.

For example, we could filter the `HumanResources.EmployeeDepartmentHistory` table for employees whose department end date is missing using:

```sql
SELECT
    BusinessEntityID,
    DepartmentID,
    StartDate,
    EndDate
FROM HumanResources.EmployeeDepartmentHistory
WHERE EndDate IS NULL
```

| BusinessEntityID | DepartmentID | StartDate  | EndDate |
| ---------------: | -----------: | :--------- | :------ |
|                1 |           16 | 2009-01-14 | _null_  |
|                2 |            1 | 2008-01-31 | _null_  |
|                3 |            1 | 2007-11-11 | _null_  |
|                4 |            2 | 2010-05-31 | _null_  |
|                5 |            1 | 2008-01-06 | _null_  |

## Further reading

Check out the [official Microsoft documentation](https://learn.microsoft.com/en-us/sql/t-sql/queries/where-transact-sql) for more information on the `WHERE` clause at:

- [https://learn.microsoft.com/en-us/sql/t-sql/queries/where-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/queries/where-transact-sql)

The video version of this content is also available at:

- https://youtu.be/g_5OxUYPx7E

### Additional comparison operators

There are additional comparison operators that you can use in the `WHERE` clause which are outside the scope of this course. These include but are not limited to the `BETWEEN`, `LIKE`, and `EXISTS` operators:

- [https://learn.microsoft.com/en-us/sql/t-sql/language-elements/between-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/between-transact-sql)
- [https://learn.microsoft.com/en-us/sql/t-sql/language-elements/like-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/like-transact-sql)
- [https://learn.microsoft.com/en-us/sql/t-sql/language-elements/exists-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/exists-transact-sql)

> [!ERROR]
>
> This is a contrived example to show some of the additional comparison operators.
>
> ```sql
> SELECT
>     DepartmentID,
>     Name,
>     GroupName
> FROM HumanResources.Department
> WHERE DepartmentID BETWEEN 1 AND 5
>    OR GroupName NOT LIKE '%and%'
> ;
> ```
