# Personalised customer emails 📨

> [!SUCCESS] Scenario
>
> A B2B vendor is looking to email their customers about changes to their account.
>
> This bank's customers are companies, and these companies have multiple contacts associated with them. While the companies have an email address in the system, it's not clear which contact the email address corresponds to.
>
> The bank wants to email the company's email address, but to make it more personal, they want to use the first name of the corresponding contact in the email salutation; e.g. "Hey John".

> [!QUESTION]
>
> Given the customer details and relationships below, write a query to determine which first name to use in the email salutation for each company. If none of the contacts' names seem to be a good fit, use `NULL` instead.
>
> The output should have one row for each company, with the columns:
>
> - `company_name` as the name of the company
> - `company_email_address` as the email address of the company
> - `salutation_name` as the first name to use in the email salutation
>
> Order the output by `company_name`.

> [!INFO]
>
> There is no "correct" answer to this question: just provide a reasonable solution for the database that you're using.

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/bronze/personalised-customer-emails.sql"
</details>

The solution can be found at:

- [personalised-customer-emails.md](../../solutions/bronze/personalised-customer-emails.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> | company_name    | company_email_address         | salutation_name |
> |:----------------|:------------------------------|:----------------|
> | Fractal Factory | billiam@fractal-factory.co.uk | William         |
> | ...             | ...                           | ...             |

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> Use a string similarity function like [`DIFFERENCE` (SQL Server)](https://learn.microsoft.com/en-us/sql/t-sql/functions/difference-transact-sql) or [`JACCARD` (DuckDB)](https://duckdb.org/docs/sql/functions/char.html#jaccards1-s2) to compare the contact names to the company email address.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> Only compare the part of the email addresses before the `@` symbol.
