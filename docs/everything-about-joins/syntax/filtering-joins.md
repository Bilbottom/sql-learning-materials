# The "filtering" joins (`SEMI`, `ANTI`) 🚦

> [!SUCCESS]
>
> The `SEMI` and `ANTI` joins are slightly different from typical joins because they're used to _filter_ the rows from the left table based on the presence or absence of a match in the right table.

## Syntax

The terms "semi-join" and "anti-join" have, historically, been used to describe the `IN` and `NOT IN` (or `EXISTS` and `NOT EXISTS`) operators, respectively.

For example, it was common to refer to a query like the following as one that implements a "semi-join":

```sql
select *
from left_table
where exists (
    select *
    from right_table
    where right_table.id_column = left_table.id_column
)
```

At the time of writing (2024-04-07), DuckDB is one of the few databases to have introduced the `SEMI` and `ANTI` join types to make these types of queries more explicit and easier to read.

```sql
SELECT *
FROM left_table
    [SEMI | ANTI] JOIN right_table
        ON left_table.id_column = right_table.id_column
```

### Availability

At the time of writing (2024-04-07), the `SEMI` and `ANTI` joins (as explicit join types) have the following availability:

- DuckDB: ✅
- SQLite: ❌
- PostgreSQL: ❌
- SQL Server: ❌
- Snowflake: ❌

Are you aware of any other databases that support the `SEMI` and `ANTI` joins (as explicit join types)?

## Examples

### Sample data

Suppose we have two tables, `loans` and `credit_cards`, with the following data:

#### `loans`

| loan_id | loan_value | customer_id |
| ------: | ---------: | ----------: |
|       1 |    1000.00 |           1 |
|       2 |    2000.00 |           1 |
|       3 |    3000.00 |           3 |
|       4 |    4000.00 |           6 |
|       5 |    5000.00 |           7 |

<details>
<summary>Expand for the object DDL</summary>

```sql
create or replace table loans (
    loan_id int,
    loan_value decimal(10, 2),
    customer_id int,
    constraint pk__loans primary key (loan_id),
);
insert into loans
    values
        (1, 1000.0, 1),
        (2, 2000.0, 1),
        (3, 3000.0, 3),
        (4, 4000.0, 6),
        (5, 5000.0, 7),
;
```

</details>

#### `credit_cards`

| credit_card_id | credit_limit | customer_id |
| -------------: | -----------: | ----------: |
|              1 |      1000.00 |           1 |
|              2 |      2000.00 |           2 |
|              3 |      2000.00 |           4 |
|              4 |      3000.00 |           5 |
|              5 |      4000.00 |           6 |

<details>
<summary>Expand for the object DDL</summary>

```sql
create or replace table credit_cards (
    credit_card_id int,
    credit_limit decimal(10, 2),
    customer_id int,
    constraint pk__credit_cards primary key (credit_card_id),
);
insert into credit_cards
    values
        (1, 1000.0, 1),
        (2, 2000.0, 2),
        (3, 2000.0, 4),
        (4, 3000.0, 5),
        (5, 4000.0, 6),
;
```

</details>

### Loan details for customers who have a loan and a credit card

#### Solution

To get the loan details for customers who have a loan _and_ a credit card, we can use a `SEMI` join with the `loans` table on the left and the `credit_cards` table on the right:

```sql
select *
from loans
    semi join credit_cards
        using (customer_id)
```

| loan_id | loan_value | customer_id |
| ------: | ---------: | ----------: |
|       1 |    1000.00 |           1 |
|       2 |    2000.00 |           1 |
|       4 |    4000.00 |           6 |

Observe that we only get the `loans` columns in the result set despite using an unqualified `*`. This is because the `SEMI` (and `ANTI`) join is _purely_ for filtering the rows: it doesn't add any columns to the result set!

> [!QUESTION] Exercise
>
> Can you write a query to get the credit card details for customers who have a loan and a credit card?

#### "Traditional" solutions

For comparison, here are a few solutions that illustrate how you might solve this problem without the `SEMI` join.

##### Using `EXISTS`

Historically, the `EXISTS` operator has been used to implement a "semi-join" in SQL:

```sql
select *
from loans
where exists (
    select *
    from credit_cards
    where credit_cards.customer_id = loans.customer_id
)
```

##### Using `IN`

Using `IN` is the most common way to solve this problem, mainly because more people know about `IN` than `EXISTS`:

```sql
select *
from loans
where customer_id in (
    select customer_id
    from credit_cards
)
```

However, it's worth noting that `EXISTS` is typically more performant than `IN` when the subquery returns a large number of rows.

### Loan details for customers who have a loan but no credit card

#### Solution

To get the loan details for customers who have a loan _but no_ credit card, we can use an `ANTI` join with the `loans` table on the left and the `credit_cards` table on the right:

```sql
select *
from loans
    anti join credit_cards
        using (customer_id)
```

| loan_id | loan_value | customer_id |
| ------: | ---------: | ----------: |
|       3 |    3000.00 |           3 |
|       5 |    5000.00 |           7 |

Simple!

> [!QUESTION] Exercise
>
> Can you write a query to get the credit card details for customers who have a loan but no credit card?

#### "Traditional" solutions

For comparison, here are a few solutions that illustrate how you might solve this problem without the `ANTI` join.

##### Using `NOT EXISTS`

Similar to `EXISTS`, the `NOT EXISTS` operator has historically been used to implement an "anti-join" in SQL:

```sql
select *
from loans
where not exists (
    select *
    from credit_cards
    where credit_cards.customer_id = loans.customer_id
)
```

##### Using `NOT IN`

Similarly, `NOT IN` is the most common way to solve this problem but would also suffer from the same performance issues as `IN` when the data is sufficiently large:

```sql
select *
from loans
where customer_id not in (
    select customer_id
    from credit_cards
)
```

## Wrap up

The `SEMI` and `ANTI` joins are a nice addition to the SQL language, making it easier to write and read queries that filter rows based on the presence or absence of a match in another table. However, they're _only_ for filtering and not for adding columns to the result set, which could be surprising if you haven't used them before.
