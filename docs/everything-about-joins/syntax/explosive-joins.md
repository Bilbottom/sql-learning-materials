# The "explosive" joins (`LATERAL`) 💥

> [!SUCCESS]
>
> There are a few implementations of the `LATERAL` join in SQL databases (and not all are called "lateral"!), but they all have the same basic idea: generalising correlated subqueries to explode rows into more rows.

## Syntax

The syntax for lateral "joins" is different across databases, and some databases don't even call it "lateral".

In all cases, the lateral join is a generalisation of a correlated subquery, so make sure you have a grasp of those before trying to wrap your head around these!

> [!TIP]
>
> Check out the following page for information on correlated subqueries:
>
> - [from-excel-to-sql/advanced-concepts/correlated-subqueries.md](../../from-excel-to-sql/advanced-concepts/correlated-subqueries.md)

In particular, the lateral join "runs" the subquery for each row in the left table. The advantage of lateral joins is that we can get multiple columns and multiple rows from the subquery -- hence the "explosive" moniker!

We'll note the availability of the `LATERAL` keyword (and equivalents), then jump into the database-specific syntax, and finally provide some examples.

### Availability

At the time of writing (2024-04-07), the `LATERAL` join has the following availability:

- DuckDB: ✅ ([>=0.9](https://duckdb.org/docs/archive/0.9/sql/query_syntax/from#lateral-joins))
- SQLite: ❌ (but does support normal correlated subqueries)
- PostgreSQL: ✅ ([>=9.3](https://www.postgresql.org/about/news/postgresql-93-released-1481/))
- SQL Server: ✅ (but as [`CROSS APPLY`](https://learn.microsoft.com/en-us/sql/t-sql/queries/from-transact-sql?view=sql-server-ver16#using-apply))
- Snowflake: ✅

> [!INFO]
>
> For more information on lateral joins, particularly in other databases, see the following slides:
>
> - [https://www.slideshare.net/slideshow/modern-sql/44086611](https://www.slideshare.net/slideshow/modern-sql/44086611)

### DuckDB, PostgreSQL, Snowflake

Each of [DuckDB](https://duckdb.org/docs/sql/query_syntax/from.html#lateral-joins), [PostgreSQL](https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-LATERAL), and [Snowflake](https://docs.snowflake.com/en/sql-reference/constructs/join-lateral) use the same syntax for the lateral join.

Although we call it a "join", the `LATERAL` keyword is not used instead of `LEFT`, `INNER`, `CROSS`, etc. Instead, we specify it in front of a correlated subquery.

Since it's technically not a join, it's common to see people write lateral joins using non-ANSI join syntax:

```sql
SELECT *
FROM left_table, LATERAL (<expr>)
```

However, the ANSI syntax is also available:

```sql
SELECT *
FROM left_table
    [CROSS | LEFT] JOIN LATERAL (<expr>)
```

Note that, contrary to normal joins, using a lateral join with the non-ANSI syntax or in a `CROSS JOIN` will _drop rows that don't have a result from the subquery_! This is why you'll often see `LEFT JOIN LATERAL` in practice.

In particular, since the "join condition" is written inside the correlated subquery (it wouldn't be _correlated_ otherwise!), the left lateral joins usually have a dummy true condition in the `ON` clause. Common choices are `1=1` or `true`:

```sql
SELECT *
FROM left_table
    LEFT JOIN LATERAL (<expr>) ON TRUE
```

> [!WARNING]
>
> At the time of writing (2024-04-13), Snowflake does not support `LEFT JOIN LATERAL` and will throw an error if you try to use it.

### SQL Server

Instead of `LATERAL`, SQL Server provides `APPLY` as an alternative to `JOIN` to implement the same concept:

- [https://learn.microsoft.com/en-us/sql/t-sql/queries/from-transact-sql#using-apply](https://learn.microsoft.com/en-us/sql/t-sql/queries/from-transact-sql#using-apply)

The syntax is similar to the (ANSI) syntax for normal joins:

```sql
SELECT *
FROM left_table
    [CROSS | OUTER] APPLY (<expr>)
```

The `CROSS APPLY` corresponds to the "normal" lateral join which drops rows without a result from the subquery, while the `OUTER APPLY` corresponds to the `LEFT JOIN LATERAL`.

> [!TIP]
>
> In SQL Server, `APPLY` is typically used to "apply" a table-valued function to each row of the left table (hence the name of the keyword `APPLY`).

## Examples

It's fairly rare to need lateral joins, but they can be a lifesaver when you do!

For the examples below, we'll use a `customers` table and an `events` table to demonstrate the lateral join.

> [!INFO]
>
> This example is inspired by the following:
>
> - [https://stackoverflow.com/a/28733316/8213085](https://stackoverflow.com/a/28733316/8213085)

### Sample data

Suppose we have two tables, `customers` and `events`, with the following data:

#### `customers`

| customer_id | name    | last_review_datetime |
| ----------: | :------ | :------------------- |
|           1 | alice   | 2023-12-15 03:20:00  |
|           2 | bob     | 2024-01-24 03:30:00  |
|           3 | charlie | 2024-02-01 04:10:00  |

<details>
<summary>Expand for the object DDL</summary>

```sql
create table customers (
    customer_id integer primary key,
    name varchar,
    last_review_datetime datetime
);
insert into customers (customer_id, name, last_review_datetime)
    values
        (1, 'alice', '2023-12-15 03:20:00'),
        (2, 'bob', '2024-01-24 03:30:00'),
        (3, 'charlie', '2024-02-01 04:10:00')
;
```

</details>

#### `events`

| event_id | customer_id | event_datetime      | event_type     |
| -------: | ----------: | :------------------ | :------------- |
|        1 |           1 | 2024-01-01 11:00:00 | login          |
|        2 |           1 | 2024-01-01 12:00:00 | logout         |
|        3 |           1 | 2024-01-03 03:00:00 | login failed   |
|        4 |           1 | 2024-01-03 03:05:00 | login          |
|        5 |           2 | 2024-01-03 10:00:00 | login          |
|        6 |           2 | 2024-01-03 15:00:00 | logout         |
|        7 |           1 | 2024-01-03 23:00:00 | logout         |
|        8 |           2 | 2024-01-04 22:00:00 | login failed   |
|        9 |           2 | 2024-01-04 22:05:00 | login          |
|       10 |           3 | 2024-01-05 20:00:00 | login          |
|       11 |           3 | 2024-01-06 04:00:00 | logout         |
|       12 |           2 | 2024-01-09 15:00:00 | logout         |
|       13 |           3 | 2024-01-11 21:00:00 | login          |
|       14 |           1 | 2024-01-12 12:00:00 | login          |
|       15 |           1 | 2024-01-12 13:00:00 | logout         |
|       16 |           1 | 2024-01-13 03:00:00 | login          |
|       17 |           2 | 2024-01-13 10:00:00 | login failed   |
|       18 |           2 | 2024-01-13 10:05:00 | login          |
|       19 |           2 | 2024-01-13 15:00:00 | logout         |
|       20 |           1 | 2024-01-13 23:00:00 | logout         |
|       21 |           2 | 2024-01-14 22:00:00 | login          |
|       22 |           3 | 2024-01-15 20:00:00 | login          |
|       23 |           3 | 2024-01-16 04:00:00 | logout         |
|       24 |           2 | 2024-01-19 15:00:00 | logout         |
|       25 |           3 | 2024-01-21 21:00:00 | login          |
|       26 |           1 | 2024-01-22 12:00:00 | login failed   |
|       27 |           1 | 2024-01-22 12:05:00 | password reset |
|       28 |           1 | 2024-01-22 12:10:00 | login          |
|       29 |           1 | 2024-01-22 13:00:00 | logout         |
|       30 |           1 | 2024-01-23 03:00:00 | login          |
|       31 |           2 | 2024-01-23 10:00:00 | login          |
|       32 |           2 | 2024-01-23 15:00:00 | logout         |
|       33 |           1 | 2024-01-23 23:00:00 | logout         |
|       34 |           2 | 2024-01-24 22:00:00 | login          |
|       35 |           3 | 2024-01-25 20:00:00 | login          |
|       36 |           3 | 2024-01-26 04:00:00 | logout         |
|       37 |           2 | 2024-01-29 15:00:00 | logout         |
|       38 |           3 | 2024-01-31 21:00:00 | login          |

<details>
<summary>Expand for the object DDL</summary>

```sql
create table events (
    event_id integer primary key,
    customer_id integer,
    event_datetime datetime,
    event_type varchar
);
insert into events (event_id, customer_id, event_datetime, event_type)
    values
        (1, 1, '2024-01-01 11:00:00', 'login'),
        (2, 1, '2024-01-01 12:00:00', 'logout'),
        (3, 1, '2024-01-03 03:00:00', 'login failed'),
        (4, 1, '2024-01-03 03:05:00', 'login'),
        (5, 2, '2024-01-03 10:00:00', 'login'),
        (6, 2, '2024-01-03 15:00:00', 'logout'),
        (7, 1, '2024-01-03 23:00:00', 'logout'),
        (8, 2, '2024-01-04 22:00:00', 'login failed'),
        (9, 2, '2024-01-04 22:05:00', 'login'),
        (10, 3, '2024-01-05 20:00:00', 'login'),
        (11, 3, '2024-01-06 04:00:00', 'logout'),
        (12, 2, '2024-01-09 15:00:00', 'logout'),
        (13, 3, '2024-01-11 21:00:00', 'login'),
        (14, 1, '2024-01-12 12:00:00', 'login'),
        (15, 1, '2024-01-12 13:00:00', 'logout'),
        (16, 1, '2024-01-13 03:00:00', 'login'),
        (17, 2, '2024-01-13 10:00:00', 'login failed'),
        (18, 2, '2024-01-13 10:05:00', 'login'),
        (19, 2, '2024-01-13 15:00:00', 'logout'),
        (20, 1, '2024-01-13 23:00:00', 'logout'),
        (21, 2, '2024-01-14 22:00:00', 'login'),
        (22, 3, '2024-01-15 20:00:00', 'login'),
        (23, 3, '2024-01-16 04:00:00', 'logout'),
        (24, 2, '2024-01-19 15:00:00', 'logout'),
        (25, 3, '2024-01-21 21:00:00', 'login'),
        (26, 1, '2024-01-22 12:00:00', 'login failed'),
        (27, 1, '2024-01-22 12:05:00', 'password reset'),
        (28, 1, '2024-01-22 12:10:00', 'login'),
        (29, 1, '2024-01-22 13:00:00', 'logout'),
        (30, 1, '2024-01-23 03:00:00', 'login'),
        (31, 2, '2024-01-23 10:00:00', 'login'),
        (32, 2, '2024-01-23 15:00:00', 'logout'),
        (33, 1, '2024-01-23 23:00:00', 'logout'),
        (34, 2, '2024-01-24 22:00:00', 'login'),
        (35, 3, '2024-01-25 20:00:00', 'login'),
        (36, 3, '2024-01-26 04:00:00', 'logout'),
        (37, 2, '2024-01-29 15:00:00', 'logout'),
        (38, 3, '2024-01-31 21:00:00', 'login')
;
```

</details>

### The following three events after each customer's last review

To illustrate the lateral join, we'll find the next three events after each customer's last review. If the customer has no events after their last review, we'll have `NULL` values for the event columns.

Using lateral joins makes sense for this problem because we need to:

- Compare information between the `customers` and `events` tables
- Limit the number of events kept per customer
- "Explode" the customer table for each matching row in the `events` table

### SQLite

Since SQLite doesn't support lateral joins, we'll show how to solve this problem without using a lateral join:

```sql
with events_since_review as (
    select
        events.event_id,
        events.event_datetime,
        events.event_type,
        events.customer_id,
        row_number() over (
            partition by customer_id
            order by event_datetime
        ) as event_number
    from events
        inner join customers
            using (customer_id)
    where events.event_datetime > customers.last_review_datetime
)

select
    customers.customer_id,
    customers.name as customer_name,
    events_since_review.event_id,
    events_since_review.event_datetime,
    events_since_review.event_type
from customers
    left join events_since_review
        on  customers.customer_id = events_since_review.customer_id
        and events_since_review.event_number <= 3
order by
    customers.customer_id,
    events_since_review.event_datetime
```

| customer_id | customer_name | last_review_datetime | event_id | event_datetime      | event_type   |
| ----------: | :------------ | :------------------- | -------: | :------------------ | :----------- |
|           1 | alice         | 2023-12-15 03:20:00  |        1 | 2024-01-01 11:00:00 | login        |
|           1 | alice         | 2023-12-15 03:20:00  |        2 | 2024-01-01 12:00:00 | logout       |
|           1 | alice         | 2023-12-15 03:20:00  |        3 | 2024-01-03 03:00:00 | login failed |
|           2 | bob           | 2024-01-24 03:30:00  |       34 | 2024-01-24 22:00:00 | login        |
|           2 | bob           | 2024-01-24 03:30:00  |       37 | 2024-01-29 15:00:00 | logout       |
|           3 | charlie       | 2024-02-01 04:10:00  |   _null_ | _null_              | _null_       |

To write a query that meets the requirements, we need to:

1.  Join the `customers` table to the `events` table so that we can compare the last review date with the event date
2.  Use the `ROW_NUMBER()` window function to number the events for each customer so that we can limit the number of events to three
3.  Join the results of the previous two steps back onto the `customers` table to account for customers who have no events after their last review

We'll see that the lateral join makes this query a bit simpler.

### DuckDB and PostgreSQL

For DuckDB and PostgreSQL, we can use the lateral join to achieve the same result:

```sql
select
    customers.customer_id,
    customers.name as customer_name,
    customers.last_review_datetime,
    events_since_review.event_id,
    events_since_review.event_datetime,
    events_since_review.event_type
from customers
    left join lateral (
        select *
        from events
        where 1=1
            and customers.customer_id = events.customer_id
            and customers.last_review_datetime < events.event_datetime
        order by events.event_datetime
        limit 3
    ) as events_since_review on 1=1
order by
    customers.customer_id,
    events_since_review.event_datetime
```

We do the relevant filtering in the subquery, which is run for each row in the `customers` table. The `left join` ensures that we don't drop any customers, and the `limit 3` is applied _per customer_ to keep at most three events _per customer_.

> [!QUESTION]
>
> Given the Snowflake doesn't (currently) support `LEFT JOIN LATERAL`, how would you solve this for Snowflake?

### SQL Server

The SQL Server version would be very similar to the DuckDB and PostgreSQL versions, but with `OUTER APPLY` instead of `LEFT JOIN LATERAL` (and other minor tweaks for SQL Server syntax):

```sql
select
    customers.customer_id,
    customers.name as customer_name,
    customers.last_review_datetime,
    events_since_review.event_id,
    events_since_review.event_datetime,
    events_since_review.event_type
from customers
    outer apply (
        select top 3 *
        from events
        where 1=1
            and customers.customer_id = events.customer_id
            and customers.last_review_datetime < events.event_datetime
        order by events.event_datetime
    ) as events_since_review
order by
    customers.customer_id,
    events_since_review.event_datetime
```

## Wrap up

Given that subqueries are one of SQL's most powerful features, lateral joins are a natural extension of that power. They're not often needed, but when you do need them, they can make your life much easier!
