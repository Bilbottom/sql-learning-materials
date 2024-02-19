/*
    SAMPLE

    --------------------------------------------------------------------

    The SAMPLE clause returns a random sample of rows from the table.

    --------------------------------------------------------------------

    Docs:
    - https://duckdb.org/docs/sql/query_syntax/sample.html
    - https://docs.snowflake.com/en/sql-reference/constructs/sample

    --------------------------------------------------------------------

    Related:
    - SELECT TOP X PERCENT (SQL Server)
*/


/*
    DuckDB

    https://duckdb.org/docs/sql/query_syntax/sample.html
*/

/* Select a sample of 10% of the records using default (system) sampling */
select *
from my_table
using sample 10%
;

/* Select a sample of 10% of the records using bernoulli sampling */
select *
from my_table
using sample 10% (bernoulli)
;

/* Select a sample of 10 rows */
select *
from my_table
using sample 10 rows
;

/* In each case, make it deterministic by specifying a seed */
select *
from my_table
using sample 10 rows repeatable (123)
;


/*
    Snowflake

    https://docs.snowflake.com/en/sql-reference/constructs/sample
*/

/* Select a sample of 10% of the records using default (system) sampling */
select *
from my_table
sample (10)
;

/* Select a sample of 10% of the records using bernoulli sampling */
select *
from my_table
sample bernoulli (10)
;

/* Select a sample of 10 rows */
select *
from my_table
sample (10 rows)
;

/* In each case, make it deterministic by specifying a seed */
select *
from my_table
sample (10 rows) seed (123)
;


/*
    SQLite/PostgreSQL/SQL Server

    A hack for SQLite/PostgreSQL/SQL Server
*/
select *
from my_table
order by random()
limit 10
;
