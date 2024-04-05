# Ordering ⏬

> [!SUCCESS]
>
> The `ORDER BY` clause is used to sort the rows in a query. It's like the "Sort by" feature in Excel!

> [!NOTE]
>
> The `ORDER BY` clause is optional. If you use it, it must come at the end of the SQL statement.

## `ORDER BY` is how we sort rows

We know how to "open a file" using `SELECT` and `FROM`, and we know how to "filter" rows using `WHERE`.

To sort rows, use [the `ORDER BY` clause](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-order-by-clause-transact-sql) and specify the columns that you want to order by.

In Excel, there are two ways to sort data:

1. Click on the column header and use the "Sort A to Z" or "Sort Z to A" buttons.
2. Use the "Sort" feature in the "Data" tab.

Sorting in SQL is more like the second option, where you can specify the columns to sort by and the direction to sort in (ascending or descending).

For example, we could sort the `HumanResources.Department` table by the `Name` column in ascending order using:

```sql
SELECT
    DepartmentID,
    Name,
    GroupName
FROM HumanResources.Department
ORDER BY Name
;
```

| DepartmentID | Name                       | GroupName                            |
| -----------: | :------------------------- | :----------------------------------- |
|           12 | Document Control           | Quality Assurance                    |
|            1 | Engineering                | Research and Development             |
|           16 | Executive                  | Executive General and Administration |
|           14 | Facilities and Maintenance | Executive General and Administration |
|           10 | Finance                    | Executive General and Administration |

> [!TIP]
>
> The `ORDER BY` clause "sounds like" English, so the query above can be read as:
>
> > "**Select** the **department ID**, **name**, and **group name from** the **`HumanResources.Department`** table and **order by** the **name**".

To sort in descending order, use the `DESC` keyword:

```sql
SELECT
    DepartmentID,
    Name,
    GroupName
FROM HumanResources.Department
ORDER BY Name DESC
;
```

| DepartmentID | Name                     | GroupName                |
| -----------: | :----------------------- | :----------------------- |
|            2 | Tool Design              | Research and Development |
|           15 | Shipping and Receiving   | Inventory Management     |
|            3 | Sales                    | Sales and Marketing      |
|            6 | Research and Development | Research and Development |
|           13 | Quality Assurance        | Quality Assurance        |

To sort by multiple columns, separate the columns with a comma:

```sql
SELECT
    DepartmentID,
    Name,
    GroupName
FROM HumanResources.Department
ORDER BY GroupName, DepartmentID
;
```

| DepartmentID | Name                       | GroupName                            |
| -----------: | :------------------------- | :----------------------------------- |
|            9 | Human Resources            | Executive General and Administration |
|           10 | Finance                    | Executive General and Administration |
|           11 | Information Services       | Executive General and Administration |
|           14 | Facilities and Maintenance | Executive General and Administration |
|           16 | Executive                  | Executive General and Administration |

> [!WARNING]
>
> If the `ORDER BY` tries to sort repeated values, the order of the rows is not guaranteed. If you need to guarantee the order of the rows, make sure you include enough columns in the `ORDER BY` clause.

## You can use the column alias in the `ORDER BY` clause

> [!INFO]
>
> The `ORDER BY` clause is one of the few places where this works; it doesn't work in most other places (in Microsoft SQL Server).

If you rename/use an alias for a column in the `SELECT` clause, you can use that alias in the `ORDER BY` clause. For example:

```sql
SELECT
    DepartmentID AS ID,
    Name,
    GroupName
FROM HumanResources.Department
ORDER BY GroupName, ID
;
```

## You can sort by column numbers, but don't

> [!INFO]
>
> This is just a FYI in case you see this out in the wild.

Instead of using the column names in the `ORDER BY` clause, you can use their position in the query (starting at 1). For example, the following query sorts the `HumanResources.Department` table by the `GroupName` column:

```sql
SELECT
    DepartmentID,
    Name,
    GroupName
FROM HumanResources.Department
ORDER BY 3
;
```

Although this is possible, it's not recommended (as per [the Microsoft documentation](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-order-by-clause-transact-sql#best-practices)):

> Avoid specifying integers in the ORDER BY clause as positional representations of the columns in the select list. For example, although a statement such as `SELECT ProductID, Name FROM Production.Production ORDER BY 2` is valid, the statement is not as easily understood by others compared with specifying the actual column name. In addition, changes to the select list, such as changing the column order or adding new columns, requires modifying the ORDER BY clause in order to avoid unexpected results.

## Further reading

Check out the [official Microsoft documentation](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-order-by-clause-transact-sql) for more information on the `ORDER BY` clause at:

- [https://learn.microsoft.com/en-us/sql/t-sql/queries/select-order-by-clause-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-order-by-clause-transact-sql)

The video version of this content is also available at:

- https://youtu.be/yaomCldxZi4

### Additional modifiers

The `ORDER BY` clause also has additional modifiers which are outside the scope of this course. These include `COLLATE`, `OFFSET`, and `FETCH`:

- [https://learn.microsoft.com/en-us/sql/t-sql/queries/select-order-by-clause-transact-sql#Collation](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-order-by-clause-transact-sql#Collation)
- [https://learn.microsoft.com/en-us/sql/t-sql/queries/select-order-by-clause-transact-sql#using-offset-and-fetch-to-limit-the-rows-returned](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-order-by-clause-transact-sql#using-offset-and-fetch-to-limit-the-rows-returned)

> [!ERROR]
>
> This is a contrived example to show the additional modifiers.
>
> ```sql
> SELECT
>     DepartmentID,
>     Name,
>     GroupName
> FROM HumanResources.Department
> ORDER BY DepartmentID
>   OFFSET 10 ROWS
>   FETCH NEXT 5 ROWS ONLY
> ;
> ```
