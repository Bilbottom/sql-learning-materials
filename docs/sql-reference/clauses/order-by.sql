/*
    ORDER BY [ALL]

    ASC/DESC
    NULLS FIRST/LAST

    TOP/LIMIT

    OFFSET

    --------------------------------------------------------------------

    The ORDER BY clause is how we sort our output. It's usually useful
    in conjunction with TOP/LIMIT.

    --------------------------------------------------------------------

    Docs:
    - https://duckdb.org/docs/sql/query_syntax/orderby
    - https://www.sqlite.org/syntax/ordering-term.html
    - https://www.postgresql.org/docs/current/queries-order.html
    - https://learn.microsoft.com/en-us/sql/t-sql/queries/select-order-by-clause-transact-sql
    - https://docs.snowflake.com/en/sql-reference/constructs/order-by

    --------------------------------------------------------------------

    All 5 have ORDER BY along with ASC/DESC. All also have at least one
    of TOP or LIMIT.

    - DuckDB has everything and uses LIMIT instead of TOP
    - SQLite has everything and uses LIMIT instead of TOP
    - PostgreSQL has everything and uses LIMIT instead of TOP
    - SQL Server doesn't have NULLS FIRST/LAST but does have an FETCH as
      an extension of OFFSET. It uses TOP instead of LIMIT
*/


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* SQL Server */
use AdventureWorks2022;
set statistics time on;


/* Standard TOP and ORDER BY */
select top 10
    BusinessEntityID,
    FirstName,
    LastName
from Person.Person
order by BusinessEntityID
;


/* TOP PERCENT */
select top 1 percent *
from Sales.SalesOrderDetail
order by LineTotal desc
;


/* TOP WITH TIES */
select top 8 with ties *
from Sales.SalesOrderDetail
order by LineTotal desc
;


/* OFFSET with FETCH */
select
    BusinessEntityID,
    FirstName,
    LastName
from Person.Person
order by BusinessEntityID
offset 10 rows fetch next 5 rows only
;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* DuckDB */
-- use loan.db;


/* The "usual" limit/offset combination (4th, 5th, and 6th sized loans) */
select *
from loans
order by loan_value desc
limit 3
offset 3
;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* PostgreSQL */
-- use postgres;


/* ORDER BY ... USING <operator> */
select
    actor.first_name,
    actor.last_name
from actor
where actor.first_name ~~* 'a%'  /* Operator syntax for ILIKE */
order by actor.first_name using ~<~
;
