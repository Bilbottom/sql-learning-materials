---
hide:
  - tags
tags:
  - pivot and unpivot
  - rollup
---

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
>? INFO: **Sample input**
>
> Find the average precipitation levels for the grids:
>
> - `AB-12`
> - `AB-99`
> - `Z-17`
>
> ...given the precipitation levels below:
>
> | grid_id |    pr_january |   pr_february |      pr_march |      pr_april |       pr_may |      pr_june |      pr_july |    pr_august | pr_september |    pr_october |   pr_november |   pr_december |
> |:--------|--------------:|--------------:|--------------:|--------------:|-------------:|-------------:|-------------:|-------------:|-------------:|--------------:|--------------:|--------------:|
> | AB-12   |  98.654982000 |  95.465774000 |  93.622460000 |  94.100401000 | 87.123098000 | 67.165477000 | 54.468731000 | 55.012740000 | 57.335890000 |  67.232145000 |  85.332001000 |  92.165432000 |
> | AB-34   | 154.119868000 | 125.977546000 | 101.024456000 | 134.523452000 | 99.456788000 | 95.025468000 | 92.135497000 | 93.653200000 | 98.126477000 | 103.332032000 | 111.360141000 | 125.216407000 |
> | C-56    |  56.963354000 |  76.455462000 |  61.879871000 |  87.666547000 | 85.931607000 | 83.636598000 | 51.258741000 | 65.165441000 | 71.636687000 |  94.654210000 |  92.632147000 | 101.300156000 |
>
--8<-- "docs/challenging-sql-problems/problems/silver/region-precipitation--sample-input.sql"

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> | grid_id | average_precipitation |
> |:--------|----------------------:|
> | AB-12   |             78.973261 |
> | AB-99   |             95.067936 |
> | Z-17    |             89.189202 |
>
--8<-- "docs/challenging-sql-problems/problems/silver/region-precipitation--sample-output.sql"

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

### Worked examples

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
