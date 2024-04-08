# More fundamentals 📚

> [!SUCCESS]
>
> The "fundamental" joins can be extended with a few more concepts that are common in most SQL databases.

## More "fundamental" stuff

There are two ways to adjust the "fundamental" joins, which impacts how you write the join conditions:

- Modifying the join type with `NATURAL`
- Writing `USING` instead of `ON`

In both cases, the goal is to simplify the join conditions and make the SQL easier to read.

## `NATURAL`

> [!WARNING]
>
> Although most databases support the `NATURAL` keyword, it's generally considered a bad idea to use it.

The `NATURAL` keyword is a join modifier; it can optionally be written before the inner and outer join types:

- `NATURAL INNER JOIN`
- `NATURAL LEFT JOIN`
- `NATURAL RIGHT JOIN`
- `NATURAL FULL JOIN`

The "feature" of the `NATURAL` join modifier is that you don't then need to specify the join condition. Instead, the database will automatically match columns with the same name in both tables.

This is why it's generally considered a bad idea to use `NATURAL` joins:

1. It's not always clear which columns are being matched
2. It can lead to unexpected results if the column names change, or if new columns are added to the tables

To illustrate an example anyway, consider the following simple (and silly) tables, `forenames` and `surnames`:

#### `forenames`

|  id | forename |
| --: | :------- |
|   1 | alice    |
|   2 | bob      |
|   3 | charlie  |

#### `surnames`

|  id | surname |
| --: | :------ |
|   1 | jones   |
|   2 | smith   |
|   4 | lee     |

We could write a natural inner join query like this:

```sql
select *
from forenames
    natural inner join surnames
```

|  id | forename | surname |
| --: | :------- | :------ |
|   1 | alice    | jones   |
|   2 | bob      | smith   |

This has automatically matched the `id` columns in both tables, and returned the rows where the `id` values are the same.

Similarly, we could write a natural full join query like this:

```sql
select *
from forenames
    natural full join surnames
```

|  id | forename | surname |
| --: | :------- | :------ |
|   1 | alice    | jones   |
|   2 | bob      | smith   |
|   3 | charlie  | _null_  |
|   4 | _null_   | lee     |

Notice that, since the `id` column was matched, the output only has one `id` column which has automatically taken the non-null values from both tables. This saves us from having to write `COALESCE` to handle the `NULL` values!

### Availability

At the time of writing (2024-04-07), the `NATURAL` join modifier has the following availability:

- DuckDB: ✅
- SQLite: ✅
- PostgreSQL: ✅
- SQL Server: ❌
- Snowflake: ✅

## `USING`

The `USING` keyword is another way to simplify the join condition, and is far more common than `NATURAL`.

Rather than specifying the join condition with `ON`, you can specify the column(s) to join on in the `USING` clause:

```sql
select *
from forenames
    inner join surnames
        using (id)
```

|  id | forename | surname |
| --: | :------- | :------ |
|   1 | alice    | jones   |
|   2 | bob      | smith   |

This is helpful when the column names are the same in both tables, and you want to avoid repeating the column names in the `ON` clause. You can include as many columns as you want in the `USING` clause, separated by commas.

Like with `NATURAL`, the columns specified in the `USING` clause will only be returned once in the output if you use a `SELECT *` with the non-null values from the tables!

Even better, if you want to specify columns explicitly in the output, by _not_ prefixing the columns that are in the `USING` clause with the table name, the database will automatically keep the non-null values from both tables:

```sql
select
    id,
    forenames.forename,
    surnames.surname
from forenames
    full join surnames
        using (id)
```

|  id | forename | surname |
| --: | :------- | :------ |
|   1 | alice    | jones   |
|   2 | bob      | smith   |
|   3 | charlie  | null    |
|   4 | null     | lee     |

### Availability

At the time of writing (2024-04-07), the `USING` keyword has the following availability:

- DuckDB: ✅
- SQLite: ✅
- PostgreSQL: ✅
- SQL Server: ❌
- Snowflake: ✅
