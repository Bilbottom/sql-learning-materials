/*
    WINDOW

    --------------------------------------------------------------------

    The WINDOW clause allows us to define a window of rows so that we
    can reference it elsewhere in the query, rather than having to
    repeat the window definition in each place it's used.

    --------------------------------------------------------------------

    Docs:
    - https://duckdb.org/docs/sql/query_syntax/window
    - https://www.sqlite.org/syntax/window-defn.html
    - https://www.postgresql.org/docs/current/tutorial-window.html
    - https://learn.microsoft.com/en-us/sql/t-sql/queries/select-window-transact-sql

    --------------------------------------------------------------------

    This is not currently supported by Snowflake.

    In SQL Server, the WINDOW clause requires database compatibility
    level 160 or higher.
*/


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* SQL Server */
use AdventureWorksDW2022;
set statistics time on;


/* Defining and referencing an explicit window */
select
    DueDateKey,
    sum(SalesAmount) as total_sales_amount,
    sum(sum(SalesAmount)) over historic_dates as total_sales_amount_to_date
from FactInternetSales
group by DueDateKey
window historic_dates as (
    order by DueDateKey rows unbounded preceding
)
order by dueDateKey
;


/* ...and a CTE version since it might be easier to read */
with agg as (
    select
        DueDateKey,
        sum(SalesAmount) as total_sales_amount
    from FactInternetSales
    group by DueDateKey
)

select
    DueDateKey,
    total_sales_amount,
    sum(total_sales_amount) over historic_dates as total_sales_amount_to_date
from agg
window historic_dates as (
    order by DueDateKey rows unbounded preceding
)
order by dueDateKey
;
