# Unions 🧬

> [!SUCCESS]
>
> Like joins, unions are a way to combine data from tables, but they do it vertically instead of horizontally.
>
> That is, a `JOIN` adds _columns_ to a table, while a `UNION` adds _rows_ to a table.

> [!NOTE]
>
> The `UNION` clause is optional. If you use it, it must be _between two individual `SELECT` statements_.
>
> This makes the `UNION` clause a bit different to what we've seen so far!

> [!WARNING]
>
> Excel doesn't really have an equivalent to SQL's `UNION` (without using advanced Excel features), but it's just like stacking two tables on top of each other 😝

## The `UNION` clause also combines data from tables

Sometimes you want to combine data from two tables, but you don't want to join them together. Instead, you want to "stack" the tables on top of each other.

The `UNION` clause does this by taking the results of two `SELECT` statements and combining them into a single result.

Since SQL tables are fairly rigid, there are two important rules that the separate `SELECT` statement must follow to be able to be combined with a `UNION` clause:

1. The number of columns in each `SELECT` statement must be the same.
2. The data types of the columns in each `SELECT` statement must be compatible.

To be super clear, the `UNION` clause _does not check the names of the columns_ in the `SELECT` statements. It only checks the _number_ of columns and the _data types_ of the columns, and only keeps the names from the first `SELECT` statement.

This makes the `UNION` clause more prone to error than other clauses, but it's still a handy feature to know about.

The following is a contrived example, but it shows how the `UNION` clause works:

```sql
    SELECT TOP 3
        BusinessEntityID,
        PersonType,
        FirstName,
        LastName
    FROM Person.Person
    WHERE PersonType = 'EM'
UNION
    SELECT TOP 3
        BusinessEntityID,
        PersonType,
        FirstName,
        LastName
    FROM Person.Person
    WHERE PersonType = 'SP'
;
```

| BusinessEntityID | PersonType | FirstName | LastName   |
| ---------------: | :--------- | :-------- | :--------- |
|                1 | EM         | Ken       | Sánchez    |
|                2 | EM         | Terri     | Duffy      |
|                3 | EM         | Roberto   | Tamburello |
|              274 | SP         | Stephen   | Jiang      |
|              275 | SP         | Michael   | Blythe     |
|              276 | SP         | Linda     | Mitchell   |

## `UNION` vs `UNION ALL`

By itself, the `UNION` clause removes duplicate rows from the combined result set just as if you had used the `DISTINCT` clause:

```sql
    SELECT 1 AS Number, 'a' AS Letter
UNION
    SELECT 1, 'a'
UNION
    SELECT 2, 'b'
UNION
    SELECT 2, 'c'
;
```

| Number | Letter |
| -----: | :----- |
|      1 | a      |
|      2 | b      |
|      2 | c      |

If you want to keep the duplicate rows, you can use the `UNION ALL` clause instead:

```sql
    SELECT 1 AS Number, 'a' AS Letter
UNION ALL
    SELECT 1, 'a'
UNION ALL
    SELECT 2, 'b'
UNION ALL
    SELECT 2, 'c'
;
```

| Number | Letter |
| -----: | :----- |
|      1 | a      |
|      1 | a      |
|      2 | b      |
|      2 | c      |

## Further reading

Check out the [official Microsoft documentation](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/set-operators-union-transact-sql) for more information on the `UNION` clause at:

- [https://learn.microsoft.com/en-us/sql/t-sql/language-elements/set-operators-union-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/set-operators-union-transact-sql)

### Additional set operators

The `UNION` clause combines the results of two `SELECT` statements into a single result set.

There are two other set operators outside the scope of this course. They are `EXCEPT` and `INTERSECT`:

- [https://learn.microsoft.com/en-us/sql/t-sql/language-elements/set-operators-except-and-intersect-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/set-operators-except-and-intersect-transact-sql)
- [https://learn.microsoft.com/en-us/sql/t-sql/language-elements/set-operators-except-and-intersect-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/set-operators-except-and-intersect-transact-sql)
