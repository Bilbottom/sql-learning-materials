/*
    Window Functions (also see WINDOW)

    OVER

    PARTITION BY
    ORDER BY

    ROWS/GROUPS/RANGE BETWEEN UNBOUNDED/<expr> PRECEDING/FOLLOWING/CURRENT ROW
    EXCLUDE CURRENT ROW/GROUP/TIES/NO OTHERS

    --------------------------------------------------------------------

    Window functions are like aggregate functions, but they don't
    collapse the rows into a single row. Additionally, they can
    reference other rows in the result set such as "looking up a row".

    --------------------------------------------------------------------

    Docs:
    - https://duckdb.org/docs/sql/window_functions.html
    - https://www.sqlite.org/windowfunctions.html
    - https://www.postgresql.org/docs/current/tutorial-window.html
    - https://learn.microsoft.com/en-us/sql/t-sql/queries/select-over-clause-transact-sql
    - https://docs.snowflake.com/en/sql-reference/functions-analytic

    --------------------------------------------------------------------

    All 5 support OVER with PARTITION BY, ORDER BY, and ROWS/RANGE
    BETWEEN. Only SQLite and PostgreSQL support GROUPS BETWEEN and all
    EXCLUDE options.
*/


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* SQL Server */
use AdventureWorksDW2022;
set statistics time on;


drop table if exists #monthly_internet_sales;
create table #monthly_internet_sales(
    order_month date primary key,
    amount money,
    order_year as datepart(year, order_month),
    order_month_number as datepart(month, order_month)
);
insert into #monthly_internet_sales(order_month, amount)
    select
        dateadd(month, datediff(month, 0, OrderDate), 0),
        sum(SalesAmount)
    from FactInternetSales
    group by dateadd(month, datediff(month, 0, OrderDate), 0)
;
select *
from #monthly_internet_sales
;


/* Accumulating monthly sales */
select
    order_month,
    amount,

    format(-1 + 1.0 * amount / lag(amount) over(order by order_month), 'P') as percentage_change,

    sum(amount) over (order by order_month) as sales_to_date,
    sum(amount) over (partition by order_year order by order_month) as yearly_sales_to_date,
    (1.0
        * sum(amount) over (partition by order_year order by order_month)
        / sum(amount) over (partition by order_year)
    ) as prop_of_yearly_sales_to_date,

    avg(amount) over (order by order_month rows 2 preceding) as sales_3mma, /* 3-month moving average */
    avg(amount) over (order by order_month rows 5 preceding) as sales_6mma, /* 6-month moving average */
    avg(amount) over (order by order_month rows 11 preceding) as sales_12mma /* 12-month moving average */
from #monthly_internet_sales
;


/*
Note that, in SQL Server, the default window frame is:

    - `RANGE UNBOUNDED PRECEDING AND CURRENT ROW`

This can make things like `LAST_VALUE` give an odd output until you
specify the window frame explicitly (which you should do, anyway).
*/
/* Demonstrate the default ORDER BY behaviour */
select
    order_month,
    amount,

    sum(amount) over (order by order_month) as running_total,
    last_value(order_month) over (order by order_month) as last_opening_month_default,

    last_value(order_month) over (
        order by order_month rows between unbounded preceding and unbounded following
    ) as last_opening_month,

    first_value(order_month) over (
        order by order_month rows between 2 preceding and 2 following
    ) as first_opening_month_5_month_window,
    last_value(order_month) over (
        order by order_month rows between 2 preceding and 2 following
    ) as last_opening_month_5_month_window

from #monthly_internet_sales
order by order_month
;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* SQLite */
-- use loan.db;


/* One alternative way of doing "lag" */
select
    customer_id,
    last_value(customer_id) over (
        order by customer_id rows unbounded preceding exclude current row
    ) as lag_customer_id
from customers
order by customer_id
;


/*
    What does "X PRECEDING" mean (and "X FOLLOWING")?

    ROWS is clear: just the number of rows above/below the current row.

    GROUPS is also fairly easy: it treats the rows whose values are the
    same (in the ORDER BY) as the "the same row". So, "-1 PRECEDING"
    means the previous group of rows, and so on.

    RANGE is a bit more complicated. It still groups the rows whose
    values are the same, but instead of moving up X groups, it moves up
    the number of rows _where their value is within X from the current
    row_! This is particularly useful for data that has gaps and for
    data that is not evenly distributed (such as dates!).
*/
drop table if exists temp__dates;
create temp table temp__dates(
    dt date primary key,
    amount real not null default (abs(random() % 10000) / 100.0)
);
create temp table temp__missing_dates(
    dt date primary key,
    amount real not null
);
insert into temp__dates(dt)

    with dates as (
            select current_date as dt
        union all
            select date(dt, '+1 day')
            from dates
            where dt < date(current_date, '+1 month')
    )

    select dt
    from dates
;
insert into temp__missing_dates(dt, amount)
    select dt, amount
    from temp__dates
    where abs(random() % 10) < 9
;


/* Using exclude */
select
    dt,
    amount,
    amount - avg(amount) over (
        order by dt rows between 2 preceding and 2 following exclude current row
    ) as delta_from_avg
from temp__dates
;


/* Using range (and adjusting dates to get integer addition working) */
with dt_as_int as (
    select
        dt,
        cast(strftime('%Y%m%d', dt) as int) as dt_int,
        amount
    from temp__missing_dates
)

select
    dt,
    amount,
    sum(amount) over (order by dt rows 2 preceding) as running_sum,
    sum(amount) over (order by dt_int range 2 preceding) as running_sum,  /* Within 2 days (not 2 rows!) */
    sum(amount) over (order by dt range 2 preceding) as running_sum  /* Doesn't work (in SQLite)! */
from dt_as_int
;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* PostgreSQL */
-- use postgres;


/* Example of using a datetime range in a window */
select
    payment_date,
    amount,
    sum(amount) over (
        order by payment_date range interval '3 hour' preceding
    ) as payments_in_last_3_hours
from payment
order by payment_date
;
