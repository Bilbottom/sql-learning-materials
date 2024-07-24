---
hide:
  - tags
tags:
  - hash diff
  - custom axis
---

# Updating SCD1 dimension 🧬

> [!SUCCESS] Scenario
>
> You're working on a data pipeline that processes batches of data on a daily basis.
>
> The batch data contains only the latest information for existing records, and this particular pipeline pushes this data into a [slowly changing dimension type 1 (SCD1)](https://en.wikipedia.org/wiki/Slowly_changing_dimension#Type_1:_overwrite) table.

> [!QUESTION]
>
> Write a `SELECT` query which produces the updated target table by:
>
> - Updating the columns for the existing records that have changed in the latest batch.
> - Marking the existing records that are no longer in the latest batch as `record_deleted_flag = 0`.
>
> The output should have the same columns as the target table:
>
> - `...`
>
> Order the output by `...`.

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/engineering/updating-scd1-dimension.sql"
</details>

The solution can be found at:

- [updating-scd1-dimension.md](../../solutions/engineering/updating-scd1-dimension.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample input**
>
> **Latest Batch**
>
> **Target Table**
>
--8<-- "docs/challenging-sql-problems/problems/engineering/updating-scd1-dimension--sample-input.sql"

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
--8<-- "docs/challenging-sql-problems/problems/engineering/updating-scd1-dimension--sample-output.sql"

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
>

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
>
