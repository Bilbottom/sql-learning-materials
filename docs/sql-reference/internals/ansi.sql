/*
    ANSI SQL

    --------------------------------------------------------------------

    ANSI stands for American National Standards Institute. It is an
    organisation that oversees the development of standards for various
    products, services, processes and systems in the United States
    (which other countries choose to adopt, too).

    - https://www.ansi.org/

    One of the standards that ANSI oversees is the SQL standard. The
    SQL standard is a specification that describes how a database
    management system should function.

    - https://blog.ansi.org/sql-standard-iso-iec-9075-2023-ansi-x3-135/

    The SQL standard is a specification, not an implementation. This
    means that anyone building a database management system can choose
    to implement the SQL standard however they like (or, not at all!).
    This is why there are so many different database management systems,
    and why they can have slightly different syntax.

    --------------------------------------------------------------------

    There are several specifications in the SQL standard, but the one
    with the most significant syntax differences is the one that
    describes how to write joins.

    Before the SQL standard was created, tables were joined by listing
    them in the FROM clause, and then specifying the join condition in
    the WHERE clause. Most database management systems still support
    this syntax (at least, for inner joins), but it is not part of the
    SQL standard.

    The SQL standard specifies that tables should be joined by having
    exactly one table in the FROM clause, and then specifying the other
    tables in the JOIN clause(s). The join condition is specified in the
    ON clause (or the USING clause).
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
from
    Person.Person,
    Person.PersonPhone
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


/* Multiple Non-ANSI joins (SQL Server 2008 or earlier with compatibility level <=80) */
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
from
    Person.Person AS person,
    Person.PersonPhone AS phone,
    Person.EmailAddress AS email,
    Person.BusinessEntityAddress as entity_address,
    Person.Address as address
where person.BusinessEntityID = phone.BusinessEntityID
  and person.BusinessEntityID = email.BusinessEntityID
  and Person.BusinessEntityID *= entity_address.BusinessEntityID
  and entity_address.AddressID *= address.AddressID
order by person.BusinessEntityID
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


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* Snowflake */


/* Snowflake uses Oracle non-ANSI outer join syntax */
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
from
    Person.Person AS person,
    Person.PersonPhone AS phone,
    Person.EmailAddress AS email,
    Person.BusinessEntityAddress as entity_address,
    Person.Address as address
where person.BusinessEntityID = phone.BusinessEntityID
  and person.BusinessEntityID = email.BusinessEntityID
  and Person.BusinessEntityID = entity_address.BusinessEntityID(+)
  and entity_address.AddressID = address.AddressID(+)
order by person.BusinessEntityID
;
