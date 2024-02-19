/*
    VALUES

    --------------------------------------------------------------------

    The VALUES clause is a "shortcut" for repeated UNION ALL statements.

    --------------------------------------------------------------------

    Docs:
    - https://duckdb.org/docs/sql/query_syntax/values
    - https://www.sqlite.org/lang_select.html
    - https://www.postgresql.org/docs/current/sql-values.html
    - https://learn.microsoft.com/en-us/sql/t-sql/queries/table-value-constructor-transact-sql
    - https://docs.snowflake.com/en/sql-reference/constructs/values

    --------------------------------------------------------------------

    All 5 have this.
*/


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* SQL Server */
use AdventureWorks2022;
set statistics time on;


/* Simple example */
select *
from (values (1), (2), (3)) as v(id)
;

/* Multiple columns per row */
select *
from (
    values
        (1, 'alice', '2021-01-01'),
        (2, 'bob', '2021-02-01'),
        (3, 'charlie', '2021-03-01')
) as v(id, username, create_dt)
;

/* Using VALUES to implement LEAST/GREATEST functions */
with base as (
        select
            '2020-01-01' as c1,
            '2020-02-01' as c2,
            '2020-03-01' as c3,
            '2020-04-01' as c4,
            '2020-05-01' as c5
    union
        select
            '2021-01-01' as c1,
            '2021-02-01' as c2,
            '2021-03-01' as c3,
            '2021-04-01' as c4,
            '2021-05-01' as c5
)

select
    c1,
    c2,
    c3,
    c4,
    c5,

    (
        select min(c)
        from (values (c1), (c2), (c3), (c4), (c5)) as v(c)
    ) as min_c,
    (
        select max(c)
        from (values (c1), (c2), (c3), (c4), (c5)) as v(c)
    ) as max_c,

    least(c1, c2, c3, c4, c5) as least_c,
    greatest(c1, c2, c3, c4, c5) as greatest_c
from base
;
