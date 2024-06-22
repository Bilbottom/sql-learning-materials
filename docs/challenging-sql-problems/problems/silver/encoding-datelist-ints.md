# Encoding datelist ints 🔐

> [!SUCCESS] Scenario
>
> Inspired by the modelling approach used by the social media platform from the [customer churn](../bronze/customer-churn.md)/[decoding datelist ints](decoding-datelist-ints.md) problems, the company from the [suspicious login activity](../bronze/suspicious-login-activity.md)/[bannable login activity](bannable-login-activity.md) problems want to implement the "datelist integer" for their users' login history.
>
> This company has also given us more information about how their system works: logins expire after 24 hours, and only _manual_ user logouts are recorded in the events table.
>
> This means that:
>
> - A consecutive login within 24 hours (inclusive) of a previous login keeps the user logged in.
> - A logout event when the user is already logged out does nothing; it can be ignored.

> [!QUESTION]
>
> Encode the login history for each user into a datelist integer, where a day is flagged as `1` if the user was logged in at any point on that day, `0` otherwise.
>
> The encoding should be relative to the day of the latest event in the table.
>
> The output should have a single row per user with the columns:
>
> - `user_id`
> - `last_update` as the date of the latest event (the date that the encoding is relative to)
> - `activity_history` as the datelist integer
>
> Order the output by `user_id`.

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/bronze/suspicious-login-activity.sql"
</details>

The solution can be found at:

- [encoding-datelist-ints.md](../../solutions/silver/encoding-datelist-ints.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample input**
>
> | event_id | user_id | event_datetime      | event_type |
> |---------:|--------:|:--------------------|:-----------|
> |        1 |       1 | 2024-01-01 01:03:00 | login      |
> |        2 |       1 | 2024-01-03 01:02:00 | login      |
> |        3 |       1 | 2024-01-04 01:01:00 | login      |
> |        4 |       1 | 2024-01-05 01:00:00 | logout     |
> |        5 |       1 | 2024-01-06 01:05:00 | logout     |
> |        6 |       1 | 2024-01-06 01:06:00 | logout     |
> |        7 |       2 | 2024-01-07 01:07:00 | login      |
> |        8 |       2 | 2024-01-08 01:08:00 | login      |
> |        9 |       2 | 2024-01-09 01:09:00 | login      |
> |       10 |       2 | 2024-01-09 01:10:00 | logout     |
> |       11 |       2 | 2024-01-10 01:11:00 | logout     |
> |       12 |       2 | 2024-01-11 01:12:00 | logout     |
>
--8<-- "docs/challenging-sql-problems/problems/silver/encoding-datelist-ints--sample-input.sql"

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> | user_id | last_update | activity_history |
> |--------:|:------------|-----------------:|
> |       1 | 2024-01-09  |              496 |
> |       2 | 2024-01-09  |                7 |
>
--8<-- "docs/challenging-sql-problems/problems/silver/encoding-datelist-ints--sample-output.sql"

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> First construct a table with one row per day per user, and a column which flags if the user was logged in at any point on that day.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> Multiply the flag column by a power of 2 to get the value component for that day, then sum them up to get the datelist integer.
>
> Note that the power of 2 should be the number of days between the current row's day and the latest event's day.
