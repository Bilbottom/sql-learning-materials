---
hide:
  - tags
tags:
  - hash diff
---

# Identifying changed records 🎉

> [!SUCCESS] Scenario
>
> You're working on a data pipeline that processes batches of data on a daily basis.
>
> The batch data contains information for all records in the source system regardless of whether the records have changed, but this particular pipeline should only process records that have changed so that all the table metadata is correct.

> [!QUESTION]
>
> Write a query which produces the records in the latest batch that are different to the records in the target table by utilising a hash diff.
>
> The output should have the columns from the batch data and the corresponding metadata columns:
>
> - `...`
>
> Order the output by `...`.

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/engineering/identifying-changed-records.sql"
</details>

The solution can be found at:

- [identifying-changed-records.md](../../solutions/engineering/identifying-changed-records.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample input**
>
> **Latest Batch**
>
> **Target Table**
>
--8<-- "docs/challenging-sql-problems/problems/engineering/identifying-changed-records--sample-input.sql"

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
--8<-- "docs/challenging-sql-problems/problems/engineering/identifying-changed-records--sample-output.sql"

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
>

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
>
