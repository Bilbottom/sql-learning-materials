# Join fundamentals 🧩

> [!SUCCESS]
>
> The bits that everyone knows 😋

## The "fundamental" joins

If you're reading this, you probably know what these are. The fundamental SQL joins are:

- `CROSS JOIN`
- `INNER JOIN`
- `LEFT JOIN`
- `RIGHT JOIN`
- `FULL JOIN`

All SQL databases support the first four, and most support the `FULL JOIN` as well.

### `CROSS JOIN`

It's not common to see `CROSS JOIN`, but it can be useful in some scenarios.

The `CROSS JOIN` has the simplest syntax:

```sql
SELECT *
FROM left_table
    CROSS JOIN right_table
```

There are no join conditions for a `CROSS JOIN` as it just joins every row from the left table with every row from the right table.

These joins are equivalent to the following non-ANSI SQL syntax (more on this in the [SQL-92 rant](sql-92-rant.md)):

```sql
SELECT *
FROM left_table, right_table
```

### `INNER JOIN`

The `INNER JOIN` is one of the most common join types.

Unlike the `CROSS JOIN`, the `INNER JOIN` requires a join condition to match rows from the left table with rows from the right table:

```sql
SELECT *
FROM left_table
    INNER JOIN right_table
        ON left_table.id_column = right_table.id_column
```

The "feature" of the `INNER JOIN` is that it only returns rows where there is a match between the left and right tables.

Note that the `INNER` keyword is optional in most databases. If you don't specify it, the database will assume you mean an `INNER JOIN`:

```sql
SELECT *
FROM left_table
    JOIN right_table  /* Still an inner join */
        ON left_table.id_column = right_table.id_column
```

### `LEFT JOIN` (and `RIGHT JOIN`)

The `LEFT JOIN` is the other most common join type.

Like the `INNER JOIN`, the `LEFT JOIN` also requires a join condition:

```sql
SELECT *
FROM left_table
    LEFT JOIN right_table
        ON left_table.id_column = right_table.id_column
```

The "feature" of the `LEFT JOIN` is that it keeps all rows from the left table, even if there is no match in the right table.

Although it's extremely uncommon, the `RIGHT JOIN` is the same as the `LEFT JOIN` except it keeps all rows from the right table:

```sql
SELECT *
FROM left_table
    RIGHT JOIN right_table
        ON left_table.id_column = right_table.id_column
```

These two joins can optionally specify the `OUTER` keyword, but it's not necessary:

```sql
SELECT *
FROM left_table
    [LEFT | RIGHT] OUTER JOIN right_table
        ON left_table.id_column = right_table.id_column
```

#### Left or right?

Any `RIGHT JOIN` can be rewritten as a `LEFT JOIN` by swapping the tables around which is why `RIGHT JOIN` is very uncommon.

In older versions of some databases, the join order had performance implications which meant that using `RIGHT JOIN` could offer performance benefits, but this is rarely the case now.

If in doubt, use `LEFT JOIN`!

### `FULL JOIN`

The `FULL JOIN` isn't supported by all databases, but it's a combination of the `LEFT JOIN` and `RIGHT JOIN`.

Like `INNER JOIN` and `LEFT JOIN`, the `FULL JOIN` requires a join condition:

```sql
SELECT *
FROM left_table
    FULL JOIN right_table
        ON left_table.id_column = right_table.id_column
```

The "feature" of the `FULL JOIN` is that it keeps all rows from _both_ tables, even if there is no match in the other table.

#### Availability

At the time of writing (2024-04-07), the `FULL JOIN` has the following availability:

- DuckDB: ✅
- SQLite: ✅ ([>=3.39.0](https://www.sqlite.org/releaselog/3_39_0.html))
- PostgreSQL: ✅
- SQL Server: ✅
- Snowflake: ✅

## Join syntax

### Multiple joins

This is another thing you probably know, but you can join more than two tables in a single query:

```sql
SELECT *
FROM table_1
    INNER JOIN table_2
        ON table_1.id_column = table_2.id_column
    LEFT JOIN table_3
        ON table_2.id_column = table_3.id_column
```

You don't have to use the same join type for all the joins, and you can mix and match as you like.

You choose the order of the joins which sometimes has an impact on performance, and you _have_ to put one join after another if the second join depends on the first join.

### Joins with subqueries

You can also join tables with subqueries:

```sql
SELECT *
FROM table_1
    INNER JOIN (
        SELECT *
        FROM table_2
        WHERE column_2 > 100
    ) AS subquery
        ON table_1.id_column = subquery.id_column
```

Unless the subquery is very basic (or you're a software developer using SQL in a transactional environment), it's typically a good idea to use a CTE instead of a subquery:

```sql
WITH subquery AS (
    SELECT *
    FROM table_2
    WHERE column_2 > 100
)

SELECT *
FROM table_1
    INNER JOIN subquery
        ON table_1.id_column = subquery.id_column
```

### Joins to the same table(s)

There's no limit to the number of times you can join a table in a query. You just need to alias the table each time you join it so that you can refer to each instance explicitly:

```sql
SELECT *
FROM base_table AS base1
    INNER JOIN base_table AS base2
        ON base1.id_column = base2.id_column
    LEFT JOIN other_table AS other1
        ON base1.id_column = other1.id_column_1
    LEFT JOIN other_table AS other2
        ON base2.id_column = other2.id_column_2
```

## Join condition syntax

Although the examples above only use a single join condition, you can have multiple join conditions in a join:

```sql
SELECT *
FROM left_table
    LEFT JOIN right_table
        ON  left_table.column_1 = right_table.column_1
        AND left_table.column_2 = right_table.column_2
        AND left_table.column_3 = right_table.column_3
```

The conditions don't have to be equality conditions either. You can use any condition you like:

```sql
SELECT *
FROM left_table
    LEFT JOIN right_table
        ON 0=1
        OR (1=1
            AND left_table.column_1 = right_table.column_1
            AND left_table.column_2 < right_table.column_2
        )
        OR left_table.column_3 BETWEEN right_table.column_3
                                   AND right_table.column_4
```

Note that these are all conditions for the _join_: they're not filters on the result set.

These conditions just determine which rows from the left table are matched with which rows from the right table. This is why equality is _usually_ how you join tables, but it's not a requirement.

Anything that is valid inside a `WHERE` clause is valid inside a join's `ON` condition!
