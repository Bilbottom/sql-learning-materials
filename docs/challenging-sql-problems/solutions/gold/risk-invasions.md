# Risk invasions 🛡️

> [!TIP]
>
> Solution to the following problem:
>
> - [risk-invasions.md](../../problems/gold/risk-invasions.md)

## Result Set

Regardless of the database, the result set should look like:

| attackers_remaining | defenders_remaining |   likelihood | attackers_win_likelihood | defenders_win_likelihood |
| ------------------: | ------------------: | -----------: | -----------------------: | -----------------------: |
|                   0 |                   1 | 0.0444861546 |             0.7295558279 |             0.2704441690 |
|                   0 |                   2 | 0.0811874068 |             0.7295558279 |             0.2704441690 |
|                   0 |                   3 | 0.0613334164 |             0.7295558279 |             0.2704441690 |
|                   0 |                   4 | 0.0473588523 |             0.7295558279 |             0.2704441690 |
|                   0 |                   5 | 0.0248517821 |             0.7295558279 |             0.2704441690 |
|                   0 |                   6 | 0.0112265568 |             0.7295558279 |             0.2704441690 |
|                   1 |                   0 | 0.0317758219 |             0.7295558279 |             0.2704441690 |
|                   2 |                   0 | 0.0656099405 |             0.7295558279 |             0.2704441690 |
|                   3 |                   0 | 0.1082686491 |             0.7295558279 |             0.2704441690 |
|                   4 |                   0 | 0.1294309856 |             0.7295558279 |             0.2704441690 |
|                   5 |                   0 | 0.1283258874 |             0.7295558279 |             0.2704441690 |
|                   6 |                   0 | 0.1230138225 |             0.7295558279 |             0.2704441690 |
|                   7 |                   0 | 0.0917943963 |             0.7295558279 |             0.2704441690 |
|                   8 |                   0 | 0.0513363246 |             0.7295558279 |             0.2704441690 |

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/solutions/gold/risk-invasions.sql"
</details>

## Solution

Some SQL solutions per database are provided below.

<!-- prettier-ignore -->
> SUCCESS: **DuckDB**
>
--8<-- "docs/challenging-sql-problems/solutions/gold/risk-invasions--duckdb.sql"
