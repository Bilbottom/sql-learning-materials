/*
    Recursive CTEs

    --------------------------------------------------------------------

    Recursive CTEs are basically while-loops! While some condition is
    true (the WHERE clause), keep looping through the CTE and applying
    the logic to the rows that had been generated in the previous
    iteration.

    There are 2 "flavours" of recursive CTEs:

    1.  Data generation
    2.  Hierarchy flattening

    In modern databases there are usually specific features that allow
    you to do these things without recursive CTEs, but they're still
    useful to know about -- especially since some of these new features
    aren't as powerful as recursive CTEs!

    --------------------------------------------------------------------

    Docs:
    - https://duckdb.org/docs/sql/query_syntax/with.html#recursive-ctes
    - https://www.sqlite.org/lang_with.html#recursive_common_table_expressions
    - https://www.postgresql.org/docs/current/queries-with.html#QUERIES-WITH-RECURSIVE
    - https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql#guidelines-for-defining-and-using-recursive-common-table-expressions
    - https://docs.snowflake.com/en/user-guide/queries-hierarchical

    --------------------------------------------------------------------

    All 5 support recursive CTEs (of both flavours).
*/


/* Row Generation - Dates */
with dates as (
        select cast('2020-01-01' as date) as month_date
    union all
        select dateadd(month, 1, month_date)
        from dates
        where month_date < dateadd(month, -2, getdate())
)

select month_date
from dates
order by month_date
;


/*
    Row Generation - Fibonacci Sequence

    f(n + 1) = f(n) - f(n - 1)
    f(1) = f(2) = 1
*/
with fib as (
        select
            1 as n,
            1 as f_n,  /* f(n) */
            0 as f_1   /* f(n - 1) */
    union all
        select
            fib.n + 1 as n,
            fib.f_n + fib.f_1 as f_n,
            fib.f_n as f_1
        from fib
        where n < 46
)

select
    n,
    f_n
from fib
;


/*
    Row Generation - Mandelbrot Set (T-SQL)

    AUTHOR:  GRAEME JOB
    LINK:    https://thedailywtf.com/articles/Stupid-Coding-Tricks-The-TSQL-Madlebrot
    CREATED: 12-OCT-2008
    BECAUSE: JUST BECAUSE
*/
WITH
    XGEN(X, IX) AS (
        /*? X DIM GENERATOR */
            SELECT
                CAST(-2.2 AS FLOAT) AS X,
                0 AS IX
        UNION ALL
            SELECT
                CAST(X + 0.031 AS FLOAT) AS X,
                IX + 1 AS IX
            FROM XGEN
            WHERE IX < 100
    ),
    YGEN(Y, IY) AS (
        /*? Y DIM GENERATOR */
            SELECT
                CAST(-1.5 AS FLOAT) AS Y,
                0 AS IY
        UNION ALL
            SELECT
                CAST(Y + 0.031 AS FLOAT) AS Y,
                IY + 1 AS IY
            FROM YGEN
            WHERE IY < 100
    ),
    Z(IX, IY, CX, CY, X, Y, I) AS (
        /*? Z POINT ITERATOR */
            SELECT
                IX,
                IY,
                X AS CX,
                Y AS CY,
                X,
                Y,
                0 AS I
            FROM XGEN, YGEN
        UNION ALL
            SELECT
                IX,
                IY,
                CX,
                CY,
                X * X - Y * Y + CX AS X,
                Y * X * 2 + CY,
                I + 1
            FROM Z
            WHERE X * X + Y * Y < 16
              AND I < 100
    )

SELECT
    TRANSLATE(
        (
            X0 +X1 +X2 +X3 +X4 +X5 +X6 +X7 +X8 +X9 +X10+X11+X12+X13+X14+X15+X16+X17+X18+X19+
            X20+X21+X22+X23+X24+X25+X26+X27+X28+X29+X30+X31+X32+X33+X34+X35+X36+X37+X38+X39+
            X40+X41+X42+X43+X44+X45+X46+X47+X48+X49+X50+X51+X52+X53+X54+X55+X56+X57+X58+X59+
            X60+X61+X62+X63+X64+X65+X66+X67+X68+X69+X70+X71+X72+X73+X74+X75+X76+X77+X78+X79+
            X80+X81+X82+X83+X84+X85+X86+X87+X88+X89+X90+X91+X92+X93+X94+X95+X96+X97+X98+X99
        ),
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        ' .,,,-----++++%%%%@@@@### '
    )
FROM (
    SELECT
        'X' + CAST(IX AS VARCHAR) AS IX,
        IY,
        SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ', ISNULL(NULLIF(I, 0), 1), 1) AS I
    FROM Z
) AS ZT
PIVOT (
    MAX(I) FOR IX IN (
        X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10,X11,X12,X13,X14,X15,X16,X17,X18,X19,
        X20,X21,X22,X23,X24,X25,X26,X27,X28,X29,X30,X31,X32,X33,X34,X35,X36,X37,X38,X39,
        X40,X41,X42,X43,X44,X45,X46,X47,X48,X49,X50,X51,X52,X53,X54,X55,X56,X57,X58,X59,
        X60,X61,X62,X63,X64,X65,X66,X67,X68,X69,X70,X71,X72,X73,X74,X75,X76,X77,X78,X79,
        X80,X81,X82,X83,X84,X85,X86,X87,X88,X89,X90,X91,X92,X93,X94,X95,X96,X97,X98,X99
    )
) AS PZT
;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* SQLite */
-- USE loan.db;


/* Descendents */
select
    cus.customer_id,
    cr1.child_customer_id,
    cr2.child_customer_id as grandchild_customer_id,
    cr3.child_customer_id as great_grandchild_customer_id
from customers as cus
    left join customer_relationships as cr1
        on cus.customer_id = cr1.parent_customer_id
    left join customer_relationships as cr2
        on cr1.child_customer_id = cr2.parent_customer_id
    left join customer_relationships as cr3
        on cr2.child_customer_id = cr3.parent_customer_id
where cus.customer_type = 'Lending Group'
order by
    cr3.child_customer_id desc,
    cr2.child_customer_id desc,
    cr1.child_customer_id desc,
    cus.customer_id
;


/* Descendents (properly) */
with cte_cus as (
        select
            customer_id,
            customer_id as descendent_customer_id,
            0 as generation
        from customers
        where customer_type = 'Lending Group'
    union all
        select
            cte_cus.customer_id,
            cr.child_customer_id as descendent_customer_id,
            1 + cte_cus.generation as generation
        from cte_cus
            inner join customer_relationships as cr
                on  cte_cus.descendent_customer_id = cr.parent_customer_id
                and cr.child_customer_id != cte_cus.customer_id
)

select distinct
    cte_cus.customer_id,
    cte_cus.descendent_customer_id,
    cus.customer_type as related_customer_type
from cte_cus
    left join customers as cus
        on cte_cus.descendent_customer_id = cus.customer_id
;


/* All relations (in all directions) */
with
    rels as (
            select
                parent_customer_id as customer_id,
                child_customer_id as related_customer_id
            from customer_relationships
        union
            select
                child_customer_id as customer_id,
                parent_customer_id as related_customer_id
            from customer_relationships
        union
            select
                customer_id,
                customer_id as related_customer_id
            from customers
    ),
    all_rels as (
            select
                customer_id,
                related_customer_id,
                customer_id || '-' || related_customer_id as cust_id_hist,
                0 as generation
            from rels
        union all
            select
                all_rels.customer_id,  /* Customer ID that we're 'searching' on */
                rels.related_customer_id,
                all_rels.cust_id_hist || '-' || rels.related_customer_id as cust_id_hist,
                all_rels.generation + 1 as generation
            from rels
                inner join all_rels
                    on  rels.customer_id  = all_rels.related_customer_id
                    and all_rels.cust_id_hist not like '%' || rels.related_customer_id || '%'
    )

select distinct
    customer_id,
    related_customer_id
from all_rels
where customer_id = 'LEN559852'
;
