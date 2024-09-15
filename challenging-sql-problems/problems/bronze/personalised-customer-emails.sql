```sql
create table customers (
    customer_id   int primary key,
    full_name     varchar not null,
    first_name    varchar,
    last_name     varchar,
    email_address varchar
);
insert into customers
values
    (1,  'Friends For Hire', null,       null,        'joe.trib@f4hire.com'),
    (2,  'Rachel Green',     'Rachel',   'Green',     'rachel.green@gmail.com'),
    (3,  'Monica Geller',    'Monica',   'Geller',    'gellerm@gmail.com'),
    (4,  'Ross Geller',      'Ross',     'Geller',    null),
    (5,  'Joey Tribbiani',   'Joey',     'Tribbiani', 'joe.tribbiani@gmail.com'),
    (6,  'Chandler Bing',    'Chandler', 'Bing',      'c.bing@gmail.com'),
    (7,  'Phoebe Buffay',    'Phoebe',   'Buffay',    null),
    (8,  'Fractal Factory',  null,       null,        'billiam@fractal-factory.co.uk'),
    (9,  'William Bloggs',   'William',  'Bloggs',    null),
    (10, 'Joe Bloggs',       'Joe',      'Bloggs',    null),
    (11, 'Some Company',     null,       null,        'admin@somecompany.com'),
    (12, 'Zoe Goode',        'Penny',    'Lane',      'pink.lotus@gmail.com'),
    (13, 'Leeroy Smythe',    'Leeroy',   'Smythe',    'lee.the.boss@gmail.com')
;

create table customer_relationships (
    parent_customer_id int references customers(customer_id),
    child_customer_id  int references customers(customer_id),
    relationship_type  varchar not null,
    primary key (parent_customer_id, child_customer_id)
);
insert into customer_relationships
values
    (1,  2,  'Director'),
    (1,  3,  'Shareholder'),
    (1,  4,  'Shareholder'),
    (1,  5,  'Director'),
    (1,  6,  'Director'),
    (1,  7,  'Director'),
    (8,  9,  'Director'),
    (8,  10, 'Director'),
    (11, 12, 'Director'),
    (11, 13, 'Director')
;
```
