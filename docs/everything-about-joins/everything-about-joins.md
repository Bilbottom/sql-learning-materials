# Everything about joins

## About this course

> [!SUCCESS]
>
> Everything you need to know about SQL joins 🎉

## The tools/data in this course

This course will primarily use [DuckDB](https://duckdb.org/) as the database engine, but will also mention [SQLite](https://www.sqlite.org/), [PostgreSQL](https://www.postgresql.org/), [SQL Server](https://learn.microsoft.com/en-us/sql/sql-server/?view=sql-server-ver16), and [Snowflake](https://docs.snowflake.com/).

The data will be made up for the examples.

## Outline

1. **Syntax**
   1. SQL-92 rant (ANSI-SQL join syntax)
   2. Join fundamentals: `INNER`, `LEFT` (`RIGHT`), `FULL`, `CROSS`
   3. More fundamentals: `USING`, `NATURAL`
   4. [The "timestamp" join: `ASOF`](syntax/timestamp-joins.md)
   5. [The "filtering" joins: `SEMI`, `ANTI`](syntax/filtering-joins.md)
   6. [The "glue" join: `POSITIONAL`](syntax/glue-joins.md)
2. **Under the hood**
   1. ...
