---
hide:
  - tags
tags:
  - hash diff
  - custom axis
---

# Updating SCD2 dimension 🧮

> [!SUCCESS] Scenario
>
> You're working on a data pipeline that processes batches of data on a daily basis.
>
> The batch data contains only the latest information for existing records, and this particular pipeline pushes this data into a [slowly changing dimension type 2 (SCD2)](https://en.wikipedia.org/wiki/Slowly_changing_dimension#Type_2:_add_new_row) table.

> [!QUESTION]
>
> Write a `SELECT` query which produces the updated target table by:
>
> - Adding a row for the new/changed records in the latest batch.
> - Updating the `valid_until` column for the existing records that have changed in the latest batch.
>   - Note: existing records that are no longer in the latest batch should count as changed (with no new row added).
>
> The output should have the same columns as the target table:
>
> - `...`
>
> Order the output by `...`.

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/engineering/updating-scd2-dimension.sql"
</details>

The solution can be found at:

- [updating-scd2-dimension.md](../../solutions/engineering/updating-scd2-dimension.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample input**
>
> **Latest Batch**
>
> **Target Table**
>
--8<-- "docs/challenging-sql-problems/problems/engineering/updating-scd2-dimension--sample-input.sql"

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
--8<-- "docs/challenging-sql-problems/problems/engineering/updating-scd2-dimension--sample-output.sql"

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
>

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
>
