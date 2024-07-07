# Supply chain network 🚛

> [!TIP]
>
> Solution to the following problem:
>
> - [supply-chain-network.md](../../problems/gold/supply-chain-network.md)

## Result Set

Regardless of the database, the result set should look like:

| stock_date | store_id | supplier_id | stock_volume | stock_proportion |
| :--------- | -------: | ----------: | -----------: | ---------------: |
| 2024-01-01 |        6 |           1 |            0 |             0.00 |
| 2024-01-01 |        6 |           2 |           10 |           100.00 |
| 2024-01-01 |        7 |           1 |            0 |             0.00 |
| 2024-01-01 |        7 |           2 |            0 |             0.00 |
| 2024-01-01 |        8 |           1 |            0 |             0.00 |
| 2024-01-01 |        8 |           2 |            0 |             0.00 |
| 2024-01-02 |        6 |           1 |            0 |             0.00 |
| 2024-01-02 |        6 |           2 |            9 |           100.00 |
| 2024-01-02 |        7 |           1 |            6 |            54.55 |
| 2024-01-02 |        7 |           2 |            5 |            45.45 |
| 2024-01-02 |        8 |           1 |            0 |             0.00 |
| 2024-01-02 |        8 |           2 |            1 |           100.00 |
| 2024-01-03 |        6 |           1 |           14 |            41.18 |
| 2024-01-03 |        6 |           2 |           20 |            58.82 |
| 2024-01-03 |        7 |           1 |            0 |             0.00 |
| 2024-01-03 |        7 |           2 |            2 |           100.00 |
| 2024-01-03 |        8 |           1 |            1 |             6.25 |
| 2024-01-03 |        8 |           2 |           15 |            93.75 |
| 2024-01-04 |        6 |           1 |           34 |            57.63 |
| 2024-01-04 |        6 |           2 |           25 |            42.37 |
| 2024-01-04 |        7 |           1 |            3 |           100.00 |
| 2024-01-04 |        7 |           2 |            0 |             0.00 |
| 2024-01-04 |        8 |           1 |           15 |           100.00 |
| 2024-01-04 |        8 |           2 |            0 |             0.00 |

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/solutions/gold/supply-chain-network.sql"
</details>

## Solution

Some SQL solutions per database are provided below.

<!-- prettier-ignore -->
> SUCCESS: **DuckDB**
>
--8<-- "docs/challenging-sql-problems/solutions/gold/supply-chain-network--duckdb.sql"
