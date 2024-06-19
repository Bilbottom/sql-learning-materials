```sql
solution(employee_id, valid_from, valid_until, date_of_birth, gender, ethnicity, job_title, salary, email, phone) as (
    values
        (1, '2021-06-13', '2022-06-08', '2004-02-18', 'Female',      'Malaysian', 'Teacher',             5000.00, 'c.perot0@gmail.com',        null),
        (1, '2022-06-09', '2023-05-27', '2004-02-18', 'Non-binary',  'Malaysian', 'Teacher',             5000.00, 'c.perot0@gmail.com',        null),
        (1, '2023-05-28', '2024-01-29', '2004-02-18', 'Non-binary',  'Malaysian', 'Teacher',             6000.00, 'c.perot0@gmail.com',        null),
        (1, '2024-01-30', '9999-12-31', '2004-02-18', 'Non-binary',  'Malaysian', 'Teacher',             6000.00, 'c.perot0@gmail.com',        '1986474151'),
        (2, '2021-10-19', '2023-11-26', '1963-12-12', 'Female',      'Navajo',    'Data Analyst',        4000.00, null,                        null),
        (2, '2023-11-27', '2024-03-01', '1963-12-12', 'Female',      'Navajo',    'Data Analyst',        6500.00, null,                        null),
        (2, '2024-03-02', '2024-04-04', '1963-12-12', 'Female',      'Navajo',    'Engineering Manager', 7000.00, null,                        null),
        (2, '2024-04-05', '9999-12-31', '1963-12-12', 'Female',      'Navajo',    'Engineering Manager', 7000.00, 'hpicard1@bing.com',         null),
        (3, '2022-01-29', '2023-04-02', '2000-10-17', 'Genderqueer', 'White',     'Software Engineer',   6000.00, null,                        null),
        (3, '2023-04-03', '9999-12-31', '2000-10-17', 'Genderqueer', 'White',     'Software Engineer',   8000.00, null,                        null),
        (4, '2022-04-28', '2022-06-11', '1987-12-13', 'Male',        'Black',     null,                     null, null,                        null),
        (4, '2022-06-12', '2022-12-01', '1987-12-13', 'Male',        'Black',     'Founder',                null, 'tbayford3@hotmail.co.uk',   '01246 209863'),
        (4, '2022-12-02', '2023-11-11', '1987-12-13', 'Male',        'Black',     'Founder',                null, 'tbayford3@hotmail.co.uk',   '01752 492269'),
        (4, '2023-11-12', '2024-03-12', '1987-12-13', 'Male',        'Black',     'Founder',                null, 'tmacalinden@hotmail.co.uk', '01270 530950'),
        (4, '2024-03-13', '9999-12-31', '1987-12-13', 'Female',      'Black',     'Founder',                null, 'tmacalinden@hotmail.co.uk', '01270 530950'),
        (5, '2022-08-31', '2023-02-16', '1999-09-10', 'Female',      'Asian',     null,                     null, null,                        null),
        (5, '2023-02-17', '9999-12-31', '1999-09-10', 'Female',      'Asian',     null,                     null, null,                        null)
)
```
