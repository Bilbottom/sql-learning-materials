```sql
with

dim_employee_demographics(employee_id, valid_from, valid_until, date_of_birth, gender, ethnicity) as (
    values
        (1, '2021-07-12'::date, '9999-12-31'::date, '1995-02-24'::date, 'Female', 'White'),
        (2, '2023-12-07'::date, '9999-12-31'::date, '1999-12-12'::date, 'Male',   'Asian')
),

dim_employee_career(employee_id, valid_from, valid_until, job_title, salary) as (
    values
        (1, '2021-07-12'::date, '2023-02-18'::date, 'Student',      0.00),
        (1, '2023-02-19'::date, '9999-12-31'::date, 'Pianist',   2000.00),
        (2, '2023-12-08'::date, '9999-12-31'::date, 'Paramedic', 4000.00)
),

dim_employee_contact(employee_id, valid_from, valid_until, email, phone) as (
    values
        (1, '2021-07-12'::date, '9999-12-31'::date, 'abcde@gmail.com',    '123-456-789'),
        (2, '2023-12-08'::date, '2023-12-31'::date, null,                 '01234 567890'),
        (2, '2024-01-01'::date, '9999-12-31'::date, 'something@mail.net', '0300 123 456')
)
```
