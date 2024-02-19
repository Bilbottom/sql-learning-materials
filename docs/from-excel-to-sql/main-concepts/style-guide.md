# Style guide ✨

> [!SUCCESS]
>
> Although SQL is super flexible in how you write it, it's a good idea to stick to a consistent style.
>
> This makes it easier for others to read your code which is especially important when you're working in a team or when you're sharing your code with others.

## SQL style is a contentious topic...

Anyone who has written SQL for a little while will find the style that they like, and they'll typically want to stick to it (for better or worse) 😝

There are plenty of conflicting styles out there, so this guide is just to recommend the style for things that _most_ people agree on.

## Some general rules

### Use consistent capitalisation

The capitalisation that you use for your column names and table names should match their case in the database.

For example, the AdventureWorks database uses [Pascal case](https://en.wiktionary.org/wiki/Pascal_case#English) for its table names, so you should use Pascal case in your SQL:

```sql
/* Good */
SELECT FirstName, LastName
FROM Person.Person
WHERE BusinessEntityID < 5
;

/* Bad */
SELECT firstName, LASTNAME
FROM person.PERSON
WHERE businessentityid < 5
;
```

The capitalisation that you use for your SQL keywords (e.g. `SELECT`, `FROM`, `WHERE`) should be consistent, and should match the standards of your team (if you have one).

```sql
/* Good, if your team use uppercase */
SELECT FirstName, LastName
FROM Person.Person
WHERE BusinessEntityID < 5
;

/* Good, if your team use lowercase */
select FirstName, LastName
from Person.Person
where BusinessEntityID < 5
;

/* Bad */
SELECT FirstName, LastName
from Person.Person
WhEre BusinessEntityID < 5
;
```

### Put new clauses on new lines

The main clauses (e.g. `SELECT`, `FROM`, `WHERE`) should be on new lines:

```sql
/* Good */
SELECT FirstName, LastName
FROM Person.Person
WHERE BusinessEntityID < 5
;

/* Bad */
SELECT FirstName, LastName FROM
Person.Person WHERE
BusinessEntityID < 5;

/* Bad */
SELECT FirstName, LastName FROM Person.Person WHERE BusinessEntityID < 5;
```

### Put lists on indented new lines

For long lists of items (the length of "long" is contentious), put each item on a new line and indent it:

```sql
/* Good */
SELECT
    BusinessEntityID,
    PersonType,
    Title,
    FirstName,
    MiddleName,
    LastName
FROM Person.Person
WHERE BusinessEntityID < 20
  AND PersonType = 'EM'
  AND MiddleName IS NOT NULL
  AND EmailPromotion = 2
;

/* Bad */
SELECT BusinessEntityID, PersonType, Title, FirstName, MiddleName, LastName
FROM Person.Person
WHERE BusinessEntityID < 20 AND PersonType = 'EM' AND MiddleName IS NOT NULL AND EmailPromotion = 2
;
```

## Further reading

There are several publicly available style guides for SQL. It's worth having a look at a few of them to see what you like and what you don't like:

- [https://handbook.gitlab.com/handbook/business-technology/data-team/platform/sql-style-guide/](https://handbook.gitlab.com/handbook/business-technology/data-team/platform/sql-style-guide/)
- [https://docs.telemetry.mozilla.org/concepts/sql_style](https://docs.telemetry.mozilla.org/concepts/sql_style)
- [https://www.sqlstyle.guide/](https://www.sqlstyle.guide/)

Once you're up to speed with SQL and looking to integrate some additional tools, you might want to check out SQLFluff which is a tool that will reformat your SQL into a consistent style for you:

- [https://sqlfluff.com/](https://sqlfluff.com/)
