---
hide:
  - tags
tags:
  - bitshift
---

# Updating datelist ints 📶

> [!SUCCESS] Scenario
>
> You're working on a data pipeline that processes batches of data on a daily basis.
>
> The batch data contains login activity for users, and the pipeline's target table is a cumulative table that tracks the user activity over time in a datelist int.

> [!QUESTION]
>
> The datelist int tracks whether the user has logged in at least once on a given day.
>
> Write a `SELECT` query which produces the updated target table by adding the login activity from the latest batch data.
>
> The output should have the same columns as the target table:
>
> - `...`
>
> Order the output by `...`.

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/engineering/updating-datelist-ints.sql"
</details>

The solution can be found at:

- [updating-datelist-ints.md](../../solutions/engineering/updating-datelist-ints.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample input**
>
> **Latest Batch**
>
> **Target Table**
>
--8<-- "docs/challenging-sql-problems/problems/engineering/updating-datelist-ints--sample-input.sql"

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
--8<-- "docs/challenging-sql-problems/problems/engineering/updating-datelist-ints--sample-output.sql"

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
>

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
>
