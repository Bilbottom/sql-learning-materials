# Logical processing order 🎥

> [!WARNING]
>
> Confusingly, the order in which things are done in a `SELECT` statement is not exactly the same as the order in which they are written.
>
> This is because SQL code was designed to be written in a way that is easy to read and write, rather than to reflect what happens under the hood.

## The written order of a `SELECT` statement

This has been mentioned in each of the clauses' respective pages, but the lexical (written) order of a `SELECT` statement is as follows:

1. `SELECT`
2. `DISTINCT`
3. `TOP`
4. `FROM`
5. `JOIN`
6. `ON`
7. `WHERE`
8. `GROUP BY`
9. `WITH CUBE` or `WITH ROLLUP`
10. `HAVING`
11. `WINDOW`
12. `ORDER BY`

## The logical processing order of a `SELECT` statement

The logical processing order of a `SELECT` statement _is not_ the same as the written order.

A big part of understanding SQL is understanding the order in which things are done in a `SELECT` statement.

> Do joins happen before or after the `WHERE` clause? Are rows deduplicated before being aggregated? Are rows ordered before being "topped" (with `TOP`)?

This is important to understand because it can affect the result of your query.

As per [the Microsoft SQL Server documentation](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-transact-sql#logical-processing-order-of-the-select-statement), the logical processing order of a `SELECT` statement is as follows:

1. `FROM`
2. `ON`
3. `JOIN`
4. `WHERE`
5. `GROUP BY`
6. `WITH CUBE` or `WITH ROLLUP`
7. `HAVING`
8. `SELECT` (and `OVER`/`WINDOW`)
9. `DISTINCT`
10. `ORDER BY`
11. `TOP`

SQL has this disparity between the written code and the order in which it is processed because SQL is [a "_declarative_" language](https://en.wikipedia.org/wiki/Declarative_programming). You don't need to know what this means, but it's just a fancy way of saying that you tell SQL _what_ you want, not _how_ to get it.

## Further reading

Check out the [official Microsoft documentation](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-transact-sql#logical-processing-order-of-the-select-statement) for more information on the logical processing order of the select statement at:

- [https://learn.microsoft.com/en-us/sql/t-sql/queries/select-transact-sql#logical-processing-order-of-the-select-statement](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-transact-sql#logical-processing-order-of-the-select-statement)
