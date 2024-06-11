# Travel plans 🚂

> [!SUCCESS] Scenario
>
> You're helping a client plan a trip from New York to Paris, and they want you to find the fastest and cheapest route.
>
> They have collected journey information into two tables:
>
> - `routes_timetable`
> - `routes_schedule`
>
> The timetable table records individual routes with their full departure/arrival timestamps and cost. The schedule table records the _schedule_ of repeated routes with their schedule definition.
>
> The earliest they can leave from New York is `2024-01-01 12:00:00-05:00`.

> [!QUESTION]
>
> Given the tables that your client has provided, find the fastest and cheapest route from New York to Paris, leaving after `2024-01-01 12:00:00-05:00`.
>
> Give a minimum of 30 minutes and a maximum of 2 hours for "interchange" time (the time between arrival and departure at the same location). All costs are in the same currency (with no currency specified by the client).
>
> The output should have at most two rows (the fastest/cheapest routes, which may be the same route), with the columns:
>
> - `route` which is each location in the route separated by a hyphen, e.g. `New York - London - Paris`
> - `departure_datetime_utc` as the departure time (UTC) from New York
> - `arrival_datetime_utc` as the arrival time (UTC) in Paris
> - `duration` as the total duration of the journey
> - `cost` as the total cost of the journey
>
> Order the output by `arrival_datetime_utc`.

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/gold/travel-plans.sql"
</details>

The solution can be found at:

- [travel-plans.md](../../solutions/gold/travel-plans.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> | route            | departure_datetime_utc | arrival_datetime_utc | duration |   cost |
> |:-----------------|:-----------------------|:---------------------|:---------|-------:|
> | New York - Paris | 2024-01-01 23:00:00    | 2024-01-02 16:45:00  | 17:45:00 | 279.00 |
> | ...              | ...                    | ...                  | ...      |    ... |

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> Expand the `routes_schedule` table into individual routes and then union with the `routes_timetable` table for a full list of routes to consider.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> Use a [recursive CTE](../../../from-excel-to-sql/advanced-concepts/recursive-ctes.md) to build up the journey from New York to Paris, considering the interchange time between routes.
