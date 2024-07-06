# Loan repayment schedule 💰

> [!SUCCESS] Scenario
>
> A bank is trying to generate statements and forecasts for their loan customers.
>
> They need to know the repayment schedules for each loan so they can accurately communicate to their customers, as well as track the repayments and forecast their cash flow.

> [!QUESTION]
>
> For the loan details below, generate the loan repayment schedules for the loans.
>
> The output should have a row per loan per repayment, with the columns:
>
> - `loan_id`
> - `repayment_number` as the repayment number
> - `repayment_date` as the date of the repayment
> - `interest` as the interest component of the repayment
> - `principal` as the principal component of the repayment
> - `total` as the total value of the repayment
> - `balance` as the outstanding balance _after_ the repayment
>
> Order the output by `loan_id` and `repayment_number`.

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/gold/loan-repayment-schedule.sql"
</details>

The loans have the following details:

- `loan_id`: The unique identifier for the loan
- `loan_value`: The total value of the loan
- `interest_rate`: The monthly interest rate
- `repayments`: The number of monthly repayments to make on the loan
- `start_date`: The date the loan was taken out

The repayments are due exactly one month after each other (no need to account for weekends or holidays), and the first repayment is due one month after the `start_date`. The `start_date` will never be on the 29th, 30th, or 31st of the month.

For each loan, the monthly repayment will be for the same amount (except the final one) which you need to calculate, or check **Hint 0** below. The monthly repayment must be rounded to two decimal places, but any rounding error should be accounted for in the final repayment so that the outstanding balance is exactly zero after the final repayment.

Each repayment, the interest is calculated and added first, and then the repayment is subtracted from the balance. The interest is calculated on the current outstanding balance and rounded to two decimal places.

A monthly repayment will be made up of two parts: the interest and the principal. The interest is calculated as described above, and the principal is the difference between the monthly repayment and the interest so is the amount that goes towards actually paying off the loan.

The solution can be found at:

- [loan-repayment-schedule.md](../../solutions/gold/loan-repayment-schedule.md)

A worked example is provided below to help illustrate the loan calculations.

---

<!-- prettier-ignore -->
>? INFO: **Sample input**
>
> | loan_id | loan_value | interest_rate | repayments | start_date |
> |--------:|-----------:|--------------:|-----------:|:-----------|
> |       1 |   10000.00 |        0.0100 |          6 | 2024-01-01 |
>
--8<-- "docs/challenging-sql-problems/problems/gold/loan-repayment-schedule--sample-input.sql"

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> | loan_id | repayment_number | repayment_date | interest | principal |   total | balance |
> |--------:|-----------------:|:---------------|---------:|----------:|--------:|--------:|
> |       1 |                1 | 2024-02-01     |   100.00 |   1625.48 | 1725.48 | 8374.52 |
> |       1 |                2 | 2024-03-01     |    83.75 |   1641.73 | 1725.48 | 6732.79 |
> |       1 |                3 | 2024-04-01     |    67.33 |   1658.15 | 1725.48 | 5074.64 |
> |       1 |                4 | 2024-05-01     |    50.75 |   1674.73 | 1725.48 | 3399.91 |
> |       1 |                5 | 2024-06-01     |    34.00 |   1691.48 | 1725.48 | 1708.43 |
> |       1 |                6 | 2024-07-01     |    17.08 |   1708.43 | 1725.51 |    0.00 |
>
--8<-- "docs/challenging-sql-problems/problems/gold/loan-repayment-schedule--sample-output.sql"

<!-- prettier-ignore -->
>? TIP: **Hint 0**
>
> The formula for calculating the monthly repayment is:
>
> - `(1 + interest_rate)` to the power of `repayments` as `amortised_rate`, then
> - `loan_value * interest_rate * amortised_rate / (amortised_rate - 1)` as `monthly_repayment`

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> Use a [recursive CTE](../../../from-excel-to-sql/advanced-concepts/recursive-ctes.md) to generate and calculate the rows for the repayment schedule.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> For the recursive CTE's anchor statement, start with a dummy row for each loan with only the loan value and the start date. Then, recursively calculate the interest, principal, and balance for each repayment in the recursive statement.

<!-- prettier-ignore -->
>? TIP: **Hint 3**
>
> Calculate the final repayment's details separately to account for any rounding errors.

---

### Worked example

To help illustrate the loan calculations, consider the loan in the **Sample input**.

A loan with these details will have a monthly repayment value of 1,725.48 (rounded to 2 decimal places).

Let's walk through a few repayments.

#### The first repayment

- The first repayment is due on 2024-02-01
- The interest is calculated on the outstanding balance of 10,000.00
- The interest is 1%, so the interest for the month is 100.00 (10,000.00 \* 0.01)
- The repayment is 1,725.48, so the outstanding balance after the repayment is 8,374.52 (10,000.00 + 100.00 - 1,725.48)
- We note that the principal component of the repayment is 1,625.48 (1,725.48 - 100.00)

#### The second repayment

- The second repayment is due on 2024-03-01
- The interest is calculated on the outstanding balance of 8,374.52
- The interest is 1%, so the interest for the month is 83.75 (8,374.52 \* 0.01)
- The repayment is 1,725.48, so the outstanding balance after the repayment is 6,732.79 (8,374.52 + 83.75 - 1,725.48)
- We note that the principal component of the repayment is 1,641.73 (1,725.48 - 83.75)

#### The third, fourth, and fifth repayments

- The interest and principal components are calculated in the same way as above
- The outstanding balance after the fifth repayment is 1,708.43

#### The final repayment

- The final repayment is due on 2024-07-01
- The interest is calculated on the outstanding balance of 1,708.43
- The interest is 1%, so the interest for the month is 17.08 (1,708.43 \* 0.01)
- Since this is the final repayment and we want to account for any rounding errors, the repayment is the outstanding balance plus the interest: 1,725.51 (1,708.43 + 17.08)

Therefore, the repayment schedule for this loan would look like:

| loan_id | repayment_number | repayment_date | interest | principal |   total | balance |
| ------: | ---------------: | :------------- | -------: | --------: | ------: | ------: |
|       1 |                1 | 2024-02-01     |   100.00 |   1625.48 | 1725.48 | 8374.52 |
|       1 |                2 | 2024-03-01     |    83.75 |   1641.73 | 1725.48 | 6732.79 |
|       1 |                3 | 2024-04-01     |    67.33 |   1658.15 | 1725.48 | 5074.64 |
|       1 |                4 | 2024-05-01     |    50.75 |   1674.73 | 1725.48 | 3399.91 |
|       1 |                5 | 2024-06-01     |    34.00 |   1691.48 | 1725.48 | 1708.43 |
|       1 |                6 | 2024-07-01     |    17.08 |   1708.43 | 1725.51 |    0.00 |
