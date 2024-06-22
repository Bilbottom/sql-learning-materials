```sql
solution(employee_id, valid_from, valid_until, date_of_birth, gender, ethnicity, job_title, salary, email, phone) as (
    values
        (1, '2021-07-12'::date, '2023-02-18'::date, '1995-02-24'::date, 'Female', 'Black', 'Student',      0.00, 'abcde@gmail.com',    '123-456-789'),
        (1, '2023-02-19'::date, '9999-12-31'::date, '1995-02-24'::date, 'Female', 'Black', 'Pianist',   2000.00, 'abcde@gmail.com',    '123-456-789'),
        (2, '2023-12-07'::date, '2023-12-07'::date, '1999-12-12'::date, 'Male',   'Asian', null,           null, null,                 null),
        (2, '2023-12-08'::date, '2023-12-31'::date, '1999-12-12'::date, 'Male',   'Asian', 'Paramedic', 4000.00, null,                 '01234 567890'),
        (2, '2024-01-01'::date, '9999-12-31'::date, '1999-12-12'::date, 'Male',   'Asian', 'Paramedic', 4000.00, 'something@mail.net', '0300 123 456')
)
```
