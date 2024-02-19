/*
    SELECT
    FROM

    AS
    ALL/DISTINCT

    DISTINCT ON (...)

    Extensions:
    - ILIKE (Snowflake)
    - COLUMNS() (DuckDB)
    - EXCLUDE
    - REPLACE
    - RENAME (Snowflake)

    --------------------------------------------------------------------

    The SELECT clause is the starting point of most queries.

    --------------------------------------------------------------------

    Docs:
    - https://duckdb.org/docs/sql/query_syntax/select
    - https://www.sqlite.org/syntax/select-stmt.html
    - https://www.postgresql.org/docs/current/queries-select-lists.html
    - https://learn.microsoft.com/en-us/sql/t-sql/queries/select-clause-transact-sql
    - https://docs.snowflake.com/en/sql-reference/sql/select

    --------------------------------------------------------------------

    All 5 have the core SELECT/FROM, AS, and DISTINCT.

    - DuckDB has COLUMNS(), EXCLUDE/REPLACE, and DISTINCT ON
    - SQLite doesn't have these, but its GROUP BY does have a flexible
      implementation that can emulate DISTINCT ON:
        https://www.sqlite.org/quirks.html#aggregate_queries_can_contain_non_aggregate_result_columns_that_are_not_in_the_group_by_clause
    - PostgreSQL has DISTINCT ON
    - SQL Server has nothing extra
    - Snowflake has ILIKE and EXCLUDE/REPLACE/RENAME
*/


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* SQL Server */
use AdventureWorks2022;
set statistics time on;


/* SELECT doesn't need a FROM */
select current_timestamp
;


/* "Left-align" style (preferred) */
select
    BusinessEntityID,
    FirstName,
    MiddleName,
    LastName
from Person.Person
where BusinessEntityID < 10
  and FirstName = 'Ken'
order by LastName desc
;


/* "Rivers" style */
select BusinessEntityID,
       FirstName,
       MiddleName,
       LastName
  from Person.Person
 where BusinessEntityID < 10
   and FirstName = 'Ken'
 order by LastName desc
;


/* Alias (rename) things with AS */
select
    BusinessEntityID as entity_id,
    FirstName as forename,
    MiddleName as middle_name,
    LastName as surname
from Person.Person
where BusinessEntityID < 10
  and FirstName = 'Ken'
order by LastName desc
;


/* SELECT ALL is the same as SELECT */
select all
    BusinessEntityID as entity_id,
    FirstName as forename,
    MiddleName as middle_name,
    LastName as surname
from Person.Person
where BusinessEntityID < 10
  and FirstName = 'Ken'
order by LastName desc
;


/* Get just the distinct values of something */
select distinct PersonType
from Person.Person
;


/* Get the distinct combinations of things (in order) */
select distinct
    PersonType,
    Title
from Person.Person
order by
    PersonType,
    Title
;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* DuckDB */
-- USE loan.db;


/* In DuckDB, FROM doesn't need a SELECT! */
FROM loans
;


/* Dynamically select columns using COLUMNS() */
select columns('.*_customer_id')
from customer_relationships
;


/* Select distinct values on a given column */
select distinct on (customer_id)
    customer_id,
    loan_id
from loans
order by loan_value desc
;


/* Select while excluding and replacing (feat. string slicing) */
select *
    exclude loan_value
    replace (
        loan_id[4:]::integer as loan_id,
        customer_id[4:]::integer as customer_id,
    )
from loans
;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* Snowflake */
-- USE loan.db;


/* Dynamically select columns using ILIKE */
select * ilike '%_customer_id'
from customer_relationships
;


/* Select everything but rename something */
select * rename (loan_id as id)
from loans
;
