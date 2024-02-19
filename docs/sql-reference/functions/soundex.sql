/*
    SOUNDEX

    --------------------------------------------------------------------

    SOUNDEX is "phonetic algorithm for indexing names by sound" and can
    be used for simple fuzzy matching.

    - https://en.wikipedia.org/wiki/Soundex

    --------------------------------------------------------------------

    Docs:
    - https://www.sqlite.org/lang_corefunc.html#soundex
    - https://www.postgresql.org/docs/16/fuzzystrmatch.html#FUZZYSTRMATCH-SOUNDEX
    - https://learn.microsoft.com/en-us/sql/t-sql/functions/soundex-transact-sql
    - https://docs.snowflake.com/en/sql-reference/functions/soundex

    --------------------------------------------------------------------

    This exists in each of the dialects except DuckDB (which has several
    other -- and better -- text similarity functions).
*/


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* SQL Server */
use AdventureWorks2022;
set statistics time on;


/* SOUNDEX Examples */
with raw_data as (
    select *
    from (values
        ('Apple', 'Pear'),
        ('Bread', 'Milk'),
        ('Orthogonal', 'Perpendicular'),
        ('Alex', 'Brendan'),
        ('Supercalifragilisticexpialidocious', 'Pneumonoultramicroscopicsilicovolcanoconiosis'),
        ('', NULL),
        ('Rush', 'Russia'),
        ('Jeans', 'Genes'),
        ('Your', 'You''re'),
        ('I', 'Eye'),
        ('Through', 'Thru'),
        ('Good', 'Gouda')
    ) as v(word_1, word_2)
)

select
    word_1,
    word_2,
    soundex(word_1) as word_1_soundex,
    soundex(word_2) as word_2_soundex,
    difference(word_1, word_2) as soundex_difference
from raw_data
;


/*
    Explicit Example - Matching names to emails
    -------------------------------------------

    A given company can have multiple contacts.

    The company will have a business email address, and each contact
    will have their own personal email address.

    Given the business email address, we want to find which contact is
    most likely the one that owns the business email address since the
    business email address and personal email address are often
    different.
*/
with
    customers as (
        select *
        from (values
            (1, 'Awesome Actorz', null, null, 'joe.t@awesomeactorz.com'),
            (2, 'Rachel Green', 'Rachel', 'Green', 'rachel.green@gmail.com'),
            (3, 'Monica Geller', 'Monica', 'Geller', 'gellerm@gmail.com'),
            (4, 'Ross Geller', 'Ross', 'Geller', null),
            (5, 'Joey Tribbiani', 'Joey', 'Tribbiani', 'jtribbiani@gmail.com'),
            (6, 'Chandler Bing', 'Chandler', 'Bing', 'c.bing@gmail.com'),
            (7, 'Phoebe Buffay', 'Phoebe', 'Buffay', null),
            (8, 'Fractal Factory', null, null, 'bill@fractal.factory'),
            (9, 'Bill Bloggs', 'Will', 'Bloggs', null),
            (10, 'Joe Bloggs', 'Joe', 'Bloggs', null)
        ) as v(customer_id, full_name, first_name, last_name, email_address)
    ),
    customer_relationships as (
        select *
        from (values
            (1, 2, 'Director'),
            (1, 3, 'Director'),
            (1, 4, 'Director'),
            (1, 5, 'Director'),
            (1, 6, 'Director'),
            (1, 7, 'Director'),
            (8, 9, 'Director'),
            (8, 10, 'Director')
        ) as v(parent_customer_id, child_customer_id, relationship_type)
    )

select
    c_p.full_name as business_name,
    c_p.email_address as business_email_address,
    c_c.first_name,
    c_c.last_name,
    c_c.email_address,

    left(c_p.email_address, -1 + charindex('@', c_p.email_address)) as email_domain,
    soundex(left(c_p.email_address, charindex('@', c_p.email_address))) as email_domain_soundex,
    soundex(c_c.first_name) as first_name_soundex,
    difference(
        left(c_p.email_address, charindex('@', c_p.email_address)),
        c_c.first_name
    ) as soundex_difference,
    row_number() over(
        partition by cr.parent_customer_id
        order by difference(
            left(c_p.email_address, charindex('@', c_p.email_address)),
            c_c.first_name
        ) desc
    ) as contact_preference
from customer_relationships as cr
    left join customers as c_p
        on cr.parent_customer_id = c_p.customer_id
    left join customers as c_c
        on cr.child_customer_id = c_c.customer_id
;
