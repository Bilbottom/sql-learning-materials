---
hide:
  - tags
tags:
  - recursive CTE
  - bitshift
---

# Decoding datelist ints 🔓

> [!SUCCESS] Scenario
>
> The same social media platform from the [customer churn](../bronze/customer-churn.md) problem wants to view their user activity in a more human-readable format.

> [!QUESTION]
>
> Explode the user activity into a table with one row per day and a column for each user, showing whether they were active.
>
> The number of rows to show in the output should be the number of days in the `activity_history` column for the user with the most days.
>
> Just like in the [customer churn](../bronze/customer-churn.md) problem, the `last_update` column will always have the same date for all users.
>
> The output should have a single row per day with the columns:
>
> - `active_date` as the date of the activity, starting from the `last_update` date
> - `user_X` which is `1` if `user_id = X` was active on that day, `0` otherwise
>
> ...where `X` is each `user_id` in the activity table.
>
> Order the output by `active_date`.

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/bronze/customer-churn.sql"
</details>

The solution can be found at:

- [decoding-datelist-ints.md](../../solutions/silver/decoding-datelist-ints.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample input**
>
> | user_id | last_update | activity_history |
> |--------:|:------------|-----------------:|
> |       1 | 2024-03-01  |               81 |
> |       2 | 2024-03-01  |             2688 |
> |       3 | 2024-03-01  |            13144 |
>
--8<-- "docs/challenging-sql-problems/problems/bronze/customer-churn--sample-input.sql"

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> | active_date | user_1 | user_2 | user_3 |
> |:------------|-------:|-------:|-------:|
> | 2024-02-17  |      0 |      0 |      1 |
> | 2024-02-18  |      0 |      0 |      1 |
> | 2024-02-19  |      0 |      1 |      0 |
> | 2024-02-20  |      0 |      0 |      0 |
> | 2024-02-21  |      0 |      1 |      1 |
> | 2024-02-22  |      0 |      0 |      1 |
> | 2024-02-23  |      0 |      1 |      0 |
> | 2024-02-24  |      1 |      0 |      1 |
> | 2024-02-25  |      0 |      0 |      0 |
> | 2024-02-26  |      1 |      0 |      1 |
> | 2024-02-27  |      0 |      0 |      1 |
> | 2024-02-28  |      0 |      0 |      0 |
> | 2024-02-29  |      0 |      0 |      0 |
> | 2024-03-01  |      1 |      0 |      0 |
>
--8<-- "docs/challenging-sql-problems/problems/silver/decoding-datelist-ints--sample-output.sql"

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> Use a [recursive CTE](../../../from-excel-to-sql/advanced-concepts/recursive-ctes.md) to construct a table with the dates.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> Use the "bitwise and" operation to determine if a user was active on a given day.
