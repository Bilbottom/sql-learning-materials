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

For example, we could filter the `Person.Person` table for people who have the first name `Rob` using:

```sql
SELECT
    BusinessEntityID,
    FirstName,
    LastName
FROM Person.Person
WHERE FirstName = 'Rob'
;
```

| BusinessEntityID | FirstName | LastName |
| ---------------: | :-------- | :------- |
|                4 | Rob       | Walters  |
|              130 | Rob       | Caron    |
|              637 | Rob       | Caron    |
|             2071 | Rob       | Young    |
|            14673 | Rob       | Verhoff  |

> [!TIP]
>
> The `WHERE` clause "sounds like" English, so the query above can be read as:
>
> > "**Select** the **business entity ID**, **first name**, and **last name from** the **`Person.Person`** table **where** the **first name is Rob**".

Similarly, we could filter the `Person.Person` table for people whose ID is less than or equal to `5` using:

```sql
SELECT
    BusinessEntityID,
    FirstName,
    LastName
FROM Person.Person
WHERE BusinessEntityID <= 5
;
```

| BusinessEntityID | FirstName | LastName   |
| ---------------: | :-------- | :--------- |
|                1 | Ken       | Sánchez    |
|                2 | Terri     | Duffy      |
|                3 | Roberto   | Tamburello |
|                4 | Rob       | Walters    |
|                5 | Gail      | Erickson   |

## Conditions can be combined with `AND` and `OR`

If you wanted to have multiple conditions in an `IF` statement in Excel, you'd need to use the `AND` or `OR` functions:

```
=IF(AND(A1 = "Alan", B1 <= 5), "Yes", "No")
```

In SQL, `AND` and `OR` aren't functions; they're keywords that you use to combine conditions in the `WHERE` clause.

For example, we could filter the `Person.Person` table for people whose first name is `Rob` _and_ whose ID is less than or equal to `5` using:

```sql
SELECT
    BusinessEntityID,
    FirstName,
    LastName
FROM Person.Person
WHERE FirstName = 'Rob' AND BusinessEntityID <= 5
;
```

| BusinessEntityID | FirstName | LastName |
| ---------------: | :-------- | :------- |
|                4 | Rob       | Walters  |

> [!TIP]
>
> Combining conditions "sounds like" English, so the query above can be read as:
>
> > "**Select** the **business entity ID**, **first name**, and **last name from** the **`Person.Person`** table **where** the **first name is Rob and the business entity ID is less than 5**".

Similarly, we could filter the `Person.Person` table for people whose first name is either `Rob` or `Ken` using:

```sql
SELECT
    BusinessEntityID,
    FirstName,
    LastName
FROM Person.Person
WHERE FirstName = 'Rob' OR FirstName = 'Ken'
;
```

| BusinessEntityID | FirstName | LastName |
| ---------------: | :-------- | :------- |
|                1 | Ken       | Sánchez  |
|                4 | Rob       | Walters  |
|              130 | Rob       | Caron    |
|              203 | Ken       | Myer     |
|              637 | Rob       | Caron    |

It's common to use `IN` (and `NOT IN`) to streamline multiple `OR` conditions. For example, the previous query could be written as:

```sql
SELECT
    BusinessEntityID,
    FirstName,
    LastName
FROM Person.Person
WHERE FirstName IN ('Rob', 'Ken')
;
```

Note that the `IN` keyword is followed by a list of values _in brackets separated by commas_.

You can combine `AND` and `OR` in the same `WHERE` clause, but it's a good idea to use brackets to make the order of operations clear. For example, the following query filters the `Person.Person` table for people whose first name is `Rob` _and_ whose ID is less than or equal to `5`, _or_ whose first name is `Ken`:

```sql
SELECT
    BusinessEntityID,
    FirstName,
    LastName
FROM Person.Person
WHERE (FirstName = 'Rob' AND BusinessEntityID <= 5) OR FirstName = 'Ken'
;
```

| BusinessEntityID | FirstName | LastName |
| ---------------: | :-------- | :------- |
|                1 | Ken       | Sánchez  |
|                4 | Rob       | Walters  |
|              203 | Ken       | Myer     |
|             1525 | Ken       | Myer     |
|             1726 | Ken       | Sánchez  |

## Use `IS` (`NOT`) `NULL` to filter `NULL` values

> [!WARNING]
>
> We'll learn more about `NULL` values in the [Data types](data-types.md) section, but for now, we'll mention that `NULL` is a special value that you'll sometimes see in SQL which represents a missing value similar to how `(blank)` is used in Excel.

Instead of using `=` or `!=` to filter `NULL` values, you need to use the special `IS NULL` or `IS NOT NULL` keywords.

For example, we could filter the `Person.Person` table for people whose middle name is missing using:

```sql
SELECT
    BusinessEntityID,
    FirstName,
    MiddleName,
    LastName
FROM Person.Person
WHERE MiddleName IS NULL
```

| BusinessEntityID | FirstName | MiddleName | LastName   |
| ---------------: | :-------- | :--------- | :--------- |
|                3 | Roberto   | _null_     | Tamburello |
|                4 | Rob       | _null_     | Walters    |
|               10 | Michael   | _null_     | Raheem     |
|               41 | Bryan     | _null_     | Baker      |
|               94 | Russell   | _null_     | Hunter     |

## Further reading

Check out the [official Microsoft documentation](https://learn.microsoft.com/en-us/sql/t-sql/queries/where-transact-sql) for more information on the `WHERE` clause at:

- [https://learn.microsoft.com/en-us/sql/t-sql/queries/where-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/queries/where-transact-sql)

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
>     BusinessEntityID,
>     FirstName,
>     LastName
> FROM Person.Person
> WHERE BusinessEntityID BETWEEN 1 AND 5
>   AND FirstName LIKE 'R%'
> ;
> ```
