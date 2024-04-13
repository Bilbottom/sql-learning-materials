# The "glue" join (`POSITIONAL`) 📎

> [!SUCCESS]
>
> The `POSITIONAL` join just "glues" the rows from the left and right tables together, without any matching condition!

## Syntax

The `POSITIONAL` join is most similar to the `CROSS` join as it doesn't require a matching condition. The difference is that the `CROSS` join will join every row from the left table with every row from the right table, whereas the `POSITIONAL` join will join the rows based on their position in the tables.

```sql
SELECT *
FROM left_table
    POSITIONAL JOIN right_table
```

At the time of writing (2024-04-07), DuckDB is one of the few databases to have introduced the `POSITIONAL` join type. This is because it's very uncommon to join tables based on their positions in relational tables, mostly because the order of rows in a table is not guaranteed!

However, DuckDB supports this join type because DuckDB often uses imported tables such as data frames or CSV files where the order of rows _is_ guaranteed.

In particular, the `POSITIONAL` join is the SQL equivalent of Pandas' `DataFrame.join` method:

- [https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.join.html](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.join.html)

### Availability

At the time of writing (2024-04-07), the `POSITIONAL` join has the following availability:

- DuckDB: ✅ ([>=0.6](https://duckdb.org/docs/archive/0.6/sql/query_syntax/from))
- SQLite: ❌
- PostgreSQL: ❌
- SQL Server: ❌
- Snowflake: ❌

Are you aware of any other databases that support the `POSITIONAL` join?

## Examples

The `POSITIONAL` join has very specific use cases that we won't cover here, so we'll just show a simple example to illustrate the syntax:

```sql
with

words(word) as (values ('hello'), ('world')),
numbers(number) as (values (1), (2), (3))

select *
from words
    positional join numbers
```

| word   | number |
| :----- | -----: |
| hello  |      1 |
| world  |      2 |
| _null_ |      3 |

Note that the third row has a `NULL` value for the `word` column because there was no third row in the `words` table to join with the third row in the `numbers` table.
