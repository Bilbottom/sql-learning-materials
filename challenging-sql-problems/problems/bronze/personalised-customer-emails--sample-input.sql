```sql
with

customers(customer_id, full_name, first_name, last_name, email_address) as (
    values
        (1,  'Straw Hat Pirates', null,    null,      'king.luffy@strawhats.com'),
        (2,  'Monkey D Luffy',    'Luffy', 'Monkey',  null),
        (3,  'Roronoa Zoro',      'Zoro',  'Roronoa', null)
),

customer_relationships(parent_customer_id, child_customer_id, relationship) as (
    values
        (1, 2, 'Captain'),
        (1, 3, 'Swordsman')
)
```
