/*
    Collation

    --------------------------------------------------------------------

    Collations are a set of rules that determine how data is sorted and
    compared. Collations that are used with character data types, such
    as varchar, dictate the code page and corresponding characters that
    can be represented for that data type.

    Collation is a column-level attribute: different columns can use
    different collations in the same table, and you can change the
    collation on the fly.

    --------------------------------------------------------------------

    Docs:
    - https://duckdb.org/docs/sql/expressions/collations.html
    - https://www.sqlite.org/datatype3.html#collating_sequences
    - https://www.postgresql.org/docs/current/collation.html
    - https://learn.microsoft.com/en-us/sql/relational-databases/collations/collation-and-unicode-support
    - https://docs.snowflake.com/en/sql-reference/collation

    --------------------------------------------------------------------

    Since all databases need to compare strings, they call have
    collation support.
*/


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* SQL Server */
use AdventureWorks2022;
set statistics time on;


/* Current Collation */
select
    @@version,
    serverproperty('collation')
;

/* Collation comparison */
select
    iif('TEXT' = 'text         ', 1, 0),
    iif('TEXT' = 'text         ' collate Latin1_General_CS_AS, 1, 0)
;


/* Sort and Compare Examples */
create table #raw_data(
    col varchar(100)
);
insert into #raw_data
    select *
    from (values
        ('Adventure Works'),
        ('Adventure works'),
        ('adventure works'),
        ('ADVENTURE WORKS')
    ) as v(col)
;
/* ...aggregating data case-sensitively */
select
    col collate Latin1_General_CS_AS as col,
    count(*)
from #raw_data
group by col collate Latin1_General_CS_AS
;
/* ...aggregating data case-insensitively */
select
    col collate Latin1_General_CI_AI as col,
    count(*)
from #raw_data
group by col collate Latin1_General_CI_AI
;
/* ...identifying casing differences */
select
    col,
    iif(col = upper(col) collate Latin1_General_CS_AS, 1, 0) as is_upper,
    iif(col = lower(col) collate Latin1_General_CS_AS, 1, 0) as is_lower
from #raw_data
;


/* Name Example 1 */
with names as (
    select *
    from (values
        ('LeVar', 'Burton'),
        ('Patrick', 'Stewart'),
        ('leonard', 'nimoy'),
        ('LaToya', 'Jackson'),
        ('MICHAEL', 'JACKSON'),
        ('Richard', 'McMillan')
    ) as v(first_name, last_name)
)

select
    first_name,
    last_name,

    iif(0=1
        or first_name = lower(first_name) collate Latin1_General_CS_AS
        or first_name = upper(first_name) collate Latin1_General_CS_AS,
        1, 0
    ) as first_name_is_incorrect,
    iif(0=1
        or last_name = lower(last_name) collate Latin1_General_CS_AS
        or last_name = upper(last_name) collate Latin1_General_CS_AS,
        1, 0
    ) as last_name_is_incorrect
from names
;


/* Name Example 2 */
with names as (
    select *
    from (values
        ('Facebook'),
        ('TikTok'),
        ('APPLE'),
        ('netflix'),
        ('amazon'),
        ('JPMorgan Chase'),
        ('WALMART'),
        ('BANK OF ENGLAND')
    ) as v(full_name)
)

select
    full_name,

    iif(0=1
        or full_name = lower(full_name) collate Latin1_General_CS_AS
        or full_name = upper(full_name) collate Latin1_General_CS_AS,
        1, 0
    ) as full_name_is_incorrect
from names
;
