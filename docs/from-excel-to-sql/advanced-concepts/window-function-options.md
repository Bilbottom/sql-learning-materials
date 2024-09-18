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

## Frame spec shorthands

## The `WINDOW` clause

Two things we didn't cover with the `WINDOW` clause are:

- Defining multiple named windows in a single query
- Window chaining

### Multiple named windows

The syntax for multiple named windows is very similar to the syntax for CTEs -- just separate the window definitions with commas. For example:

```sql
select
    sale_month,
    sale_value,
    sum(sale_value) over last_three_months as sum_last_three_months,
    avg(sale_value) over last_three_months as avg_last_three_months,
    sum(sale_value) over running_sale_year as yearly_running_total
from sales
window
    last_three_months as (order by sale_month rows 2 preceding),
    running_sale_year as (partition by extract(year from sale_month) order by sale_month)
```

This query defines two named windows: `last_three_months` and `running_sale_year`. We could add more named windows simply by adding more definitions to the `WINDOW` clause.

### Window chaining

For databases that support the `WINDOW` clause, they typically allow you to also chain windows together. This means that you can define a window that is based on another window. For example:

```sql

```

## `RANGE` frame type

## `GROUPS` frame type

## Exclusion options

## Further reading

SQL Server doesn't actually support a few of these options, so check out the [official PostgreSQL documentation](https://www.postgresql.org/docs/current/tutorial-window.html) for more information on window function options at:

- [https://www.postgresql.org/docs/current/tutorial-window.html](https://www.postgresql.org/docs/current/tutorial-window.html)
- [https://www.postgresql.org/docs/current/sql-expressions.html#SYNTAX-WINDOW-FUNCTIONS](https://www.postgresql.org/docs/current/sql-expressions.html#SYNTAX-WINDOW-FUNCTIONS)
