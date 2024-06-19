```sql
solution(employee_id, valid_from, valid_until, date_of_birth, gender, ethnicity, job_title, salary, email, phone) as (
    values
        (1, '2021-07-12', '2023-02-18', '1995-02-24', 'Female', 'Black', 'Student',      0.00, 'abcde@gmail.com',    '123-456-789'),
        (1, '2023-02-19', '9999-12-31', '1995-02-24', 'Female', 'Black', 'Pianist',   2000.00, 'abcde@gmail.com',    '123-456-789'),
        (2, '2023-12-07', '2023-12-07', '1999-12-12', 'Male',   'Asian', null,           null, null,                 null),
        (2, '2023-12-08', '2023-12-31', '1999-12-12', 'Male',   'Asian', 'Paramedic', 4000.00, null,                 '01234 567890'),
        (2, '2024-01-01', '9999-12-31', '1999-12-12', 'Male',   'Asian', 'Paramedic', 4000.00, 'something@mail.net', '0300 123 456')
)
```
