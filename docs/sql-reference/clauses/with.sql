/*
    WITH (RECURSIVE)

    --------------------------------------------------------------------

    The WITH clause allows you to define and give names to sub-queries
    that can be referenced in the main query. This is particularly
    useful for sub-queries that are used more than once, but is also
    beneficial for readability.

    --------------------------------------------------------------------

    Docs:
    - https://duckdb.org/docs/sql/query_syntax/with
    - https://www.sqlite.org/syntax/common-table-expression.html
    - https://www.postgresql.org/docs/current/queries-with.html
    - https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql
    - https://docs.snowflake.com/en/sql-reference/constructs/with

    --------------------------------------------------------------------

    All 5 support this and the recursive variant, but including the
    RECURSIVE keyword depends on the dialect.

    - DuckDB requires the RECURSIVE keyword, and adds another optional
      keyword called MATERIALIZED which caches the results of the CTE
    - SQLite treats the RECURSIVE keyword as optional
    - PostgreSQL requires the RECURSIVE keyword
    - SQL Server doesn't allow the RECURSIVE keyword
    - Snowflake treats the RECURSIVE keyword as optional
*/


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* SQL Server */
use AdventureWorksDW2022;
set statistics time on;


/* Defining a common table expression (CTE) */
with internet_sales as (
    select
        cast(DueDate as date) as due_date,
        sum(SalesAmount) as total_sales_amount
    from FactInternetSales
    group by DueDate
)

select
    due_date,
    total_sales_amount,
    sum(total_sales_amount) over (order by due_date) as total_sales_amount_to_date
from internet_sales
order by due_date
;


/* Defining multiple common table expressions */
with

internet_sales as (
    select
        cast(DueDate as date) as due_date,
        sum(SalesAmount) as total_sales_amount
    from FactInternetSales
    group by DueDate
),
reseller_sales as (
    select
        cast(DueDate as date) as due_date,
        sum(SalesAmount) as total_sales_amount
    from FactResellerSales
    group by DueDate
)

select
    coalesce(internet_sales.due_date, reseller_sales.due_date) as due_date,
    coalesce(internet_sales.total_sales_amount, 0) as internet_sales_amount,
    coalesce(reseller_sales.total_sales_amount, 0) as reseller_sales_amount
from internet_sales
    full join reseller_sales
        on internet_sales.due_date = reseller_sales.due_date
order by due_date
;


/* Simple recursive CTE for generation (more examples in a separate section) */
with dates as (
        select cast(getdate() as date) as dt
    union all
        select dateadd(day, 1, dt)
        from dates
        where dt < dateadd(day, 31, getdate())
)

select *
from dates
;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* DuckDB */
-- USE loan.db;

/* Slightly more complicated recursive CTE for flattening (more examples in a separate section) */
with recursive customer_hierarchy as (
        select
            parent_customer_id as customer_id,
            child_customer_id as descendant_customer_id,
            0 as _depth,
        from customer_relationships
        where parent_customer_id not in (
            select child_customer_id
            from customer_relationships
        )
    union all
        select
            hierarchy.customer_id,
            relationships.child_customer_id,
            hierarchy._depth + 1,
        from customer_relationships as relationships
            inner join customer_hierarchy as hierarchy
                on relationships.parent_customer_id = hierarchy.descendant_customer_id
)

select
    customer_id,
    descendant_customer_id,
    min(_depth) as depth
from customer_hierarchy
group by customer_id, descendant_customer_id
order by customer_id, depth, descendant_customer_id
;
