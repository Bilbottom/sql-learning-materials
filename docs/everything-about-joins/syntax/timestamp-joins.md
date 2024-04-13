# The "timestamp" join (`ASOF`) ⏱

> [!SUCCESS]
>
> The `ASOF` join is fantastic for joining two tables with mismatched timestamps, where you want to join on the closest timestamp in the right table to the timestamp in the left table.

## Syntax

At the time of writing (2024-04-07), the syntax for the `ASOF` join changes depending on the database engine you're using. However, the general idea is the same across all engines: you're joining two tables based on the closest timestamp in the right table to the timestamp in the left table.

#### DuckDB

> [!NOTE]
>
> The explanation below is adjusted from the [DuckDB documentation](https://duckdb.org/docs/sql/query_syntax/from.html#as-of-joins).

In DuckDB, the `ASOF` keyword is a join modifier just like `NATURAL`, which means that you can use it with any join type (`left`, `inner`, etc.).

The `ASOF` join requires at least one inequality condition on the ordering field. The inequality can be any inequality condition (`>=`, `>`, `<=`, `<`) on any data type, but the most common form is `>=` on a temporal type. Any other conditions must be equalities (or `NOT DISTINCT`). This means that the left/right order of the tables is significant.

```sql
SELECT *
FROM left_table
    ASOF [LEFT | INNER | ...] JOIN right_table
        ON  left_table.id_column = right_table.id_column
        AND left_table.timestamp_column >= right_table.timestamp_column
```

`ASOF` joins can also specify join conditions on matching column names with the `USING` syntax, but the _last_ attribute in the list must be the inequality, which will be greater than or equal to (`>=`):

```sql
SELECT *
FROM left_table
    ASOF [LEFT | INNER | ...] JOIN right_table
        USING (id_column, timestamp_column)
```

#### Snowflake

Snowflake has a more unique syntax for the `ASOF` join. Rather than be a join modifier, Snowflake treats it as a new join type and introduces the `MATCH_CONDITION` clause:

```sql
SELECT *
FROM left_table
    ASOF JOIN right_table
        MATCH_CONDITION (left_table.timestamp_column >= right_table.timestamp_column)
        ON left_table.id_column = right_table.id_column
```

It has an added restriction that the `MATCH_CONDITION` clause _must_ reference the left column first, then the right column. This isn't a typical for join conditions, hence calling it out here.

### Availability

At the time of writing (2024-04-07), the `ASOF` join has the following availability:

- DuckDB: ✅ ([>=0.6](https://duckdb.org/docs/archive/0.6/sql/query_syntax/from))
- SQLite: ❌
- PostgreSQL: ❌
- SQL Server: ❌
- Snowflake: ✅ ([February 28, 2024](https://docs.snowflake.com/en/release-notes/2024/other/2024-02-28))

Are you aware of any other databases that support the `ASOF` join?

## Examples

### Sample data

Suppose we have two tables, `transactions` and `exchange_rates`, with the following data:

#### `transactions`

| date       | account |  amount | currency |
| :--------- | :------ | ------: | :------- |
| 2023-12-31 | A       |  100.00 | GBP      |
| 2024-01-01 | B       |  200.00 | GBP      |
| 2024-01-02 | C       |  300.00 | GBP      |
| 2024-01-04 | A       |  400.00 | GBP      |
| 2024-01-07 | B       |  500.00 | GBP      |
| 2024-01-07 | C       |  600.00 | GBP      |
| 2024-01-08 | A       |  700.00 | GBP      |
| 2024-01-10 | B       |  800.00 | GBP      |
| 2024-01-13 | C       |  900.00 | GBP      |
| 2024-01-13 | A       | 1000.00 | GBP      |
| 2024-01-17 | B       | 1100.00 | GBP      |
| 2024-01-17 | C       | 1200.00 | GBP      |
| 2024-01-18 | A       | 1300.00 | GBP      |
| 2024-01-20 | B       | 1400.00 | GBP      |
| 2024-01-23 | C       | 1500.00 | GBP      |
| 2024-01-23 | A       | 1600.00 | GBP      |
| 2024-01-27 | B       | 1700.00 | GBP      |
| 2024-01-27 | C       | 1800.00 | GBP      |
| 2024-01-28 | A       | 1900.00 | GBP      |
| 2024-01-30 | B       | 2000.00 | GBP      |
| 2024-02-02 | C       | 2100.00 | GBP      |
| 2024-02-02 | A       | 2200.00 | GBP      |
| 2024-02-06 | B       | 2300.00 | GBP      |
| 2024-02-06 | C       | 2400.00 | GBP      |

<details>
<summary>Expand for the object DDL</summary>

```sql
create or replace table transactions(
    "date" date,
    account varchar(8),
    amount decimal(10, 2),
    currency varchar(3),
    constraint pk__transactions primary key ("date", account),
);
insert into transactions
    values
        ('2023-12-31', 'A', 100, 'GBP'),
        ('2024-01-01', 'B', 200, 'GBP'),
        ('2024-01-02', 'C', 300, 'GBP'),
        ('2024-01-04', 'A', 400, 'GBP'),
        ('2024-01-07', 'B', 500, 'GBP'),
        ('2024-01-07', 'C', 600, 'GBP'),
        ('2024-01-08', 'A', 700, 'GBP'),
        ('2024-01-10', 'B', 800, 'GBP'),
        ('2024-01-13', 'C', 900, 'GBP'),
        ('2024-01-13', 'A', 1000, 'GBP'),
        ('2024-01-17', 'B', 1100, 'GBP'),
        ('2024-01-17', 'C', 1200, 'GBP'),
        ('2024-01-18', 'A', 1300, 'GBP'),
        ('2024-01-20', 'B', 1400, 'GBP'),
        ('2024-01-23', 'C', 1500, 'GBP'),
        ('2024-01-23', 'A', 1600, 'GBP'),
        ('2024-01-27', 'B', 1700, 'GBP'),
        ('2024-01-27', 'C', 1800, 'GBP'),
        ('2024-01-28', 'A', 1900, 'GBP'),
        ('2024-01-30', 'B', 2000, 'GBP'),
        ('2024-02-02', 'C', 2100, 'GBP'),
        ('2024-02-02', 'A', 2200, 'GBP'),
        ('2024-02-06', 'B', 2300, 'GBP'),
        ('2024-02-06', 'C', 2400, 'GBP'),
;
```

</details>

#### `exchange_rates`

| date       | from_currency | to_currency |     rate |
| :--------- | :------------ | :---------- | -------: |
| 2024-01-01 | GBP           | INR         | 110.0000 |
| 2024-01-01 | GBP           | JPY         | 160.0000 |
| 2024-01-01 | GBP           | USD         |   1.3000 |
| 2024-02-01 | GBP           | INR         | 120.0000 |
| 2024-02-01 | GBP           | JPY         | 170.0000 |
| 2024-02-01 | GBP           | USD         |   1.4000 |
| 2024-03-01 | GBP           | INR         | 100.0000 |
| 2024-03-01 | GBP           | JPY         | 150.0000 |
| 2024-03-01 | GBP           | USD         |   1.2000 |

<details>
<summary>Expand for the object DDL</summary>

```sql
create or replace table exchange_rates(
    "date" date,
    from_currency varchar(3),
    to_currency varchar(3),
    rate decimal(10, 4),
    constraint pk__exchange_rates primary key ("date", from_currency, to_currency),
);
insert into exchange_rates
    values
        ('2024-01-01', 'GBP', 'INR', 110.0),
        ('2024-01-01', 'GBP', 'JPY', 160.0),
        ('2024-01-01', 'GBP', 'USD', 1.3),
        ('2024-02-01', 'GBP', 'INR', 120.0),
        ('2024-02-01', 'GBP', 'JPY', 170.0),
        ('2024-02-01', 'GBP', 'USD', 1.4),
        ('2024-03-01', 'GBP', 'INR', 100.0),
        ('2024-03-01', 'GBP', 'JPY', 150.0),
        ('2024-03-01', 'GBP', 'USD', 1.2),
;
```

</details>

### Finding the USD amount for each transaction (DuckDB)

#### Solution

To find the USD amount for each transaction, we can use the `ASOF` join to find the closest exchange rate to the transaction date:

```sql
select
    transactions.date,
    transactions.account,
    transactions.amount,
    exchange_rates.rate,
    transactions.amount * exchange_rates.rate as amount_usd,
from transactions
    asof left join exchange_rates
        on  transactions.currency = exchange_rates.from_currency
        and exchange_rates.to_currency = 'USD'
        and transactions.date >= exchange_rates.date
order by
    transactions.date,
    transactions.amount
```

| date       | account |  amount |   rate |  amount_usd |
| :--------- | :------ | ------: | -----: | ----------: |
| 2023-12-31 | A       |  100.00 | _null_ |      _null_ |
| 2024-01-01 | B       |  200.00 | 1.3000 |  260.000000 |
| 2024-01-02 | C       |  300.00 | 1.3000 |  390.000000 |
| 2024-01-04 | A       |  400.00 | 1.3000 |  520.000000 |
| 2024-01-07 | B       |  500.00 | 1.3000 |  650.000000 |
| 2024-01-07 | C       |  600.00 | 1.3000 |  780.000000 |
| 2024-01-08 | A       |  700.00 | 1.3000 |  910.000000 |
| 2024-01-10 | B       |  800.00 | 1.3000 | 1040.000000 |
| 2024-01-13 | C       |  900.00 | 1.3000 | 1170.000000 |
| 2024-01-13 | A       | 1000.00 | 1.3000 | 1300.000000 |
| 2024-01-17 | B       | 1100.00 | 1.3000 | 1430.000000 |
| 2024-01-17 | C       | 1200.00 | 1.3000 | 1560.000000 |
| 2024-01-18 | A       | 1300.00 | 1.3000 | 1690.000000 |
| 2024-01-20 | B       | 1400.00 | 1.3000 | 1820.000000 |
| 2024-01-23 | C       | 1500.00 | 1.3000 | 1950.000000 |
| 2024-01-23 | A       | 1600.00 | 1.3000 | 2080.000000 |
| 2024-01-27 | B       | 1700.00 | 1.3000 | 2210.000000 |
| 2024-01-27 | C       | 1800.00 | 1.3000 | 2340.000000 |
| 2024-01-28 | A       | 1900.00 | 1.3000 | 2470.000000 |
| 2024-01-30 | B       | 2000.00 | 1.3000 | 2600.000000 |
| 2024-02-02 | C       | 2100.00 | 1.4000 | 2940.000000 |
| 2024-02-02 | A       | 2200.00 | 1.4000 | 3080.000000 |
| 2024-02-06 | B       | 2300.00 | 1.4000 | 3220.000000 |
| 2024-02-06 | C       | 2400.00 | 1.4000 | 3360.000000 |

Note the `NULL` values for the first transaction -- this is because there is no exchange rate for the date of that transaction in our `exchange_rates` table, and we specified `ASOF LEFT JOIN` so that values without matches are still kept in the result set (like a normal `LEFT JOIN`!).

> [!QUESTION] Exercise
>
> Can you re-write this query using the Snowflake syntax?

<details>
<summary>Expand for the Snowflake equivalent</summary>

```sql
select
    transactions.date,
    transactions.account,
    transactions.amount,
    exchange_rates.rate,
    transactions.amount * exchange_rates.rate as amount_usd,
from transactions
    asof join exchange_rates
        match_condition (transactions.date >= exchange_rates.date)
        on transactions.currency = exchange_rates.from_currency
/* Currently not allowed in `ASOF` join conditions */
where coalesce(exchange_rates.to_currency, 'USD') = 'USD'
order by
    transactions.date,
    transactions.amount
```

</details>

#### "Traditional" solutions

For comparison, here are a few solutions that illustrate how you might solve this problem without the `ASOF` join.

##### Using a lateral join

If your database supports [lateral "joins"](https://duckdb.org/docs/sql/query_syntax/from.html#lateral-joins) (like DuckDB), you can [use a lateral join](https://github.com/timescale/timescaledb/issues/271#issuecomment-865231568) to find the closest exchange rate to the transaction date:

```sql
select
    transactions.date,
    transactions.account,
    transactions.amount,
    rates.rate,
    transactions.amount * rates.rate as amount_usd,
from transactions,
    lateral (
        select rate
        from exchange_rates
        where 1=1
            and transactions.currency = exchange_rates.from_currency
            and exchange_rates.to_currency = 'USD'
            and exchange_rates.date <= transactions.date
        order by exchange_rates.date desc
        limit 1
    ) as rates
order by
    transactions.date,
    transactions.amount
```

Note that this approach would _drop_ the first transaction from the result set because there is no exchange rate for the date of that transaction in our `exchange_rates` table. We'll "fix" this in the next example.

##### Using a left lateral join

To keep the first transaction in the result set when using lateral, we can move the lateral subquery to a left join:

```sql
select
    transactions.date,
    transactions.account,
    transactions.amount,
    rates.rate,
    transactions.amount * rates.rate as amount_usd,
from transactions
    left join lateral (
        select rate
        from exchange_rates
        where 1=1
            and transactions.currency = exchange_rates.from_currency
            and exchange_rates.to_currency = 'USD'
            and exchange_rates.date <= transactions.date
        order by exchange_rates.date desc
        limit 1
    ) as rates on 1=1
order by
    transactions.date,
    transactions.amount
```

##### Using left join and qualify

If your database doesn't have `ASOF` _or_ lateral joins, you can use a left join and the `QUALIFY` clause to find the closest exchange rate to the transaction date:

```sql
select
    transactions.date,
    transactions.account,
    transactions.amount,
    exchange_rates.rate,
    transactions.amount * exchange_rates.rate as amount_usd,
from transactions
    left join exchange_rates
        on  transactions.currency = exchange_rates.from_currency
        and exchange_rates.to_currency = 'USD'
        and exchange_rates.date <= transactions.date
qualify 1 = row_number() over (
    partition by transactions.date, transactions.account
    order by exchange_rates.date desc
)
order by
    transactions.date,
    transactions.amount
```

If you're using a database that doesn't support the `QUALIFY` clause, you can wrap the query in a subquery with the `ROW_NUMBER()` calculation saved to a column and filter on the column in the outer query.

##### Using a left join and correlated subquery

If your database doesn't have `ASOF` joins, lateral joins, _or_ the `QUALIFY` clause (and you don't want to use `ROW_NUMBER()` in a subquery), you can use a correlated subquery:

```sql
select
    transactions.date,
    transactions.account,
    transactions.amount,
    exchange_rates.rate,
    transactions.amount * exchange_rates.rate as amount_usd
from transactions
    left join exchange_rates
        on  transactions.currency = exchange_rates.from_currency
        and exchange_rates.to_currency = 'USD'
        and exchange_rates.date <= transactions.date
where 0=1
    or exchange_rates.date is null
    or exchange_rates.date = (
        select max("date")
        from exchange_rates as rates_inner
        where 1=1
            and exchange_rates.from_currency = rates_inner.from_currency
            and exchange_rates.to_currency = rates_inner.to_currency
            and rates_inner.date <= transactions.date
    )
order by
    transactions.date,
    transactions.amount
```

Note that, since this _specific_ example, is only using the `rate` column from the `exchange_rates` table, we could have evaluated the subquery in the `SELECT` clause instead of the `FROM` clause. However, this would not work if we needed to use more than one column from the `exchange_rates` table, hence sticking to approaches that cater for multiple columns.

## Wrap up

Like with most SQL problems, there are multiple ways to get the output that we want. The `ASOF` join is just a great way to solve this particular problem, and it significantly reduces the complexity of our SQL code!

Note that, also like with most SQL problems, the performance of these queries will depend on the size of the tables and the indexes available. If you're working with large tables, you will need to consider the performance implications of the `ASOF` approach compared to more "traditional" approaches.
