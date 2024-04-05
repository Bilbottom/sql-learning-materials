# Operators ➕

> [!SUCCESS]
>
> Like we saw in the [Filtering](where.md) section, the SQL "operators" are very similar to the Excel operators.

## SQL has the same operators as Excel

We saw in the [Filtering](where.md) section that SQL has the comparison operators that we're familiar with from Excel:

- `<` (less than)
- `<=` (less than or equal to)
- `>` (greater than)
- `>=` (greater than or equal to)
- `=` (equals)
- `<>` (does not equal), also written as `!=`

Unsurprisingly, SQL also has the same arithmetic operators that we're familiar with from Excel:

- `+` (addition)
- `-` (subtraction)
- `*` (multiplication)
- `/` (division)

We'd use these exactly as you'd expect:

```sql
SELECT
    1 + 1 AS TWO,
    2 - 1 AS ONE,
    2 * 2 AS FOUR,
    6 / 2 AS THREE
;
```

| TWO | ONE | FOUR | THREE |
| --: | --: | ---: | ----: |
|   2 |   1 |    4 |     3 |

## Unlike Excel, be careful with division!

In Excel, if you divide a whole number by another whole number, Excel will give you what you expect -- for example, `5 / 2` will give you `2.5`.

In SQL, if you divide a whole number by another whole number, you'll get a whole number back. This means that `5 / 2` will give you `2`, not `2.5`!

```sql
SELECT 5 / 2 AS FIVE_DIVIDED_BY_TWO;
```

| FIVE_DIVIDED_BY_TWO |
| ------------------: |
|                   2 |

This is because of what we covered in the [Data types](data-types.md) section; SQL (at least, Microsoft SQL Server) is more pedantic with data types than Excel is.

The natural question is, "how do we get the correct number back?"

There are a few things that we could do that you'll see out in the wild:

- If you specify the numbers, add a decimal point to (at least) one of them
- If you're using columns, cast (at least) one column to a `DECIMAL` or `FLOAT` data type
- If you're using columns, multiply by `1.0` to convert the whole number to a decimal (this is a "cheat" way of doing the previous point)

The following are all how we'd implement the points above:

```sql
SELECT
    5.0 / 2 AS OPTION_1,
    CAST(5 AS DECIMAL) / 2 AS OPTION_2,
    1.0 * 5 / 2 AS OPTION_3
;
```

| OPTION_1 | OPTION_2 | OPTION_3 |
| -------: | -------: | -------: |
| 2.500000 | 2.500000 | 2.500000 |

> [!WARNING]
>
> It's important to do the data type conversion _before_ the division. For example, the following **would not** give you the correct answer:
>
> ```sql
> SELECT CAST(5 / 2 AS DECIMAL) AS INCORRECT;
> ```
>
> This is because the division will be done _before_ the conversion, so the damage will have already been done!

## Further reading

Check out the [official Microsoft documentation](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/operators-transact-sql) for more information on operators at:

- [https://learn.microsoft.com/en-us/sql/t-sql/language-elements/operators-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/operators-transact-sql)

The video version of this content is also available at:

- [https://youtu.be/bxZeIkcxYQA](https://youtu.be/bxZeIkcxYQA)
