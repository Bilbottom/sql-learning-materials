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

For example, we could sort the `Person.Person` table by the `LastName` column in ascending order using:

```sql
SELECT
    BusinessEntityID,
    FirstName,
    LastName
FROM Person.Person
ORDER BY LastName
;
```

| BusinessEntityID | FirstName | LastName    |
| ---------------: | :-------- | :---------- |
|              285 | Syed      | Abbas       |
|              293 | Catherine | Abel        |
|              295 | Kim       | Abercrombie |
|             2170 | Kim       | Abercrombie |
|               38 | Kim       | Abercrombie |

> [!TIP]
>
> The `ORDER BY` clause "sounds like" English, so the query above can be read as:
>
> > "**Select** the **business entity ID**, **first name**, and **last name from** the **`Person.Person`** table and **order by** the **last name**".

To sort in descending order, use the `DESC` keyword:

```sql
SELECT
    BusinessEntityID,
    FirstName,
    LastName
FROM Person.Person
ORDER BY LastName DESC
;
```

| BusinessEntityID | FirstName | LastName |
| ---------------: | :-------- | :------- |
|             2089 | Michael   | Zwilling |
|               64 | Michael   | Zwilling |
|            12079 | Jake      | Zukowski |
|             2088 | Judy      | Zugelder |
|             2087 | Patricia  | Zubaty   |

To sort by multiple columns, separate the columns with a comma:

```sql
SELECT
    BusinessEntityID,
    FirstName,
    LastName
FROM Person.Person
ORDER BY LastName DESC, BusinessEntityID
;
```

| BusinessEntityID | FirstName | LastName |
| ---------------: | :-------- | :------- |
|               64 | Michael   | Zwilling |
|             2089 | Michael   | Zwilling |
|            12079 | Jake      | Zukowski |
|             2088 | Judy      | Zugelder |
|             2086 | Carla     | Zubaty   |

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
    BusinessEntityID AS ID,
    FirstName AS Forename,
    LastName AS Surname
FROM Person.Person
ORDER BY Forename, Surname, ID
;
```

|    ID | Forename | Surname   |
| ----: | :------- | :-------- |
|  1305 | A.       | Leonetti  |
|  2321 | A.       | Wright    |
|   222 | A. Scott | Wright    |
| 16867 | Aaron    | Adams     |
|  5508 | Aaron    | Alexander |

## You can sort by column numbers, but don't

> [!INFO]
>
> This is just a FYI in case you see this out in the wild.

Instead of using the column names in the `ORDER BY` clause, you can use their position in the query (starting at 1). For example, the following query sorts the `Person.Person` table by the `LastName` column:

```sql
SELECT
    BusinessEntityID,
    FirstName,
    LastName
FROM Person.Person
ORDER BY 3
;
```

Although this is possible, it's not recommended (as per [the Microsoft documentation](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-order-by-clause-transact-sql#best-practices)):

> Avoid specifying integers in the ORDER BY clause as positional representations of the columns in the select list. For example, although a statement such as `SELECT ProductID, Name FROM Production.Production ORDER BY 2` is valid, the statement is not as easily understood by others compared with specifying the actual column name. In addition, changes to the select list, such as changing the column order or adding new columns, requires modifying the ORDER BY clause in order to avoid unexpected results.

## Further reading

Check out the [official Microsoft documentation](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-order-by-clause-transact-sql) for more information on the `ORDER BY` clause at:

- [https://learn.microsoft.com/en-us/sql/t-sql/queries/select-order-by-clause-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-order-by-clause-transact-sql)

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
>     BusinessEntityID,
>     FirstName,
>     LastName
> FROM Person.Person
> ORDER BY BusinessEntityID
>   OFFSET 10 ROWS
>   FETCH NEXT 5 ROWS ONLY
> ;
> ```
