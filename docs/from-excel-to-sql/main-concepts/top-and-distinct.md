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
    BusinessEntityID,
    FirstName,
    LastName
FROM Person.Person
;
```

| BusinessEntityID | FirstName | LastName    |
| ---------------: | :-------- | :---------- |
|              285 | Syed      | Abbas       |
|              293 | Catherine | Abel        |
|              295 | Kim       | Abercrombie |
|             2170 | Kim       | Abercrombie |
|               38 | Kim       | Abercrombie |

If you use `TOP` with an `ORDER BY` clause, the rows will be ordered first and then the `TOP` will be applied:

```sql
SELECT TOP 5
    BusinessEntityID,
    FirstName,
    LastName
FROM Person.Person
ORDER BY BusinessEntityID
;
```

| BusinessEntityID | FirstName | LastName   |
| ---------------: | :-------- | :--------- |
|                1 | Ken       | Sánchez    |
|                2 | Terri     | Duffy      |
|                3 | Roberto   | Tamburello |
|                4 | Rob       | Walters    |
|                5 | Gail      | Erickson   |

### Other SQL flavours might use `LIMIT` instead of `TOP`

This is just an FYI! Although Microsoft SQL Server (and a few other SQL flavours) use `TOP`, other SQL flavours use the keyword `LIMIT` instead. Flavours that use `LIMIT` also put it at the end of the statement instead of after the `SELECT` clause, too, like this:

```sql
SELECT
    BusinessEntityID,
    FirstName,
    LastName
FROM Person.Person
ORDER BY BusinessEntityID
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
    FirstName,
    LastName
FROM Person.Person
WHERE FirstName = 'Rob'
;
```

| FirstName | LastName |
| :-------- | :------- |
| Rob       | Caron    |
| Rob       | Caron    |
| Rob       | Verhoff  |
| Rob       | Walters  |
| Rob       | Young    |

Adding `DISTINCT` will remove the duplicates, keeping only the unique rows:

```sql
SELECT DISTINCT
    FirstName,
    LastName
FROM Person.Person
WHERE FirstName = 'Rob'
;
```

| FirstName | LastName |
| :-------- | :------- |
| Rob       | Caron    |
| Rob       | Verhoff  |
| Rob       | Walters  |
| Rob       | Young    |

This keyword is particularly useful when you're interested in the unique values of a column, such as:

```sql
SELECT DISTINCT PersonType
FROM Person.Person
;
```

| PersonType |
| :--------- |
| IN         |
| EM         |
| SP         |
| SC         |
| VC         |
| GC         |

## `TOP` and `DISTINCT` can be used together

Although it might not be super helpful, you can use `TOP` and `DISTINCT` together to get the first few unique rows from a result:

```sql
SELECT DISTINCT TOP 2
    FirstName,
    LastName
FROM Person.Person
WHERE FirstName = 'Rob'
;
```

| FirstName | LastName |
| :-------- | :------- |
| Rob       | Caron    |
| Rob       | Verhoff  |

The keyword order is important here -- `DISTINCT` has to be written before `TOP`.

## Further reading

Check out the [official Microsoft documentation](https://learn.microsoft.com/en-us/sql/t-sql/queries/queries) for more information on `TOP` and `DISTINCT` at:

- [https://learn.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql)
- [https://learn.microsoft.com/en-us/sql/t-sql/queries/select-transact-sql#c-using-distinct-with-select](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-transact-sql#c-using-distinct-with-select)

### Additional modifiers

The `TOP` keyword also has additional modifiers which are outside the scope of this course. These include `PERCENT`, `WITH TIES`, and using an expression rather than a fixed number:

- [https://learn.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql#c-specifying-a-percentage](https://learn.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql#c-specifying-a-percentage)
- [https://learn.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql#a-using-with-ties-to-include-rows-that-match-the-values-in-the-last-row](https://learn.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql#a-using-with-ties-to-include-rows-that-match-the-values-in-the-last-row)
- [https://learn.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql#arguments](https://learn.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql#arguments)

> [!ERROR]
>
> This is a contrived example to show the additional modifiers.
>
> ```sql
> SELECT TOP (10 * RAND()) PERCENT WITH TIES
>     FirstName,
>     LastName
> FROM Person.Person
> ORDER BY FirstName
> ;
> ```
