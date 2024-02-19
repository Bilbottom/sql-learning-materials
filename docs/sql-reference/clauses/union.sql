/*
    UNION (DISTINCT/ALL)
    EXCEPT
    INTERSECT

    --------------------------------------------------------------------

    The UNION clause is how we "glue" two SELECT statements together by
    stacking one on top of the other (in contrast to JOIN, which glues
    two tables together by adding columns from one table to another).

    The EXCEPT and INTERSECT clauses are similar to UNION, but they
    either remove or keep only the rows that are in common between the
    two SELECT statements.

    Note that ORDER BY and LIMIT/FETCH apply to the *entire* result set,
    not just the individual SELECT statement they are attached to.

    --------------------------------------------------------------------

    Docs:
    - https://duckdb.org/docs/sql/query_syntax/setops
    - https://www.sqlite.org/syntax/compound-operator.html
    - https://www.postgresql.org/docs/current/queries-union.html
    - https://learn.microsoft.com/en-us/sql/t-sql/language-elements/set-operators-union-transact-sql
    - https://docs.snowflake.com/en/sql-reference/operators-query

    --------------------------------------------------------------------

    All 5 have all of these.
*/


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* SQL Server */
use AdventureWorks2022;
set statistics time on;


/* UNION to stack results on top of each other */
    select
        BusinessEntityID,
        [Name.First] as FirstName,
        [Name.Last] as LastName
    from HumanResources.vJobCandidate
union
    select
        BusinessEntityID,
        FirstName,
        LastName
    from HumanResources.vEmployee
order by BusinessEntityID
;

/* INTERSECT to get the rows in common */
    select
        BusinessEntityID,
        [Name.First] as FirstName,
        [Name.Last] as LastName
    from HumanResources.vJobCandidate
intersect
    select
        BusinessEntityID,
        FirstName,
        LastName
    from HumanResources.vEmployee
order by BusinessEntityID
;

/* EXCEPT to remove rows */
    select
        BusinessEntityID,
        [Name.First] as FirstName,
        [Name.Last] as LastName
    from HumanResources.vJobCandidate
except
    select
        BusinessEntityID,
        FirstName,
        LastName
    from HumanResources.vEmployee
order by BusinessEntityID
;


/* You can also UNION without FROM to generate data */
    select 0 as id
union
    select 1
union
    select 2
union
    select 3
;


/* UNION will de-duplicate the output... */
    select 0 as id
union
    select 0
union
    select 1
union
    select 1
;


/* ...whereas UNION ALL keeps everything */
    select 0 as id
union all
    select 0
union all
    select 1
union all
    select 1
;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* DuckDB */
-- USE loan.db;


/* UNION DISTINCT is the same as UNION (for DuckDB, PostgreSQL, and Snowflake) */
    select 0 as id
union distinct
    select 0
union distinct
    select 1
union distinct
    select 1
;
