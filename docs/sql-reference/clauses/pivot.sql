/*
    PIVOT

    UNPIVOT

    --------------------------------------------------------------------

    The PIVOT clause allows us to rotate values from rows into columns.

    --------------------------------------------------------------------

    Docs:
    - https://duckdb.org/docs/sql/statements/pivot.html
    - https://learn.microsoft.com/en-us/sql/t-sql/queries/from-using-pivot-and-unpivot
    - https://docs.snowflake.com/en/sql-reference/constructs/pivot

    --------------------------------------------------------------------

    SQLite and PostgreSQL doesn't support this.

    - DuckDB has PIVOT and dynamic pivoting (0.8+ only)
    - SQL Server has PIVOT and UNPIVOT
    - Snowflake has PIVOT and UNPIVOT
*/


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* SQL Server */
use AdventureWorks2022;
set statistics time on;


/* PIVOT Example */
select
    EmailPromotion,
    coalesce(GC, 0) as gc_volume,
    coalesce(SP, 0) as sp_volume,
    coalesce(EM, 0) as em_volume,
    coalesce("IN", 0) as in_volume,
    coalesce(VC, 0) as vc_volume,
    coalesce(SC, 0) as sc_volume
from (
    select
        PersonType,
        EmailPromotion,
        count(*) as volume
    from Person.Person
    group by PersonType, EmailPromotion
) as unpvt
pivot (
    max(volume)
    for PersonType in (GC, SP, EM, "IN", VC, SC)
) as pvt
;


/* PIVOT Example with Subtotal (Bonus) */
select
    EmailPromotion,
    coalesce(GC, 0) as gc_volume,
    coalesce(SP, 0) as sp_volume,
    coalesce(EM, 0) as em_volume,
    coalesce("IN", 0) as in_volume,
    coalesce(VC, 0) as vc_volume,
    coalesce(SC, 0) as sc_volume
from (
    select
        PersonType,
        coalesce(cast(EmailPromotion as char(1)), 'TOTAL') as EmailPromotion,
        count(*) as volume
    from Person.Person
    group by grouping sets (
        (PersonType, EmailPromotion),
        (PersonType)
    )
) as unpvt
pivot (
    max(volume)
    for PersonType in (GC, SP, EM, "IN", VC, SC)
) as pvt
;


/* PIVOT using CASE (what you have to do in DBs that don't have PIVOT) */
select
    EmailPromotion,
    coalesce(max(case when PersonType = 'GC' then volume end), 0) as gc_volume,
    coalesce(max(case when PersonType = 'SP' then volume end), 0) as sp_volume,
    coalesce(max(case when PersonType = 'EM' then volume end), 0) as em_volume,
    coalesce(max(case when PersonType = 'IN' then volume end), 0) as in_volume,
    coalesce(max(case when PersonType = 'VC' then volume end), 0) as vc_volume,
    coalesce(max(case when PersonType = 'SC' then volume end), 0) as sc_volume
from (
    select
        PersonType,
        EmailPromotion,
        count(*) as volume
    from Person.Person
    group by PersonType, EmailPromotion
) as unpvt
group by EmailPromotion
;


/* PIVOT using CASE with Subtotal (Bonus) */
select
    coalesce(cast(EmailPromotion as char(1)), 'TOTAL') as account_status,
    coalesce(max(case when PersonType = 'GC' then volume end), 0) as gc_volume,
    coalesce(max(case when PersonType = 'SP' then volume end), 0) as sp_volume,
    coalesce(max(case when PersonType = 'EM' then volume end), 0) as em_volume,
    coalesce(max(case when PersonType = 'IN' then volume end), 0) as in_volume,
    coalesce(max(case when PersonType = 'VC' then volume end), 0) as vc_volume,
    coalesce(max(case when PersonType = 'SC' then volume end), 0) as sc_volume
from (
    select
        PersonType,
        EmailPromotion,
        count(*) as volume
    from Person.Person
    group by PersonType, EmailPromotion
) as unpvt
group by rollup (EmailPromotion)
;


/* Simple (and maybe silly) UNPIVOT example */
select
    column_name,
    value
from (
    select
        CAST(BusinessEntityID AS VARCHAR) AS BusinessEntityID,
        CAST(PersonType AS VARCHAR) AS PersonType,
        CAST(Title AS VARCHAR) AS Title,
        CAST(FirstName AS VARCHAR) AS FirstName,
        CAST(MiddleName AS VARCHAR) AS MiddleName,
        CAST(LastName AS VARCHAR) AS LastName,
        CAST(Suffix AS VARCHAR) AS Suffix,
        CAST(EmailPromotion AS VARCHAR) AS EmailPromotion
    from Person.Person
    where BusinessEntityID = 1
) as pvt
unpivot (
    value for column_name in (
        BusinessEntityID,
        PersonType,
        Title,
        FirstName,
        MiddleName,
        LastName,
        Suffix,
        EmailPromotion
    )
) as unpvt
;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* DuckDB */
-- USE loan.db;


/* DuckDB has a dynamic PIVOT syntax from 0.8 */
with customer_loans as (
    select
        customer_type,
        loan_value,
    from customers
        inner join loans using (customer_id)
)

/* Normal syntax */
-- from customer_loans
-- pivot (
--     sum(loan_value)
--     for customer_type in ('Business', 'Individual')
--     group by customer_id
-- )

/* Dynamic syntax */
pivot customer_loans
on customer_type
using sum(loan_value)
;
