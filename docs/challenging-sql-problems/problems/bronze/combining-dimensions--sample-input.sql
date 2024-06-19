```sql
with

dim_employee_demographics(employee_id, valid_from, valid_until, date_of_birth, gender, ethnicity) as (
    values
        (1, '2021-07-12', '9999-12-31', '1995-02-24', 'Female', 'White'),
        (2, '2023-12-07', '9999-12-31', '1999-12-12', 'Male',   'Asian')
),

dim_employee_career(employee_id, valid_from, valid_until, job_title, salary) as (
    values
        (1, '2021-07-12', '2023-02-18', 'Student',      0.00),
        (1, '2023-02-19', '9999-12-31', 'Pianist',   2000.00),
        (2, '2023-12-08', '9999-12-31', 'Paramedic', 4000.00)
),

dim_employee_contact(employee_id, valid_from, valid_until, email, phone) as (
    values
        (1, '2021-07-12', '9999-12-31', 'abcde@gmail.com',    '123-456-789'),
        (2, '2023-12-08', '2023-12-31', null,                 '01234 567890'),
        (2, '2024-01-01', '9999-12-31', 'something@mail.net', '0300 123 456')
)
```
