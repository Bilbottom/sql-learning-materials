```sql
with axis as (
        select employee_id, valid_from
        from dim_employee_demographics
    union
        select employee_id, valid_from
        from dim_employee_career
    union
        select employee_id, valid_from
        from dim_employee_contact
)

select
    employee_id,
    valid_from,
    lead(valid_from - 1, 1, '9999-12-31') over (
        partition by employee_id
        order by valid_from
    ) as valid_until,

    dim_employee_demographics.date_of_birth,
    dim_employee_demographics.gender,
    dim_employee_demographics.ethnicity,

    dim_employee_career.job_title,
    dim_employee_career.salary,

    dim_employee_contact.email,
    dim_employee_contact.phone
from axis
    asof left join dim_employee_demographics
        using (employee_id, valid_from)
    asof left join dim_employee_career
        using (employee_id, valid_from)
    asof left join dim_employee_contact
        using (employee_id, valid_from)
order by
    employee_id,
    valid_from
```
