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
> The batch data contains information for all records in the source system regardless of whether the records have changed, but this particular pipeline should only process records that have changed so that all the resulting table metadata is correct.

> [!QUESTION]
>
> Write a query which produces the records in the latest batch that are different to the records in the target table.
>
> The output should have the columns from the batch data, with `snapshot_ts` mapped to `last_update_ts` and a calculated `deleted_flag` column:
>
> - `customer_id`
> - `date_of_birth`
> - `gender`
> - `ethnicity`
> - `email`
> - `phone`
> - `last_update_ts` as the latest `snapshot_ts` from the source table if the customer record has been modified or deleted
> - `deleted_flag` as `true` if the customer exists in the target table, but not in the source table. A deleted customer cannot be undeleted
>
> Order the output by `customer_id`.

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
