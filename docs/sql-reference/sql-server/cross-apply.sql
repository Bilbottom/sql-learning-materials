/*
    CROSS APPLY

    --------------------------------------------------------------------

    CROSS APPLY is like a mix between a JOIN and a correlated subquery.

    CROSS APPLY has 2 good use-cases:
    1.  Using a 'table-valued' function, such as `OPENJSON`
    2.  Using a correlated subquery that returns multiple columns

    SQL Server calls its built-in table-valued functions "relational
    operators":
    - https://docs.microsoft.com/en-us/sql/t-sql/language-elements/relational-operators-transact-sql

    Good answer for why CROSS APPLY over a JOIN:
    - https://stackoverflow.com/questions/1139160/when-should-i-use-cross-apply-over-inner-join

    --------------------------------------------------------------------

    Docs:
    - https://learn.microsoft.com/en-us/sql/t-sql/queries/from-transact-sql#using-apply
*/
use AdventureWorks2022;
set statistics time on;


/* Using CROSS APPLY to unpack JSON */
with cte_json as (
    select *
    from (values
        (1, '{"id": 1001, "name": "Alice"}'),
        (2, '{"id": 1002, "name": "Bob"}'),
        (3, '{"id": 1003, "name": "Charlie"}')
    ) as v(id, json)
)

select
    id,
    json,
    user_id,
    user_name
from cte_json
    cross apply openjson(json) with (
        user_id int '$.id',
        user_name varchar(16) '$.name'
    )
;


/*
    Using CROSS APPLY as a correlated subquery with many column outputs

    TODO: This is a silly example since we should just use a join
*/
select
    Person.BusinessEntityID,
    Person.FirstName,
    Person.LastName,
    person_address.AddressLine1,
    person_address.City,
    person_address.PostalCode
from Person.Person
    cross apply (
        select
            Address.AddressLine1,
            Address.City,
            Address.PostalCode
        from Person.BusinessEntityAddress
            inner join Person.Address
                on BusinessEntityAddress.AddressID = Address.AddressID
        where Person.BusinessEntityID = BusinessEntityAddress.BusinessEntityID
    ) as person_address
order by Person.BusinessEntityID
;
