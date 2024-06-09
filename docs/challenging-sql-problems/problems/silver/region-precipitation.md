# Region precipitation ☔

> [!SUCCESS] Scenario
>
> Analysts are using a weather dataset to understand the precipitation levels in different regions.
>
> They have a dataset with the average precipitation levels per month for various "grids" in the UK.
>
> A "grid" consists of a region and a location, joined together with a hyphen. For example, `AC-27` is a grid; the region is `AC` and the location is `27`.
>
> For grids that they are studying, they need the average of the monthly precipitation levels. Note that "average" here is just the mean of the values, not a weighted average or anything more complex.
>
> They are also aware that the dataset has some gaps in it, so to fill some values for the grids not in the dataset, they use the following logic:
>
> - If the grid exists in the dataset, use the average of the monthly precipitation levels for the grid.
> - If the grid doesn't exist but other grids in the same region do, use the average of the monthly precipitation levels for the grids in the same region.
> - Otherwise, use the average of the monthly precipitation levels for the whole dataset.
>
> In each case, round the average to six decimal places.

> [!QUESTION]
>
> Find the average precipitation levels for the grids below:
>
> - `AC-27`
> - `AQ-54`
> - `AQ-55`
> - `AQ-56`
> - `BK-45`
> - `BK-77`
> - `BR-18`
> - `X-17`
>
> The output should have a row for each of the grids above, with the columns:
>
> - `grid_id`
> - `average_precipitation` as the average precipitation level for the grid, using the logic above
>
> Order the output by `grid_id`.

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/silver/region-precipitation.sql"
</details>

The solution can be found at:

- [region-precipitation.md](../../solutions/silver/region-precipitation.md)

A worked example is provided below to help illustrate the average calculations.

---

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> | grid_id | average_precipitation |
> |:--------|----------------------:|
> | AC-27   |            131.147673 |
> | AQ-54   |            165.693967 |
> | ...     |                   ... |

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> Create a lookup table with the average precipitation levels for each grid in the dataset, _as well as_ rolled up averages (by [using `ROLLUP`](../../../from-excel-to-sql/main-concepts/rollup.md)) for each region and the entire dataset.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> Use the [`GROUPING` (DuckDB)](https://duckdb.org/docs/sql/aggregates.html#miscellaneous-aggregate-functions) or [`GROUPING_ID` (SQL Server)](https://learn.microsoft.com/en-us/sql/t-sql/functions/grouping-id-transact-sql?view=sql-server-ver16) function to determine if a row is a total, subtotal, or grand total, and then join the lookup table to the dataset three times—one for each total type—using this group ID (and any other required columns).

> [!SUCCESS]
>
> If you're interested in using some real (and complete!) Met Office data, you can find plenty at:
>
> - [https://climatedataportal.metoffice.gov.uk/](https://climatedataportal.metoffice.gov.uk/)

---

### Worked example

To help illustrate the average calculations, consider the following grids:

- `AC-27`
- `AC-28`
- `Z-14`

Let's briefly walk through the average calculation for each of these grids.

#### `AC-27`

The dataset has precipitation levels for `AC-27`, so we use the mean of the twelve monthly precipitation levels for `AC-27`: this is `131.147673`.

#### `AC-28`

The dataset doesn't have precipitation levels for `AC-28`, but it does have precipitation levels for other `AC` locations (namely, `AC-27`, `AC-60`, and `AC-62`). We use the mean of the monthly precipitation levels for _each_ grid in the `AC` region: this is `93.646562`.

#### `Z-14`

The dataset doesn't have precipitation levels for `Z-14`, and it doesn't have precipitation levels for any other `Z` locations. We use the mean of the monthly precipitation levels for _all_ grids in the dataset: this is `99.378632`.
