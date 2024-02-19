/*
    GROUP BY [columns, ALL]

    FILTER  (after aggregate functions)
    HAVING  (after GROUP BY)

    Extensions:
    - ROLLUP
    - GROUPING SETS
    - CUBE

    Related functions:
    - GROUPING/GROUPING_ID

    --------------------------------------------------------------------

    The GROUP BY clause is how we aggregate data in SQL.

    --------------------------------------------------------------------

    Docs:
    - https://duckdb.org/docs/sql/query_syntax/groupby.html
    - https://www.sqlite.org/lang_select.html
    - https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-GROUP
    - https://learn.microsoft.com/en-us/sql/t-sql/queries/select-group-by-transact-sql
    - https://docs.snowflake.com/en/sql-reference/constructs/group-by

    Aggregate functions:
    - https://duckdb.org/docs/sql/aggregates.html
    - https://www.sqlite.org/lang_aggfunc.html
    - https://www.postgresql.org/docs/current/functions-aggregate.html
    - https://docs.microsoft.com/en-us/sql/t-sql/functions/aggregate-functions-transact-sql
    - https://docs.snowflake.com/en/sql-reference/functions-aggregation

    --------------------------------------------------------------------

    - DuckDB has it all 💙
    - SQLite only has FILTER and HAVING
    - PostgreSQL has everything except GROUP BY ALL
    - SQL Server doesn't have FILTER or GROUP BY ALL
    - Snowflake doesn't have FILTER
*/


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* SQL Server */
use AdventureWorks2022;
set statistics time on;


/* Aggregates without a GROUP BY */
select count(*) as records
from Person.Person
;


/* In SQL Server, this is identical to GROUP BY () */
select count(*) as records
from Person.Person
group by ()
;


/* Aggregates with a GROUP BY */
select
    PersonType,
    count(*) as records,
    count(title) as non_null_titles,
    count(distinct FirstName) as distinct_first_names,
    max(ModifiedDate) as latest_modified_date
from Person.Person
group by PersonType
order by PersonType
;


/* Multiple columns in a group by */
select
    PersonType,
    EmailPromotion,
    count(*) as records,
    count(Title) as non_null_titles,
    count(distinct FirstName) as distinct_first_names,
    max(ModifiedDate) as latest_modified_date
from Person.Person
group by
    PersonType,
    EmailPromotion
order by
    PersonType,
    EmailPromotion
;


/* Filter the _output_ with HAVING */
select
    PersonType,
    EmailPromotion,
    count(*) as records,
    count(Title) as non_null_titles,
    count(distinct FirstName) as distinct_first_names,
    max(ModifiedDate) as latest_modified_date
from Person.Person
group by
    PersonType,
    EmailPromotion
having count(*) > 1000
order by
    PersonType,
    EmailPromotion
;


/* Note how this orders the records for us! */
select
    grouping_id(PersonType, EmailPromotion) as group_id,
    PersonType,
    EmailPromotion,
    count(*) as records,
    count(Title) as non_null_titles,
    count(distinct FirstName) as distinct_first_names,
    max(ModifiedDate) as latest_modified_date
from Person.Person
group by rollup (
    PersonType,
    EmailPromotion
);


/* This one is the same as the ROLLUP... */
select
    grouping_id(PersonType, EmailPromotion) as group_id,
    PersonType,
    EmailPromotion,
    count(*) as records,
    count(Title) as non_null_titles,
    count(distinct FirstName) as distinct_first_names,
    max(ModifiedDate) as latest_modified_date
from Person.Person
group by grouping sets (
    (),
    (PersonType),
    (PersonType, EmailPromotion)
);


/* ...and this one gives us group 2 (but not group 1) */
select
    grouping_id(PersonType, EmailPromotion) as group_id,
    PersonType,
    EmailPromotion,
    count(*) as records,
    count(Title) as non_null_titles,
    count(distinct FirstName) as distinct_first_names,
    max(ModifiedDate) as latest_modified_date
from Person.Person
group by grouping sets (
    (),
    (EmailPromotion),
    (PersonType, EmailPromotion)
);


/* Putting several combinations in the GROUPING SETS */
select
    grouping_id(PersonType, EmailPromotion) as group_id,
    PersonType,
    EmailPromotion,
    count(*) as records,
    count(Title) as non_null_titles,
    count(distinct FirstName) as distinct_first_names,
    max(ModifiedDate) as latest_modified_date
from Person.Person
group by grouping sets (
    (),
    (PersonType),
    (EmailPromotion),
    (PersonType, EmailPromotion)
);


/* This is the same as the last GROUPING SETS example */
select
    grouping_id(PersonType, EmailPromotion) as group_id,
    PersonType,
    EmailPromotion,
    count(*) as records,
    count(Title) as non_null_titles,
    count(distinct FirstName) as distinct_first_names,
    max(ModifiedDate) as latest_modified_date
from Person.Person
group by cube (PersonType, EmailPromotion)
;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* DuckDB */
-- USE loan.db;

/* GROUP BY ALL */
select
    left(customer_id, 3) as customer_type,
    count(*) as total_loan_volume,
    count(distinct loan_value) as distinct_loan_values,
    sum(loan_value) as total_loan_value,
    avg(loan_value) as average_loan_value,
from loans
group by all
;


/* Using calculated columns */
select
    relationship_type,
    left(parent_customer_id, 3) as parent_customer_type,
    left(child_customer_id, 3) as child_customer_type,
    count(*) as customer_count,
    grouping(relationship_type, parent_customer_type, child_customer_type) as group_id
from customer_relationships
group by grouping sets (
    (relationship_type),
    (relationship_type, parent_customer_type, child_customer_type),
)
having customer_count >= 6
;


/* FILTER instead of CASE */
select
    left(parent_customer_id, 3) as parent_customer_type,
    left(child_customer_id, 3) as child_customer_type,
    count(*) as customer_count,
    count(*) filter (where relationship_type = 'Subsidiary') as subsidiary_count,
    count(*) filter (where relationship_type = 'Director') as director_count,
from customer_relationships
group by all
;
