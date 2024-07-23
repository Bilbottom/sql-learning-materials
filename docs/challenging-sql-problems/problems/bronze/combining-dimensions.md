---
hide:
  - tags
tags:
  - asof join
  - custom axis
---

# Combining dimensions 🔗

> [!SUCCESS] Scenario
>
> A human resources department has several dimension tables with information about their employees.
>
> For reporting purposes, they need to combine these dimensions into a single dimension table which shows all the information about each employee.

> [!QUESTION]
>
> Write a query which combines the three dimension tables below into a single dimension table.
>
> The output should have the columns from the three tables combined:
>
> - `employee_id`
> - `valid_from`
> - `valid_until`
> - `date_of_birth`
> - `gender`
> - `ethnicity`
> - `job_title`
> - `salary`
> - `email`
> - `phone`
>
> The number of rows in the output depends on the number of changes that need to be accounted for, and the `valid_from` and `valid_until` columns should be recalculated as necessary to account for these changes.
>
> Order the output by `employee_id` and `valid_from`.

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/bronze/combining-dimensions.sql"
</details>

The "dimensions" in this context are [Slowly Changing Dimensions](https://en.wikipedia.org/wiki/Slowly_changing_dimension) of [type 2](https://en.wikipedia.org/wiki/Slowly_changing_dimension#Type_2:_add_new_row) from the [Star Schema modelling framework](https://en.wikipedia.org/wiki/Star_schema).

The solution can be found at:

- [combining-dimensions.md](../../solutions/bronze/combining-dimensions.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample input**
>
> **Employee Demographics Dimension**
>
> | employee_id | valid_from | valid_until | date_of_birth | gender | ethnicity |
> |------------:|:-----------|:------------|:--------------|:-------|:----------|
> |           1 | 2021-07-12 | 9999-12-31  | 1995-02-24    | Female | Black     |
> |           2 | 2023-12-07 | 9999-12-31  | 1999-12-12    | Male   | Asian     |
>
> **Employee Career Dimension**
>
> | employee_id | valid_from | valid_until | job_title |  salary |
> |------------:|:-----------|:------------|:----------|--------:|
> |           1 | 2021-07-12 | 2023-02-18  | Student   |    0.00 |
> |           1 | 2023-02-19 | 9999-12-31  | Pianist   | 2000.00 |
> |           2 | 2023-12-08 | 9999-12-31  | Paramedic | 4000.00 |
>
> **Employee Contact Dimension**
>
> | employee_id | valid_from | valid_until | email              | phone        |
> |------------:|:-----------|:------------|:-------------------|:-------------|
> |           1 | 2021-07-12 | 9999-12-31  | abcde@gmail.com    | 123-456-789  |
> |           2 | 2023-12-08 | 2023-12-31  | _null_             | 01234 567890 |
> |           2 | 2024-01-01 | 9999-12-31  | something@mail.net | 0300 123 456 |
>
--8<-- "docs/challenging-sql-problems/problems/bronze/combining-dimensions--sample-input.sql"

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> | employee_id | valid_from | valid_until | date_of_birth | gender | ethnicity | job_title |  salary | email              | phone        |
> |------------:|:-----------|:------------|:--------------|:-------|:----------|:----------|--------:|:-------------------|:-------------|
> |           1 | 2021-07-12 | 2023-02-18  | 1995-02-24    | Female | Black     | Student   |    0.00 | abcde@gmail.com    | 123-456-789  |
> |           1 | 2023-02-19 | 9999-12-31  | 1995-02-24    | Female | Black     | Pianist   | 2000.00 | abcde@gmail.com    | 123-456-789  |
> |           2 | 2023-12-07 | 2023-12-07  | 1999-12-12    | Male   | Asian     | null      |  _null_ | _null_             | _null_       |
> |           2 | 2023-12-08 | 2023-12-31  | 1999-12-12    | Male   | Asian     | Paramedic | 4000.00 | _null_             | 01234 567890 |
> |           2 | 2024-01-01 | 9999-12-31  | 1999-12-12    | Male   | Asian     | Paramedic | 4000.00 | something@mail.net | 0300 123 456 |
>
--8<-- "docs/challenging-sql-problems/problems/bronze/combining-dimensions--sample-output.sql"

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> The `valid_from` values in the output will be each of the distinct `valid_from` values from the three tables for the given employee, so start by constructing an "axis" which is the distinct combination of all `employee_id` and `valid_from` values across the three tables.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> For databases that support it, use [an `ASOF` join](../../../everything-about-joins/syntax/timestamp-joins.md) to add the latest information from each dimension to the "axis" for each `employee_id` and `valid_from` combination.
>
> For databases that don't support `ASOF` joins, calculate the `valid_until` values for the `valid_from` values in the "axis" and then join the dimension tables to the axis by where the axis `valid_from`-`valid_until` range in contained within the dimension `valid_from`-`valid_until` range.
