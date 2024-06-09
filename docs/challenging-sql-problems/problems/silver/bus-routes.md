# Bus routes 🚌

> [!SUCCESS] Scenario
>
> A transport company records their bus routes in a table where each row represents a leg of a journey, but they want to know the full route for each bus.

> [!QUESTION]
>
> Compute the full route for each bus.
>
> Use the following stops as the first stop for each bus:
>
> - `Old Street` for `bus_id = 1`
> - `Hillside` for `bus_id = 2`
> - `Birch Park` for `bus_id = 3`
>
> The output should have a single row per bus with the columns:
>
> - `bus_id`
> - `route` which is each bus stop in the route separated by a hyphen, e.g. `First Stop - Middle Stop - Final Stop`
>
> Order the output by `bus_id`.

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/silver/bus-routes.sql"
</details>

The solution can be found at:

- [bus-routes.md](../../solutions/silver/bus-routes.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> | bus_id | route                                                                                                   |
> |-------:|:--------------------------------------------------------------------------------------------------------|
> |      1 | Old Street - Cavendish Road - Bakers March - West Quay Stop - Goose Green - Crown Street - Leather Lane |
> |    ... | ...                                                                                                     |

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> Use a [recursive CTE](../../../from-excel-to-sql/advanced-concepts/recursive-ctes.md) to put the bus stops in order for each bus.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> These routes are cyclical, so include a condition to stop the recursion when you reach the first stop for each bus again.
