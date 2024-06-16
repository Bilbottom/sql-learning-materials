# UK bank holidays 📅

> [!NOTE]
>
> This question is specific to [DuckDB](https://duckdb.org/):
>
> - [https://duckdb.org/](https://duckdb.org/)

> [!QUESTION]
>
> Using [DuckDB](https://duckdb.org/), parse the [UK bank holiday endpoint](https://www.gov.uk/bank-holidays.json) into an SQL table.
>
> - [https://www.gov.uk/bank-holidays.json](https://www.gov.uk/bank-holidays.json)
>
> Each row in the output should correspond to a single event, and the column headers (below) should map directly to the JSON properties with the same names:
>
> - `division`
> - `title`
> - `date`
> - `notes`
> - `bunting`

Here's a starting point:

```sql
from 'https://www.gov.uk/bank-holidays.json'
```

The solution can be found at:

- [uk-bank-holidays.md](../../solutions/bronze/uk-bank-holidays.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample input**
>
--8<-- "docs/challenging-sql-problems/problems/bronze/uk-bank-holidays--sample-input.sql"

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> | division          | date       | notes          | bunting | title            |
> |:------------------|:-----------|:---------------|:--------|:-----------------|
> | england-and-wales | 2018-01-01 |                | true    | New Year’s Day   |
> | england-and-wales | 2018-03-30 |                | false   | Good Friday      |
> | scotland          | 2018-01-01 |                | true    | New Year’s Day   |
> | scotland          | 2018-01-02 |                | true    | 2nd January      |
> | northern-ireland  | 2018-01-01 |                | true    | New Year’s Day   |
> | northern-ireland  | 2018-03-19 | Substitute day | true    | St Patrick’s Day |
>
--8<-- "docs/challenging-sql-problems/problems/bronze/uk-bank-holidays--sample-output.sql"

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> Use [`UNPIVOT`](https://duckdb.org/docs/sql/statements/unpivot.html) to move the separate columns for each division into a single column.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> Use [`UNNEST`](https://duckdb.org/docs/sql/query_syntax/unnest.html) to explode the event JSON into separate rows and columns.
