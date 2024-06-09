# Region precipitation ☔

> [!TIP]
>
> Solution to the following problem:
>
> - [region-precipitation.md](../../problems/silver/region-precipitation.md)

## Result Set

Regardless of the database, the result set should look like:

| grid_id | average_precipitation |
| :------ | --------------------: |
| AC-27   |            131.147673 |
| AQ-54   |            165.693967 |
| AQ-55   |            142.360421 |
| AQ-56   |            111.379457 |
| BK-45   |             58.619428 |
| BK-77   |              51.46849 |
| BR-18   |             99.378632 |
| X-17    |            102.888115 |

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/solutions/silver/region-precipitation.sql"
</details>

## Solution

Some SQL solutions per database are provided below.

<!-- prettier-ignore -->
> SUCCESS: **DuckDB**
>
--8<-- "docs/challenging-sql-problems/solutions/silver/region-precipitation--duckdb.sql"

<!-- prettier-ignore -->
> SUCCESS: **SQL Server**
>
--8<-- "docs/challenging-sql-problems/solutions/silver/region-precipitation--sql-server.sql"
