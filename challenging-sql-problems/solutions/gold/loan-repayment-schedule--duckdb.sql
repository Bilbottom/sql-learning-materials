```sql
with recursive

monthly_repayment_value as (
    select
        loan_id,
        power(1 + interest_rate, repayments) as amortised_rate,
        round(
            (loan_value * interest_rate * amortised_rate) / (amortised_rate - 1),
            2
        ) as monthly_repayment
    from loans
),

schedule as (
        select
            /* loan details */
            loans.loan_id,
            loans.interest_rate,
            loans.repayments,
            monthly_repayment_value.monthly_repayment,

            /* repayment details */
            0 as repayment_number,
            loans.start_date as repayment_date,
            0::decimal(10, 2) as starting_balance,
            0::decimal(10, 2) as interest,
            0::decimal(10, 2) as principal,
            0::decimal(10, 2) as total,
            loans.loan_value as remaining_balance
        from loans
            inner join monthly_repayment_value
                using (loan_id)
    union all
        select
            loan_id,
            interest_rate,
            repayments,
            monthly_repayment,

            repayment_number + 1,
            repayment_date + interval '1 month',
            remaining_balance,
            round(remaining_balance * interest_rate, 2) as interest_,
            monthly_repayment - interest_ as principal_,
            monthly_repayment,
            remaining_balance - principal_
        from schedule
        where repayment_number < repayments
)

select
    loan_id,
    repayment_number,
    repayment_date,
    interest,

    /* adjust the final repayment with the rounding error */
    if(repayment_number = repayments, starting_balance, principal) as principal,
    if(repayment_number = repayments, starting_balance + interest, total) as total,
    if(repayment_number = repayments, 0, remaining_balance) as balance
from schedule
where repayment_number > 0
order by
    loan_id,
    repayment_number
```
