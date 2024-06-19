# Customer churn 🔄

> [!SUCCESS] Scenario
>
> A social media platform wants to track customer churn by identifying users who have not been active recently.
>
> For performance reasons, the platform encodes the recent user activity in a "datelist int"; more details on this encoding can be found at:
>
> - [https://www.linkedin.com/pulse/datelist-int-efficient-data-structure-user-growth-max-sung/](https://www.linkedin.com/pulse/datelist-int-efficient-data-structure-user-growth-max-sung/)

> [!QUESTION]
>
> Given the user history below, identify the users who have _churned_: who were inactive for the last 7 days, but active in the 7 days before that.
>
> Note that the `last_update` column will always have the same date for all users.
>
> The output should have one row for each churned user, with the columns:
>
> - `user_id`
> - `days_active_last_week` as the number of days the user was active in the last week
>
> Order the output by `user_id`.

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/bronze/customer-churn.sql"
</details>

The solution can be found at:

- [customer-churn.md](../../solutions/bronze/customer-churn.md)

A worked example is provided below to help illustrate the datelist int encoding.

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
> | user_id | days_active_last_week |
> |--------:|----------------------:|
> |       2 |                     3 |
>
--8<-- "docs/challenging-sql-problems/problems/bronze/customer-churn--sample-output.sql"

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> Use "bitwise and" operations with powers of 2 to determine the user activity for some dates.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> Use the "bitwise shift right" operation to shift the activity history to the right by 7 days to make summarising the previous week easier.

<!-- prettier-ignore -->
>? TIP: **Hint 3**
>
> Use the `bit_count` function (or equivalent) to count the number of bits (days) in the given range.

---

### Worked example

To help understand the datelist int encoding, consider the following users:

| user_id | last_update | activity_history |
| ------: | :---------- | ---------------: |
|       1 | 2024-03-01  |               81 |
|       2 | 2024-03-01  |             2688 |
|       3 | 2024-03-01  |            13144 |

We'll walk through each user to understand which days they were active.

#### User 1

The `activity_history` for user 1 is `81`, which in binary is `1010001`.

The rightmost bit represents the most recent day, which is the `last_update` date: `2024-03-01`.

Since the rightmost bit is `1`, the user was active on that day.

We can apply the same logic to the other bits:

```
1 0 1 0 0 0 1
| | | | | | |
| | | | | | └-- 2024-03-01 (active)
| | | | | └---- 2024-02-29 (inactive)
| | | | └------ 2024-02-28 (inactive)
| | | └-------- 2024-02-27 (inactive)
| | └---------- 2024-02-26 (active)
| └------------ 2024-02-25 (inactive)
└-------------- 2024-02-24 (active)
```

Since there are no more bits on the left, we can assume that the user was inactive on those days.

This user is therefore not a churned user since they were active at least once in the last 7 days.

#### User 2

The `activity_history` for user 2 is `2688`, which in binary is `101010000000`.

We can expand the binary representation to understand the activity:

```
1 0 1 0 1 0 0 0 0 0 0 0
| | | | | | | | | | | |
| | | | | | | | | | | └-- 2024-03-01 (inactive)
| | | | | | | | | | └---- 2024-02-29 (inactive)
| | | | | | | | | └------ 2024-02-28 (inactive)
| | | | | | | | └-------- 2024-02-27 (inactive)
| | | | | | | └---------- 2024-02-26 (inactive)
| | | | | | └------------ 2024-02-25 (inactive)
| | | | | └-------------- 2024-02-24 (inactive)
| | | | └---------------- 2024-02-23 (active)
| | | └------------------ 2024-02-22 (inactive)
| | └-------------------- 2024-02-21 (active)
| └---------------------- 2024-02-20 (inactive)
└------------------------ 2024-02-19 (active)
```

User 2 _has_ churned since they were not active in the last 7 days (between `2024-02-24` and `2024-03-01`) but were active at least once in the 7 days before that.

#### User 3

The `activity_history` for user 3 is `13144`, which in binary is `11001101011000`.

Again, we can expand the binary representation to understand the activity:

```
1 1 0 0 1 1 0 1 0 1 1 0 0 0
| | | | | | | | | | | | | |
| | | | | | | | | | | | | └-- 2024-03-01 (inactive)
| | | | | | | | | | | | └---- 2024-02-29 (inactive)
| | | | | | | | | | | └------ 2024-02-28 (inactive)
| | | | | | | | | | └-------- 2024-02-27 (active)
| | | | | | | | | └---------- 2024-02-26 (active)
| | | | | | | | └------------ 2024-02-25 (inactive)
| | | | | | | └-------------- 2024-02-24 (active)
| | | | | | └---------------- 2024-02-23 (inactive)
| | | | | └------------------ 2024-02-22 (active)
| | | | └-------------------- 2024-02-21 (active)
| | | └---------------------- 2024-02-20 (inactive)
| | └------------------------ 2024-02-19 (inactive)
| └-------------------------- 2024-02-18 (active)
└---------------------------- 2024-02-17 (active)
```

Like user 1, user 3 is not a churned user since they were active at least once in the last 7 days.
