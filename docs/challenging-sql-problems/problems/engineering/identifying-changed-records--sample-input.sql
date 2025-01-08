```sql
with

customers_raw(customer_id, date_of_birth, gender, ethnicity, email, phone, snapshot_ts) as (
    values
        (1, '2004-02-18'::date, 'Non-binary',  'Malaysian', 'c.perot0@gmail.com',      '1986474151',   '2025-01-02 23:59:59'::timestamp),
        (3, '2000-10-17'::date, 'Genderqueer', 'White',     null,                      null,           '2025-01-02 23:59:59'::timestamp),
        (4, '1987-12-13'::date, 'Female',      'Black',     'tbayford3@hotmail.co.uk', '01752 492269', '2025-01-02 23:59:59'::timestamp),
        (5, '1999-09-10'::date, 'Female',      'Asian',     null,                      null,           '2025-01-02 23:59:59'::timestamp)
),

customers(customer_id, date_of_birth, gender, ethnicity, email, phone, last_update_ts, deleted_flag) as (
    values
        (0, '1960-01-01'::date, 'Unknown',     'Unknown',   null,                      null,           '2024-12-01 00:00:00'::timestamp, true),
        (1, '2004-02-18'::date, 'Female',      'Malaysian', 'c.perot0@gmail.com',      null,           '2024-12-30 23:59:59'::timestamp, false),
        (2, '1963-12-12'::date, 'Female',      'Navajo',    null,                      null,           '2024-12-31 23:59:59'::timestamp, false),
        (3, '2000-10-17'::date, 'Genderqueer', 'White',     null,                      null,           '2024-12-31 23:59:59'::timestamp, false),
        (4, '1987-12-13'::date, 'Male',        'Black',     'tbayford3@hotmail.co.uk', '01246 209863', '2025-01-01 23:59:59'::timestamp, false)
)
```
