# SQL-92 (ANSI-SQL join syntax) 📝

> [!SUCCESS]
>
> The [ANSI SQL-92 standard](https://www.contrib.andrew.cmu.edu/~shadow/sql/sql1992.txt), introduced in 1992, defined the standard syntax for joins in SQL.

> [!SUCCESS]
>
> ANSI is the [American National Standards Institute](https://www.ansi.org/), and they are responsible for defining the SQL standard. Note that they aren't responsible for _implementing_ the standard since they don't build SQL software (as part of the ANSI role) -- that's up to the database vendors.

## Joins before SQL-92

### Non-ANSI join

In the early days of SQL, the `JOIN` clause didn't exist. Instead, we had to list the tables we wanted to join in the `FROM` clause and then specify the join condition in the `WHERE` clause.

For example, to join an `employees` table with a `departments` tables, we might have written:

```sql
select *
from employees, departments
where employees.department_id = departments.department_id
```

When tables are listed in the `FROM` clause, they're combined using an equivalent of the `CROSS JOIN` that we're familiar with today. This is why we specify the join condition in the `WHERE` clause: we start with all rows paired with all rows and then filter down to only the rows that we want associated.

This also has an important implication: this join is specifically an _inner_ join.

So, how do we do an _outer_ join?

### Non-ANSI outer joins

Performing an outer join prior to SQL-92 syntax was a bit more complicated, and it depended on the database you were using.

Note that the "outer" joins are the `LEFT`, `RIGHT`, and `FULL` joins that we're familiar with today.

#### Using `(+)`

Prior to SQL-92 syntax, you could use the `(+)` operator to indicate that you wanted to perform an outer join. The `(+)` operator was placed on the side of the join that you wanted to be the "outer" side.

For example, to perform a left join, you might have written:

```sql
select *
from employees, departments
where employees.department_id = departments.department_id (+)
```

Since the `(+)` operator was placed on the `departments` side, this query would return all rows from the `employees` table, even if there was no matching row in the `departments` table.

This would also work for a right join: just place the `(+)` operator on the `employees` side.

However, to perform a full join, we can't just use the `(+)` operator on both sides of the condition. Instead, we have to use the `(+)` operator in both directions:

```sql
    select
        employees.employee_id,
        employees.department_id,
        departments.department_name
    from employees, departments
    where employees.department_id = departments.department_id (+)
union
    select
        employees.employee_id,
        departments.department_id,
        departments.department_name
    from employees, departments
    where departments.department_id = employees.department_id (+)
```

#### Using `*=` and `=*`

Another syntax used before SQL-92 syntax was to use the `*=` or `=*` operators instead of `=` to indicate an outer join.

For these, `=*` implements a left join and `*=` implements a right join. Therefore, to perform a left join with these operators, you might have written:

```sql
select *
from employees, departments
where employees.department_id =* departments.department_id
```

The right join and full join would be similar to the `(*)` versions, but with the `*=` operator instead.

## Non-ANSI concepts influenced SQL-92

Since SQL joins started off as inner joins, it was convenient at the time to describe what we now understand as `LEFT`, `RIGHT`, and `FULL` joins as "outer" joins.

This translated into the SQL-92 standard. Each of these joins can optionally include the `OUTER` keyword:

- `LEFT OUTER JOIN`
- `RIGHT OUTER JOIN`
- `FULL OUTER JOIN`

This is to acknowledge that these join types are different to the default `INNER JOIN`.

However, thirty years later, the `OUTER` keyword is redundant. It's still supported in most databases, but there is no value in including it in your queries (in my opinion) because we have more explicit ways of defining the join type.

Instead, I recommend that you:

- Always write `INNER JOIN` instead of `JOIN`
- Always write `LEFT JOIN` instead of `LEFT OUTER JOIN`
- Always write `RIGHT JOIN` instead of `RIGHT OUTER JOIN`
- Always write `FULL JOIN` instead of `FULL OUTER JOIN`
- Prefer `LEFT JOIN` over `RIGHT JOIN` unless you have a specific reason to use a right join

This will make your queries more readable and maintainable because the text you write for joins is always two words unless you add the `NATURAL` or `ASOF` modifiers, so it's easy to scan for the join type:

- `LEFT JOIN`
- `RIGHT JOIN`
- `FULL JOIN`
- `INNER JOIN`
- `CROSS JOIN`

When you see three words, you know that the join has a modifier:

- `ASOF LEFT JOIN`
- `NATURAL INNER JOIN`
