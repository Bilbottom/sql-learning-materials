/*
    WHERE

    --------------------------------------------------------------------

    The WHERE clause is the main way that we filter data in SQL.

    --------------------------------------------------------------------

    Docs:
    - https://duckdb.org/docs/sql/query_syntax/where
    - https://www.sqlite.org/syntax/select-stmt.html
    - https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-WHERE
    - https://learn.microsoft.com/en-us/sql/t-sql/queries/where-transact-sql
    - https://docs.snowflake.com/en/sql-reference/constructs/where

    --------------------------------------------------------------------

    All 5 support this.

    This is really only interesting when there are interesting operators
    and functions available in the dialect.
*/


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* SQL Server */
use AdventureWorks2022;
set statistics time on;


/* A standard example... */
select *
from Person.Person
where PersonType = 'EM'
;

/* ...and a slightly more involved example */
select *
from Person.Person
where 1=1
    and Title is null
    and PersonType is not null
    and BusinessEntityID > 100
    and len(MiddleName) = 1
    and (0=1
        or NameStyle = 0
        or EmailPromotion != 0
        or FirstName like 'A%'
    )
;
