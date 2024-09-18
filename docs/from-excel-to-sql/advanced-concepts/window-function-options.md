# Window function options 📉

> [!SUCCESS]
>
> We covered window functions in the [main concepts section](../main-concepts/window-functions.md), but we didn't cover all of their available options.
>
> This section will cover:
>
> - The WINDOW clause (whole thing for YouTube!)
> - Frame spec shorthands (briefly touched on YouTube!)
> - RANGE frame type
> - GROUPS frame type
> - Exclusion options

> [!WARNING]
>
> These options aren't in every SQL database, and there aren't Excel equivalents for them.
>
> In particular, SQL Server doesn't support all of these options, so the examples below will be in PostgreSQL.
>
> Make sure that you are comfortable with the main concepts before diving into these advanced concepts.

## Quick recap

We saw in the main concepts section that window functions are a way to perform calculations across a set of rows related to the current row. They are similar to aggregate functions, but they don't collapse the rows into a single row.

The main syntax we saw was:

```sql
SELECT
    <WINDOW_FUNCTION>(...) OVER (
        PARTITION BY ...
        ORDER BY ...
        ROWS BETWEEN ... AND ...
    )
FROM ...
```

We saw that `PARTITION BY` and `ORDER BY` could be used independently or together, and we also saw the `WINDOW` clause:

```sql
SELECT
    <WINDOW_FUNCTION>(...) OVER window_name
FROM ...
WINDOW window_name AS (
    PARTITION BY ...
    ORDER BY ...
    ROWS BETWEEN ... AND ...
)
```

## The `WINDOW` clause

Two things we didn't cover with the `WINDOW` clause are:

- Defining multiple window functions in a single query
- Window chaining

## Frame spec shorthands

## `RANGE` frame type

## `GROUPS` frame type

## Exclusion options

## Further reading

SQL Server doesn't actually support a few of these options, so check out the [official PostgreSQL documentation](https://www.postgresql.org/docs/current/tutorial-window.html) for more information on window function options at:

- [https://www.postgresql.org/docs/current/tutorial-window.html](https://www.postgresql.org/docs/current/tutorial-window.html)
- [https://www.postgresql.org/docs/current/sql-expressions.html#SYNTAX-WINDOW-FUNCTIONS](https://www.postgresql.org/docs/current/sql-expressions.html#SYNTAX-WINDOW-FUNCTIONS)
