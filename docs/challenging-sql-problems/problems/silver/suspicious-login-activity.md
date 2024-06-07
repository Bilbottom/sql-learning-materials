# Suspicious login activity 🤔

> [!QUESTION]
>
> The `event` table captures `login`, `logout`, and `login failed` events for users.
>
> Consecutive failed login attempts are considered suspicious once they reach a certain threshold.
>
> For the events below, identify the users who have `login failed` events at least five times in a row.
>
> Keep only the user ID and their _greatest_ number of consecutive failed login attempts.
>
> The output should have the columns:
>
> - `user_id`
> - `consecutive_failures` as the greatest number of consecutive failed login attempts for the user
>
> Order by `user_id`.

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/silver/suspicious-login-activity.sql"
</details>

The solution can be found at:

- [suspicious-login-activity.md](../../solutions/silver/suspicious-login-activity.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> | user_id | consecutive_failures |
> |--------:|---------------------:|
> |       1 |                    5 |
> |     ... |                  ... |

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> This is a typical "gaps and islands" problem.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> Use the difference between two `ROW_NUMBER()` functions to create a group for each user and event type. Partition on `user_id` for one and partition on both `user_id` and `event_type` for the other, ordering both by `event_id`.
