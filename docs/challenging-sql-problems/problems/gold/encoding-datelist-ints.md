# Encoding datelist ints 🔐

> [!SUCCESS] Scenario
>
> Inspired by the modelling approach used by the social media platform from the [customer churn](../bronze/customer-churn.md)/[decoding datelist ints](../silver/decoding-datelist-ints.md) problems, the company from the [suspicious login activity](../bronze/suspicious-login-activity.md)/[bannable login activity](../silver/bannable-login-activity.md) problems want to implement the "datelist integer" for their users' login history.
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

- [encoding-datelist-ints.md](../../solutions/gold/encoding-datelist-ints.md)

A worked example is provided below to help illustrate the encoding.

---

<!-- prettier-ignore -->
>? INFO: **Sample input**
>
> | event_id | user_id | event_datetime      | event_type |
> |---------:|--------:|:--------------------|:-----------|
> |        1 |       1 | 2024-01-01 01:03:00 | login      |
> |        2 |       1 | 2024-01-04 01:02:00 | login      |
> |        3 |       1 | 2024-01-05 01:01:00 | login      |
> |        4 |       1 | 2024-01-06 01:00:00 | logout     |
> |        5 |       1 | 2024-01-07 01:05:00 | logout     |
> |        6 |       1 | 2024-01-07 01:06:00 | logout     |
> |        7 |       2 | 2024-01-08 01:07:00 | login      |
> |        8 |       2 | 2024-01-09 01:08:00 | login      |
> |        9 |       2 | 2024-01-10 01:09:00 | login      |
> |       10 |       2 | 2024-01-10 01:10:00 | logout     |
> |       11 |       2 | 2024-01-11 01:11:00 | logout     |
> |       12 |       2 | 2024-01-12 01:12:00 | logout     |
>
--8<-- "docs/challenging-sql-problems/problems/gold/encoding-datelist-ints--sample-input.sql"

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> | user_id | last_update | activity_history |
> |--------:|:------------|-----------------:|
> |       1 | 2024-01-12  |             3520 |
> |       2 | 2024-01-12  |               28 |
>
--8<-- "docs/challenging-sql-problems/problems/gold/encoding-datelist-ints--sample-output.sql"

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

---

### Worked example

To help illustrate the encoding, consider the following events in the **Sample input**.

We'll walk through each of the events and how they contribute to different sessions.

1. User 1 logs in at `2024-01-01 01:03:00`, starting the first session. Their next event is a login at `2024-01-04 01:02:00` which is over 24 hours; so the first session expires at `2024-01-02 01:03:00`.
2. User 1 logs in at `2024-01-04 01:02:00`, starting the second session. Their next event is a login at `2024-01-05 01:01:00` which is under 24 hours; so the second session continues.
3. User 1 logs in at `2024-01-05 01:01:00`, continuing the second session. Their next event is a logout at `2024-01-06 01:00:00` which is under 24 hours; so the second session ends at `2024-01-06 01:00:00`.
4. User 1 logs out at `2024-01-06 01:00:00`, which we've already accounted for.
5. User 1 logs out at `2024-01-07 01:05:00`, which does nothing.
6. User 1 logs out at `2024-01-07 01:06:00`, which does nothing.
7. User 2 logs in at `2024-01-08 01:07:00`, starting the third session. Their next event is a login at `2024-01-09 01:08:00` which is under 24 hours; so the third session continues.
8. User 2 logs in at `2024-01-09 01:08:00`, continuing the third session. Their next event is a login at `2024-01-10 01:09:00` which is under 24 hours; so the third session continues.
9. User 2 logs in at `2024-01-10 01:09:00`, continuing the third session. Their next event is a logout at `2024-01-10 01:10:00` which is under 24 hours; so the third session ends at `2024-01-10 01:10:00`.
10. User 2 logs out at `2024-01-10 01:10:00`, which we've already accounted for.
11. User 2 logs out at `2024-01-11 01:11:00`, which does nothing.
12. User 2 logs out at `2024-01-12 01:12:00`, which does nothing.

This gives us the following sessions:

| user_id | login_date          | logout_date         |
| :------ | :------------------ | :------------------ |
| 1       | 2024-01-01 01:03:00 | 2024-01-02 01:03:00 |
| 1       | 2024-01-04 01:02:00 | 2024-01-06 01:00:00 |
| 2       | 2024-01-08 01:07:00 | 2024-01-09 01:07:00 |
| 2       | 2024-01-09 01:08:00 | 2024-01-10 01:08:00 |
| 2       | 2024-01-10 01:09:00 | 2024-01-10 01:10:00 |

The earliest and latest events in the `events` table are on `2024-01-01` and `2024-01-12` respectively, so the encoding is relative to the `2024-01-12`. We can plot the sessions on a timeline:

| active_date | user_1_is_active | user_2_is_active |
| :---------- | ---------------: | ---------------: |
| 2024-01-01  |                1 |                0 |
| 2024-01-02  |                1 |                0 |
| 2024-01-03  |                0 |                0 |
| 2024-01-04  |                1 |                0 |
| 2024-01-05  |                1 |                0 |
| 2024-01-06  |                1 |                0 |
| 2024-01-07  |                0 |                0 |
| 2024-01-08  |                0 |                1 |
| 2024-01-09  |                0 |                1 |
| 2024-01-10  |                0 |                1 |
| 2024-01-11  |                0 |                0 |
| 2024-01-12  |                0 |                0 |

Since the latest event is on `2024-01-12`, the encoding for `2024-01-12` uses 2<sup>0</sup>, the encoding for `2024-01-11` uses 2<sup>1</sup>, and so on. This gives us the following datelist integers:

- User 1: 2048 + 1024 + 256 + 128 + 64 = 3520
- User 2: 16 + 8 + 4 = 28
