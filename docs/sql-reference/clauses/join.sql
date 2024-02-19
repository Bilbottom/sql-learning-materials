/*
    JOIN

    ON
    USING

    Join types:
    - INNER
    - LEFT (OUTER)
    - RIGHT (OUTER)
    - FULL (OUTER)

    - CROSS
    - POSITIONAL (DuckDB only)

    - LATERAL (Snowflake and DuckDB only)

    - SEMI (DuckDB 0.8+ only)
    - ANTI (DuckDB 0.8+ only)

    Modifiers:
    - NATURAL
    - ASOF (DuckDB only)

    Hints (SQL Server only, but all have something similar internally):
    - LOOP
    - HASH
    - MERGE

    --------------------------------------------------------------------

    The JOIN clause is how we combine data from different tables in SQL.
    The JOIN syntax is ANSI SQL and, in some cases, extends the usual
    functionality of the non-ANSI joins.

    --------------------------------------------------------------------

    Docs:
    - https://duckdb.org/docs/sql/query_syntax/from.html
    - https://www.sqlite.org/syntax/join-clause.html
    - https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-JOIN
    - https://learn.microsoft.com/en-us/sql/relational-databases/performance/joins
    - https://docs.snowflake.com/en/sql-reference/constructs/join

    --------------------------------------------------------------------

    All 5 have the INNER, OUTER (LEFT, RIGHT, FULL), and CROSS join
    types, as well as the the ON clause.

    - DuckDB has it all 💙
    - SQLite also has USING and NATURAL
    - PostgreSQL also has USING and NATURAL
    - SQL Server doesn't have anything else
    - Snowflake also has USING, NATURAL, and LATERAL
*/


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* SQL Server */
use AdventureWorks2022;
set statistics time on;


/* Non-ANSI INNER JOIN */
select
    Person.BusinessEntityID,
    Person.FirstName,
    Person.LastName,
    PersonPhone.PhoneNumber
from Person.Person, Person.PersonPhone
where Person.BusinessEntityID = PersonPhone.BusinessEntityID
order by Person.BusinessEntityID
;

/* ANSI INNER JOIN */
select
    Person.BusinessEntityID,
    Person.FirstName,
    Person.LastName,
    PersonPhone.PhoneNumber
from Person.Person
    inner join Person.PersonPhone
        on Person.BusinessEntityID = PersonPhone.BusinessEntityID
order by Person.BusinessEntityID
;


/* Multiple ANSI joins */
select
    person.BusinessEntityID,
    person.FirstName,
    person.LastName,
    phone.PhoneNumber,
    email.EmailAddress,
    CONCAT_WS(', ',
        address.AddressLine1,
        address.AddressLine2,
        address.City,
        address.PostalCode
    ) AS address
from Person.Person AS person
    inner join Person.PersonPhone AS phone
        on person.BusinessEntityID = phone.BusinessEntityID
    inner join Person.EmailAddress AS email
        on person.BusinessEntityID = email.BusinessEntityID
    left join Person.BusinessEntityAddress as entity_address
        on Person.BusinessEntityID = entity_address.BusinessEntityID
    left join Person.Address as address
        on entity_address.AddressID = address.AddressID
order by person.BusinessEntityID
;


/* Cross joins are rare, but great for getting all combinations of things */
select
    numbers.number,
    letters.letter
from (values (1), (2), (3)) as numbers(number)
    cross join (values ('a'), ('b'), ('c')) as letters(letter)
;


/*
    Specifying a join hint (SQL Server only) -- only use this if you
    know what you're doing.

    - https://docs.microsoft.com/en-us/sql/t-sql/queries/hints-transact-sql-join
*/
set statistics xml on;

/* Leaving it up to the optimiser */
select *
from Person.Person
    inner join Person.PersonPhone
        on Person.BusinessEntityID = PersonPhone.BusinessEntityID
;

/* Forcing a LOOP join */
select *
from Person.Person
    inner loop join Person.PersonPhone
        on Person.BusinessEntityID = PersonPhone.BusinessEntityID
;

/* Forcing a HASH join */
select *
from Person.Person
    inner hash join Person.PersonPhone
        on Person.BusinessEntityID = PersonPhone.BusinessEntityID
;

/* Forcing a MERGE join */
select *
from Person.Person
    inner merge join Person.PersonPhone
        on Person.BusinessEntityID = PersonPhone.BusinessEntityID
;

set statistics xml off;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* DuckDB */
-- USE loan.db;


/* USING is great to use when it's unambiguous */
select
    customer_id,
    loans.loan_id,
    loans.loan_value,
from customers
    inner join loans
        using (customer_id)
;


/* NATURAL joins are only "safe" when you define the columns */
select
    customer_id,
    customers.customer_type,
    coalesce(loan_values.total_loan_value, 0) as total_loan_value,
from customers
    natural left join (
        select
            customer_id,
            sum(loan_value) as total_loan_value,
        from loans
        group by customer_id
    ) as loan_values
order by customer_id
;


/* ...but * will de-deduplicate the columns, which is nice! */
select *
from customers
    natural join loans
;


/* A POSITIONAL join is good for "gluing" two tables together */
select
    numbers.number,
    letters.letter,
from (values (1), (2), (3)) as numbers(number)
    positional join (values ('a'), ('b'), ('c'), ('d')) as letters(letter)
;


/* LATERAL (joins) are an generalisation of correlated sub-queries */
select *
from customers,
    lateral (
        select sum(loan_value)
        from loans
        where loans.customer_id = customers.customer_id
    ) as loan_values
;
