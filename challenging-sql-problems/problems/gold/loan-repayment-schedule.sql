```sql
create table loans (
    loan_id       integer primary key,
    loan_value    decimal(10, 2) not null,
    interest_rate decimal(5, 4) not null,
    repayments    integer not null,
    start_date    date not null
);
insert into loans
values
    (1,  80000.00, 0.020,  6, '2024-01-01'),
    (2,  75000.00, 0.015, 12, '2024-01-02'),
    (3, 100000.00, 0.010, 24, '2024-01-03')
;
```
