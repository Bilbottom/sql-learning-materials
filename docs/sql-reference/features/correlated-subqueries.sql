/*
    Correlated sub-queries

    --------------------------------------------------------------------

    Correlated sub-queries are basically for-loops! For each row in the
    "outer" query, the "inner" query is executed.

    --------------------------------------------------------------------

    Docs:
    - https://duckdb.org/2023/05/26/correlated-subqueries-in-sql.html
    - https://sqlite.org/lang_expr.html#cosub
    - https://www.postgresql.org/docs/current/sql-expressions.html#SQL-SYNTAX-SCALAR-SUBQUERIES
    - https://learn.microsoft.com/en-us/sql/relational-databases/performance/subqueries#correlated
    - https://docs.snowflake.com/en/user-guide/querying-subqueries

    --------------------------------------------------------------------

    All 5 support correlated sub-queries, but they each have different
    limitations and performance characteristics.
*/


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* SQL Server */
use AdventureWorks2022;
set statistics time on;


/* Pretending it's a join */
select
    BusinessEntityID,
    FirstName,
    LastName,
    (
        select PhoneNumber
        from Person.PersonPhone
        where Person.BusinessEntityID = PersonPhone.BusinessEntityID
    ) as PhoneNumber
from Person.Person
order by BusinessEntityID
;


/* Keeping last modified person per PersonType (for DBs without QUALIFY) */
select
    PersonType,
    BusinessEntityID,
    FirstName,
    LastName,
    ModifiedDate
from Person.Person
where BusinessEntityID = (
    select top 1 BusinessEntityID
    from Person.Person as person_inner
    where Person.PersonType = person_inner.PersonType
    order by ModifiedDate desc
)
order by PersonType
;
/* ...and the window function equivalent for reference */
select
    PersonType,
    BusinessEntityID,
    FirstName,
    LastName,
    ModifiedDate
from (
    select
        *,
        row_number() over (partition by PersonType order by ModifiedDate desc) as row_num
    from Person.Person
) as people
where row_num = 1
order by PersonType
;


/* As a filter on the existence of records */
select
    BusinessEntityID,
    LoginID,
    JobTitle,
    HireDate,
    ModifiedDate
from HumanResources.Employee
where exists(
    select *
    from HumanResources.JobCandidate
    where Employee.BusinessEntityID = JobCandidate.BusinessEntityID
)
order by BusinessEntityID
;
/* ...and the equivalent IN filter */
select
    BusinessEntityID,
    LoginID,
    JobTitle,
    HireDate,
    ModifiedDate
from HumanResources.Employee
where BusinessEntityID IN (
    select BusinessEntityID
    from HumanResources.JobCandidate
)
order by BusinessEntityID
;
/* ...and the equivalent LEFT JOIN filter */
select
    Employee.BusinessEntityID,
    Employee.LoginID,
    Employee.JobTitle,
    Employee.HireDate,
    Employee.ModifiedDate
from HumanResources.Employee
    left join HumanResources.JobCandidate
        on Employee.BusinessEntityID = JobCandidate.BusinessEntityID
where JobCandidate.BusinessEntityID is not null
order by Employee.BusinessEntityID
;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* SQLite */
-- USE loan.db;


/* Month-end balances over time from a delta table */
with
    date_axis as (
            select
                date('2020-01-01') as month_date,   /* The reporting date (the "month-end" date) */
                date('2020-02-01') as balance_date  /* The date that balances need to be before  */
        union all
            select
                date(month_date,   '+1 month'),
                date(balance_date, '+1 month')
            from date_axis
            where month_date < (
                select max(balance_date)
                from balances
            )
    ),
    month_end_balances as (
        select
            date_axis.month_date,
            loans.loan_id,
            (
                select balance
                from balances as bal_inner
                where loans.loan_id = bal_inner.loan_id
                  and date_axis.balance_date > bal_inner.balance_date
                order by bal_inner.balance_date desc
                limit 1
            ) as balance
        from date_axis
            cross join (
                select distinct loan_id
                from loans
            ) as loans
    )

select
    month_date as reporting_month,
    sum(balance) as month_end_balance
from month_end_balances
group by month_date
order by month_date
;
