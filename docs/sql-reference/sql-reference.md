# SQL Reference

We'll talk about SQL features in the following dialects:

- [DuckDB](https://duckdb.org/)
- [SQLite](https://www.sqlite.org/index.html)
- [PostgreSQL](https://www.postgresql.org/)
- [SQL Server](https://learn.microsoft.com/en-us/sql/t-sql/language-reference)
- [Snowflake](https://docs.snowflake.com/)

## Clauses

The SQL clauses are the building blocks of SQL statements. They are the keywords that make up the SQL language:

- [`SELECT`/`FROM`](clauses/select.sql)
- [`WHERE`](clauses/where.sql)
- [`JOIN`](clauses/join.sql)
- [`GROUP BY`/`HAVING`](clauses/group-by.sql)
- [`QUALIFY`](clauses/qualify.sql)
- [`ORDER BY`](clauses/order-by.sql)
- [`WINDOW`](clauses/window.sql)
- [`PIVOT`](clauses/pivot.sql)
- [`UNION`](clauses/union.sql)
- [`VALUES`](clauses/values.sql)
- [`WITH`](clauses/with.sql)

## Functions

- [`TRY_CAST`](functions/try-cast.sql)
- [`SOUNDEX`](functions/soundex.sql)

## Internals

- [ANSI SQL](internals/ansi.sql)
- [Syntax Trees](internals/syntax-trees.sql) 🟠
- [Query Plans](internals/query-plans.sql) 🟠
- [Transactions](internals/transactions.sql) 🟠
- [Collation](internals/collation.sql)
- [Indexes](internals/indexes.sql) 🟠

## Features

- [Sub-queries and CTEs](features/subqueries-and-ctes.sql) 🟠
- [Window functions](features/window-functions.sql)
- [Correlated sub-queries](features/correlated-subqueries.sql)
- [Recursive CTEs](features/recursive-ctes.sql)
- [Graphs](features/graphs.sql) 🟠

---

## SQL Server

Stuff specific to **Microsoft's SQL Server**'s (MSSQL) **Transact-SQL** (T-SQL) dialect. Note that Microsoft also has some other database engines that use T-SQL such as **Azure SQL Database** and **Azure Synapse Analytics**.

- [json](sql-server/json.sql)
- [cross-apply](sql-server/cross-apply.sql)
- [computed-columns](sql-server/computed-columns.sql)
- [temporal-tables](sql-server/temporal-tables.sql)
