# Bannable login activity ❌

> [!SUCCESS] Scenario
>
> The same company from the [suspicious login activity](../bronze/suspicious-login-activity.md) question have decided to take a more proactive approach to their security.
>
> If a user has at least 3 consecutive `login failed` attempts in a day for 3 consecutive days, they are automatically banned.
>
> They may have other events between the _consecutive_ failed login attempts.

> [!QUESTION]
>
> Determine the users who should be banned based on the above criteria.
>
> The output should have a row for each user who meets this criterion, with the columns:
>
> - `user_id`
> - `ban_date` as the date of the third day of consecutive failed login attempts
>
> Order the output by `user_id`.

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/bronze/suspicious-login-activity.sql"
</details>

The solution can be found at:

- [bannable-login-activity.md](../../solutions/silver/bannable-login-activity.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample input**
>
> | event_id | user_id | event_datetime      | event_type   |
> |---------:|--------:|:--------------------|:-------------|
> |        1 |       1 | 2024-01-01 03:00:00 | login failed |
> |        2 |       1 | 2024-01-01 03:01:00 | login failed |
> |        3 |       1 | 2024-01-01 03:02:00 | login failed |
> |        4 |       1 | 2024-01-01 11:00:00 | login        |
> |        5 |       1 | 2024-01-01 12:00:00 | logout       |
> |        6 |       2 | 2024-01-01 15:00:00 | login        |
> |        7 |       2 | 2024-01-01 18:00:00 | logout       |
> |        8 |       1 | 2024-01-02 03:00:00 | login failed |
> |        9 |       1 | 2024-01-02 03:01:00 | login failed |
> |       10 |       1 | 2024-01-02 03:02:00 | login failed |
> |       11 |       1 | 2024-01-03 03:00:00 | login failed |
> |       12 |       1 | 2024-01-03 03:01:00 | login failed |
> |       13 |       1 | 2024-01-03 03:02:00 | login failed |
>
--8<-- "docs/challenging-sql-problems/problems/silver/bannable-login-activity--sample-input.sql"

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> | user_id | ban_date   |
> |--------:|:-----------|
> |       1 | 2024-01-03 |
>
--8<-- "docs/challenging-sql-problems/problems/silver/bannable-login-activity--sample-output.sql"

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> Like [Suspicious login activity](../bronze/suspicious-login-activity.md), use [window functions](../../../from-excel-to-sql/main-concepts/window-functions.md) to determine the sets of consecutive events.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> For databases that support it, use `RANGE INTERVAL '3 DAYS' PRECEDING` in a window function to summarise the previous three days.
>
> For databases that don't support it, use whatever method you prefer to determine the consecutive days -- for example:
>
> - Construct a complete date axis to use `ROWS BETWEEN 2 PRECEDING AND CURRENT ROW` to summarise the previous three days.
> - Use an inner join to the same table to summarise events from the previous three days.
> - Use a correlated subquery to summarise events from the previous three days.
