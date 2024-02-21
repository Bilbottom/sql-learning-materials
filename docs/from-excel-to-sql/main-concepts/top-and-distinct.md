# `TOP` and `DISTINCT` 🔝

> [!SUCCESS]
>
> The `TOP` and `DISTINCT` keywords are handy modifiers to use after `SELECT`.

> [!NOTE]
>
> `TOP` and `DISTINCT` should be used _immediately_ after the `SELECT` keyword.

## `TOP` will limit the number of rows returned

[The `TOP` keyword](https://learn.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql) is used to limit the number of rows returned from a `SELECT` statement. This is particularly useful when you're only interested in the first few rows of a result.

```sql
SELECT TOP 5
    DepartmentID,
    Name
FROM HumanResources.Department
;
```

| DepartmentID | Name                       |
| -----------: | :------------------------- |
|           12 | Document Control           |
|            1 | Engineering                |
|           16 | Executive                  |
|           14 | Facilities and Maintenance |
|           10 | Finance                    |

If you use `TOP` with an `ORDER BY` clause, the rows will be ordered first and then the `TOP` will be applied:

```sql
SELECT TOP 5
    DepartmentID,
    Name
FROM HumanResources.Department
ORDER BY DepartmentID
;
```

| DepartmentID | Name        |
| -----------: | :---------- |
|            1 | Engineering |
|            2 | Tool Design |
|            3 | Sales       |
|            4 | Marketing   |
|            5 | Purchasing  |

### Other SQL flavours might use `LIMIT` instead of `TOP`

This is just an FYI! Although Microsoft SQL Server (and a few other SQL flavours) use `TOP`, other SQL flavours use the keyword `LIMIT` instead. Flavours that use `LIMIT` also put it at the end of the statement instead of after the `SELECT` clause, too, like this:

```sql
SELECT
    DepartmentID,
    Name
FROM HumanResources.Department
ORDER BY DepartmentID
LIMIT 5
;
```

Make sure you know which SQL flavour you're using so that you can use the right keyword!

## `DISTINCT` will remove duplicate rows from the result

> [!SUCCESS]
>
> `DISTINCT` is equivalent to using the "Remove Duplicates" feature in Excel!

[The `DISTINCT` keyword](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-transact-sql#c-using-distinct-with-select) can take a bit of getting used to, but it is used to remove duplicate rows from the result. Note that "duplicate" means _every value in the row is the same as the corresponding value in another row_.

For example, this output has rows that are the same:

```sql
SELECT
    GroupName,
    ModifiedDate
FROM HumanResources.Department
WHERE GroupName = 'Research and Development'
;
```

| GroupName                | ModifiedDate            |
| :----------------------- | :---------------------- |
| Research and Development | 2008-04-30 00:00:00.000 |
| Research and Development | 2008-04-30 00:00:00.000 |
| Research and Development | 2008-04-30 00:00:00.000 |

Adding `DISTINCT` will remove the duplicates, keeping only the unique rows:

```sql
SELECT DISTINCT
    GroupName,
    ModifiedDate
FROM HumanResources.Department
WHERE GroupName = 'Research and Development'
;
```

| GroupName                | ModifiedDate            |
| :----------------------- | :---------------------- |
| Research and Development | 2008-04-30 00:00:00.000 |

This keyword is particularly useful when you're interested in the unique values of a column, such as:

```sql
SELECT DISTINCT GroupName
FROM HumanResources.Department
;
```

| GroupName                            |
| :----------------------------------- |
| Executive General and Administration |
| Inventory Management                 |
| Manufacturing                        |
| Quality Assurance                    |
| Research and Development             |
| Sales and Marketing                  |

## `TOP` and `DISTINCT` can be used together

Although it might not be super helpful, you can use `TOP` and `DISTINCT` together to get the first few unique rows from a result:

```sql
SELECT DISTINCT TOP 3
    GroupName,
    ModifiedDate
FROM HumanResources.Department
;
```

| GroupName                            | ModifiedDate            |
| :----------------------------------- | :---------------------- |
| Executive General and Administration | 2008-04-30 00:00:00.000 |
| Inventory Management                 | 2008-04-30 00:00:00.000 |
| Manufacturing                        | 2008-04-30 00:00:00.000 |

The keyword order is important here -- `DISTINCT` has to be written before `TOP`.

## Further reading

Check out the [official Microsoft documentation](https://learn.microsoft.com/en-us/sql/t-sql/queries/queries) for more information on `TOP` and `DISTINCT` at:

- [https://learn.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql)
- [https://learn.microsoft.com/en-us/sql/t-sql/queries/select-transact-sql#c-using-distinct-with-select](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-transact-sql#c-using-distinct-with-select)

The video version of this content is also available at:

- https://youtu.be/-0M-kEkoDqw

### Additional modifiers

The `TOP` keyword also has additional modifiers which are outside the scope of this course. These include `PERCENT`, `WITH TIES`, and using an expression rather than a fixed number:

- [https://learn.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql#c-specifying-a-percentage](https://learn.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql#c-specifying-a-percentage)
- [https://learn.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql#a-using-with-ties-to-include-rows-that-match-the-values-in-the-last-row](https://learn.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql#a-using-with-ties-to-include-rows-that-match-the-values-in-the-last-row)
- [https://learn.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql#arguments](https://learn.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql#arguments)

> [!ERROR]
>
> This is a contrived example (using a larger table) to show the additional modifiers.
>
> ```sql
> SELECT TOP (10 * RAND()) PERCENT WITH TIES
>     FirstName,
>     LastName
> FROM Person.Person
> ORDER BY FirstName
> ;
> ```
