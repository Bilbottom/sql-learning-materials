# Conditionals 🔀

> [!SUCCESS]
>
> Just like Excel's `IF` function, SQL has a few ways to handle conditional logic.

## SQL's "if" function is `IIF`

> [!INFO]
>
> Why is it called `IIF`? It's short for "_Immediate If_" which is the typical name programming languages give a function that acts like the `IF` function in Excel. This is to distinguish the `IIF` _function_ from the alternative `IF` _statement_ already in the programming language, and SQL is no exception.
>
> This is just an FYI. If it doesn't make sense, don't worry about it! 😝

[The `IIF` function](https://learn.microsoft.com/en-us/sql/t-sql/functions/logical-functions-iif-transact-sql) is exactly what you'd expect: it's the same as the Excel `IF` function!

```sql
SELECT IIF(AGE < 18, 'Child', 'Adult') AS AGE_GROUP
```

This function is great for simple conditions, but anyone who's used Excel for a while knows that anything slightly more complex can get a bit unwieldy.

To handle more complex conditions, SQL has a `CASE` statement.

## `CASE` statements are great for complex conditions

> [!NOTE]
>
> The `CASE` statement is a staple of SQL and is used in many different SQL dialects. It's worth getting to know it well!

[A `CASE` statement](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/case-transact-sql) is really a series of `IF` statements (logically).

Converting the `IIF` example from above to a `CASE` statement looks like this:

```sql
SELECT
    CASE
        WHEN AGE < 18
            THEN 'Child'
            ELSE 'Adult'
    END AS AGE_GROUP
```

When a `CASE` statement is used, the `WHEN` part is checked for each value. For each value, if a condition is met the `THEN` part is used, otherwise the next condition is checked.

To show this off, the example above can be extended to include more conditions:

```sql
SELECT
    CASE
        WHEN AGE < 13
            THEN 'Child'
        WHEN AGE < 18
            THEN 'Teenager'
            ELSE 'Adult'
    END AS AGE_GROUP
```

> [!INFO]
>
> The corresponding Excel formula for this `CASE` statement would be (assuming the age is in cell `A1`):
>
> ```
> =IF(A1 < 13, "Child", IF(A1 < 18, "Teenager", "Adult"))
> ```

Let's walk through this example to see how it works. Suppose that the underlying data has the following rows:

|  ID |    AGE |
| --: | -----: |
|   1 |     10 |
|   2 |     15 |
|   3 |     23 |
|   4 |     18 |
|   5 | _null_ |

1. The first row has an age of 10, so the first condition, `AGE < 13`, is met and therefore the result is `Child`.
2. The second row has an age of 15, so the first condition _is not_ met. This means that the second condition, `AGE < 18`, is checked. The second condition is met so the result is `Teenager`.
3. The third row has an age of 23, so neither the first condition nor the second condition are met. There are no more conditions so the `ELSE` part is used and the result is `Adult`.
4. The fourth row has an age of 18, so the first condition is not met. The second condition _is also not met_ because 18 is not less than 18, so the result for this row is also `Adult`.
5. The fifth row is missing an age, so SQL can't say whether the conditions (`AGE < 13` and `AGE < 18`) are met. Therefore, it assumes that they're not met and also uses the else part of the `CASE` statement, also resulting in `Adult`.

|  ID |    AGE | AGE_GROUP |
| --: | -----: | :-------- |
|   1 |     10 | Child     |
|   2 |     15 | Teenager  |
|   3 |     23 | Adult     |
|   4 |     18 | Adult     |
|   5 | _null_ | Adult     |

> [!WARNING]
>
> The last example (with the missing age) might be a bit confusing, so it's important to practice using data with `NULL` values to get used to handling them.

> [!TIP]
>
> When using case statements, it is usually a good idea to have a condition that checks for `NULL` values right at the start. Adding this to the example above might look something like:
>
> ```sql
> SELECT
>     CASE
>         WHEN AGE IS NULL
>             THEN 'Unknown'
>         WHEN AGE < 13
>             THEN 'Child'
>         WHEN AGE < 18
>             THEN 'Teenager'
>             ELSE 'Adult'
>     END AS AGE_GROUP
> ```
>
> The corresponding Excel formula for this `CASE` statement would be (assuming the age is in cell `A1`) something like:
>
> ```
> =IF(A1 = "", "Unknown", IF(A1 < 13, "Child", IF(A1 < 18, "Teenager", "Adult")))
> ```

## Keep redundant logic out of your `CASE` statements

Notice how the order of the conditions in the `CASE` statement is important. Since the `AGE < 18` condition comes after the `AGE < 13` condition, the `AGE < 18` condition _already knows that the age is at least 13_ if a value comes to it! If it wasn't, it would have been caught by the `AGE < 13` condition.

Out in the wild, you might find people who still add these redundant conditions to their `CASE` statements. It's not _wrong_ to do this, but it's not necessary and it can make the code harder to read.

For example, the following `CASE` statement is equivalent to the one above, but it includes the redundant conditions which make it harder to read:

```sql
SELECT
    CASE
        WHEN AGE IS NULL
            THEN 'Unknown'
        WHEN AGE IS NOT NULL AND AGE < 13  /* `AGE IS NOT NULL` is redundant! */
            THEN 'Child'
        WHEN AGE IS NOT NULL AND AGE >= 13 AND AGE < 18  /* `AGE IS NOT NULL AND AGE >= 13` is redundant! */
            THEN 'Teenager'
            ELSE 'Adult'
    END AS AGE_GROUP
```

## Alternative `CASE` syntax

There are times when you might want to use the `CASE` statement to convert one set of values into another set of values, for example:

```sql
SELECT
    CASE
        WHEN CODE = 'A'
            THEN 'Alpha'
        WHEN CODE = 'B'
            THEN 'Bravo'
        WHEN CODE = 'C'
            THEN 'Charlie'
            ELSE 'Unknown'
    END AS PHONETIC
```

In this specific case where the conditions are all checking for specific values (using an equals) in a single column, the column can be specified once at the start of the `CASE` statement and just the values can be written in the `WHEN` part:

```sql
SELECT
    CASE CODE
        WHEN 'A'
            THEN 'Alpha'
        WHEN 'B'
            THEN 'Bravo'
        WHEN 'C'
            THEN 'Charlie'
            ELSE 'Unknown'
    END AS PHONETIC
```

| CODE   | PHONETIC |
| :----- | :------- |
| A      | Alpha    |
| B      | Bravo    |
| C      | Charlie  |
| D      | Unknown  |
| _null_ | Unknown  |

> [!TIP]
>
> Mapping values like this is convenient with the `CASE` statement, but in most cases it's better to have a lookup table that you can join on (we'll cover joins later).
>
> However, you might not always have a lookup table available, so the `CASE` statement is a good alternative in those cases.

## The SQL for running these examples

> [!ERROR]
>
> The data for these examples isn't in the AdventureWorks database that we're using, so it has been created for this section. If you want to run these examples yourself, you can use the SQL below but note that this is using some features that we haven't covered yet!

For the examples above, the rows are created on the fly. You're not expected to understand this yet, but it's provided so that you can run the SQL yourself if you want to.

```sql
/* Age Example */
SELECT
    ID,
    AGE,
    CASE
        WHEN AGE IS NULL
            THEN 'Unknown'
        WHEN AGE < 13
            THEN 'Child'
        WHEN AGE < 18
            THEN 'Teenager'
            ELSE 'Adult'
    END AS AGE_GROUP
FROM (
    VALUES
        (1, 10),
        (2, 15),
        (3, 23),
        (4, 18),
        (5, NULL)
) AS AGES(ID, AGE)
;

/* Phonetic Example */
SELECT
    CODE,
    CASE CODE
        WHEN 'A'
            THEN 'Alpha'
        WHEN 'B'
            THEN 'Bravo'
        WHEN 'C'
            THEN 'Charlie'
            ELSE 'Unknown'
    END AS PHONETIC
FROM (
    VALUES
        ('A'),
        ('B'),
        ('C'),
        ('D'),
        (NULL)
) AS CODES(CODE)
```

## Further reading

Check out the [official Microsoft documentation](https://learn.microsoft.com/en-us/sql/t-sql/language-reference) for more information on `IIF` and `CASE` at:

- [https://learn.microsoft.com/en-us/sql/t-sql/functions/logical-functions-iif-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/functions/logical-functions-iif-transact-sql)
- [https://learn.microsoft.com/en-us/sql/t-sql/language-elements/case-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/case-transact-sql)

The video version of this content is also available at:

- [https://youtu.be/4admV4I3fMU](https://youtu.be/4admV4I3fMU)
