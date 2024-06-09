# Bus routes 🚌

> [!TIP]
>
> Solution to the following problem:
>
> - [bus-routes.md](../../problems/silver/bus-routes.md)

## Result Set

Regardless of the database, the result set should look like:

| bus_id | route                                                                                                   |
| -----: | :------------------------------------------------------------------------------------------------------ |
|      1 | Old Street - Cavendish Road - Bakers March - West Quay Stop - Goose Green - Crown Street - Leather Lane |
|      2 | Hillside - Fellows Road - Riverside - Laddersmith - Furlong Reach                                       |
|      3 | Birch Park - Farfair - Golden Lane - Goose Green - Sailors Rest - Cavendish Road                        |

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/solutions/silver/bus-routes.sql"
</details>

## Solution

Some SQL solutions per database are provided below.

<!-- prettier-ignore -->
> SUCCESS: **DuckDB**
>
--8<-- "docs/challenging-sql-problems/solutions/silver/bus-routes--duckdb.sql"

<!-- prettier-ignore -->
> SUCCESS: **SQL Server**
>
--8<-- "docs/challenging-sql-problems/solutions/silver/bus-routes--sql-server.sql"
