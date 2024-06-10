# Personalised customer emails 📨

> [!TIP]
>
> Solution to the following problem:
>
> - [personalised-customer-emails.md](../../problems/bronze/personalised-customer-emails.md)

## Result Set

Regardless of the database, the result set should look like:

| company_name     | company_email_address         | salutation_name |
| :--------------- | :---------------------------- | :-------------- |
| Fractal Factory  | billiam@fractal-factory.co.uk | William         |
| Friends For Hire | joe.trib@f4hire.com           | Joey            |
| Some Company     | admin@somecompany.com         | `null`          |

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/solutions/bronze/personalised-customer-emails.sql"
</details>

## Solution

Some SQL solutions per database are provided below.

<!-- prettier-ignore -->
> SUCCESS: **DuckDB**
>
> This DuckDB solution uses the Jaccard similarity with a 25% match threshold, but this isn't the only way to solve this problem.
>
--8<-- "docs/challenging-sql-problems/solutions/bronze/personalised-customer-emails--duckdb.sql"

<!-- prettier-ignore -->
> SUCCESS: **SQL Server**
>
> This SQL Server solution uses the Soundex differences with a 3 (out of 4) match threshold, but this isn't the only way to solve this problem.
>
--8<-- "docs/challenging-sql-problems/solutions/bronze/personalised-customer-emails--sql-server.sql"
