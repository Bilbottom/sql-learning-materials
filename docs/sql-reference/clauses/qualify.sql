/*
    QUALIFY

    --------------------------------------------------------------------

    The QUALIFY clause is how we filter on window function results.

    --------------------------------------------------------------------

    Docs:
    - https://duckdb.org/docs/sql/query_syntax/qualify
    - https://docs.snowflake.com/en/sql-reference/constructs/qualify

    --------------------------------------------------------------------

    Only DuckDB and Snowflake support this.
*/


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* DuckDB */
-- USE loan.db;


/* Largest loan per customer */
select *
from loans
qualify 1 = row_number() over (
    partition by customer_id
    order by loan_value desc
);
