```sql
create table dim_employee_demographics (
    employee_id   int,
    valid_from    date,
    valid_until   date,
    date_of_birth date,
    gender        varchar,
    ethnicity     varchar,
    primary key (employee_id, valid_from)
);
insert into dim_employee_demographics
values
    (1, '2021-06-13', '2022-06-08', '2004-02-18', 'Female',      'Malaysian'),
    (2, '2021-10-19', '9999-12-31', '1963-12-12', 'Female',      'Navajo'),
    (3, '2022-01-29', '9999-12-31', '2000-10-17', 'Genderqueer', 'White'),
    (4, '2022-04-28', '2024-03-12', '1987-12-13', 'Male',        'Black'),
    (1, '2022-06-09', '9999-12-31', '2004-02-18', 'Non-binary',  'Malaysian'),
    (5, '2022-08-31', '9999-12-31', '1999-09-10', 'Female',      'Asian'),
    (4, '2024-03-13', '9999-12-31', '1987-12-13', 'Female',      'Black')
;


create table dim_employee_career (
    employee_id int,
    valid_from  date,
    valid_until date,
    job_title   varchar,
    salary      decimal(10, 2),
    primary key (employee_id, valid_from)
);
insert into dim_employee_career
values
    (1, '2021-06-13', '2023-05-27', 'Teacher',             5000.00),
    (1, '2023-05-28', '9999-12-31', 'Teacher',             6000.00),
    (2, '2021-10-19', '2023-11-26', 'Data Analyst',        4000.00),
    (2, '2023-11-27', '2024-03-01', 'Data Analyst',        6500.00),
    (2, '2024-03-02', '9999-12-31', 'Engineering Manager', 7000.00),
    (3, '2022-01-29', '2023-04-02', 'Software Engineer',   6000.00),
    (3, '2023-04-03', '9999-12-31', 'Software Engineer',   8000.00),
    (4, '2022-06-12', '9999-12-31', 'Founder',                null)
;


create table dim_employee_contact (
    employee_id int,
    valid_from  date,
    valid_until date,
    email       varchar,
    phone       varchar,
    primary key (employee_id, valid_from)
);
insert into dim_employee_contact
values
    (1, '2021-06-13', '2024-01-29', 'c.perot0@gmail.com',        null),
    (1, '2024-01-30', '9999-12-31', 'c.perot0@gmail.com',        '1986474151'),
    (2, '2021-10-19', '2024-04-04', null,                        null),
    (2, '2024-04-05', '9999-12-31', 'hpicard1@bing.com',         null),
    (4, '2022-06-12', '2022-12-01', 'tbayford3@hotmail.co.uk',   '01246 209863'),
    (4, '2022-12-02', '2023-11-11', 'tbayford3@hotmail.co.uk',   '01752 492269'),
    (4, '2023-11-12', '9999-12-31', 'tmacalinden@hotmail.co.uk', '01270 530950'),
    (5, '2023-02-17', '9999-12-31', null,                        null)
;
```
