/*
    TRY_CAST

    --------------------------------------------------------------------

    The TRY_CAST function is the same as CAST, except that it returns
    NULL if the cast fails instead of throwing an error. This can be
    super handy for dealing with messy data.

    --------------------------------------------------------------------

    Docs:
    - https://duckdb.org/docs/sql/expressions/cast.html
    - https://learn.microsoft.com/en-us/sql/t-sql/functions/try-cast-transact-sql
    - https://docs.snowflake.com/en/sql-reference/functions/try_cast

    --------------------------------------------------------------------

    This exists in each of the dialects except SQLite and PostgreSQL.
*/


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* SQL Server */
use AdventureWorks2022;
set statistics time on;


/* Parsing strings into dates */
with messy_dates as (
    select *
    from (values
        ('2022-07-21'),
        ('21/07/2022'),
        ('07/21/2022'),
        ('21/21/2022')  /* An invalid date (on purpose) */
    ) as v(messy_dates)
)

select
    messy_dates,
    coalesce(
        try_cast(messy_dates as date),
        try_parse(messy_dates as date using 'en-GB')
    ) as dates
from messy_dates
;
