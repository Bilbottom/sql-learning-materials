# SQL syntax 📚

> [!SUCCESS]
>
> _Syntax_ is the set of rules that define how you write in a programming language.

SQL has a very flexible [syntax](<https://en.wikipedia.org/wiki/Syntax_(programming_languages)>) which is _heavily_ based on the English language. This makes it easy to read and write, but it also means that there are many ways to write the same thing.

We'll go through a lot of the specifics in the following sections, but here are some general rules to get you started.

## SQL "sounds like" English

> [!INFO]
>
> At least, for simple queries 😝

Consider the following SQL statement (we'll go through what this means in the next sections):

```sql
SELECT first_name, last_name
FROM employees
WHERE department = 'Sales'
```

This reads closely to the English sentence:

> "**Select** _the_ **first name** _and_ **last name from** _the_ **employees** **where** _the_ **department is Sales**"

The only words that we've dropped from the English version of the sentence are "_the_" and "_and_"!

This is a basic example, but it's a good way to think about writing SQL when you're starting out. If it sounds like English, you're probably on the right track.

## Whitespace and capitalisation are (mostly) ignored

> [!NOTE]
>
> Some databases ("SQL flavours") are stricter about this than others, but most of the time they won't care about how you add whitespace or capitalise your letters.

For the most part, SQL doesn't care about whitespace (spaces, tabs, new lines) or capitalisation. This means that all the following are equivalent:

```sql
SELECT first_name, last_name
FROM employees
WHERE department = 'Sales'
```

```sql
select first_name, last_name from employees where department = 'Sales'
```

```sql
SELECT
FIRST_NAME,
LAST_NAME
FROM
EMPLOYEES
WHERE
DEPARTMENT
=
'Sales'
```

```sql
                             SeLeCt FiRsT_NaMe
,
                lAsT_nAmE
    FrOm

         eMpLoyEEs WhErE
                 dEpaRTmEnT

=
                                    'Sales'
```

Of course, some of these are easier to read than others, so it's generally a good idea to use whitespace and capitalisation to make your SQL easier to read. Some choices are totally down to your opinion, we'll go through some best practices in [the style guide section](../main-concepts/style-guide.md) to help you choose a style that you like.

## Semicolons are (mostly) optional

> [!NOTE]
>
> Semicolons are generally only required when you have multiple SQL statements in the same file (or when you're using a database/SQL flavour that requires them).

Semicolons (`;`) are used to explicitly end a SQL statement. This is useful when you have multiple SQL statements in the same file, but it's not always required.

Ending your SQL with a semicolon is a good habit to get into, but it's unlikely to be mandatory for the SQL that you write.

```sql
SELECT first_name, last_name
FROM employees
WHERE department = 'Sales'
;
```

## Text needs to be put in single quotes

Just like in Excel, any text needs to be enclosed in quotes in SQL. The only difference is that the quotes that you use are single quotes, `'`, _not_ double quotes, `"`.

The quotes are used to tell the database that the text is text, and not a column name or a keyword.

SQL also treats dates differently to Excel; we "pretend" that dates are some text and put them in single quotes. In general, dates need to be specified in the universal date format, `YYYY-MM-DD`.

- `123` is an example of a number in SQL
- `'abc'` is an example of text in SQL
- `'2020-01-01'` is an example of a date in SQL

## We use some specific words to describe SQL elements

It's worth mentioning some of the specific words that we use to describe the elements of SQL. We'll use the example above to explain these terms, plus some other bits that we'll see later:

- **Keywords** are the words that are specific to SQL and have a special meaning. For example, the following are all keywords:
  - `SELECT`
  - `FROM`
  - `WHERE`
  - `AND`
  - `OR`
  - `ON`
- **Identifiers** are the names of the tables, columns, and other objects in your database. For example, the following are all identifiers:
  - `employees`
  - `first_name`
  - `last_name`
  - `department`
- **Operators** are the symbols that you use to compare or manipulate data. For example, the following are all operators:
  - `+`
  - `-`
  - `=`
  - `>`
  - `<`
- **Clauses** are the different parts of an SQL statement made up of keywords, identifiers, and any other text. For example, the following are all clauses:
  - `SELECT first_name, last_name`
  - `FROM employees`
  - `WHERE department = 'Sales'`
- **Statements** or **queries** are the complete SQL commands that you write. For example, the following is a statement/query:
  - `SELECT first_name, last_name FROM employees WHERE department = 'Sales'`
- **Result** or **result set** is the data that comes back from the database when you run a query (more on this in [the next section](../main-concepts/select-and-from.md)). For example, the following is a result set:

| first_name | last_name | department |
| :--------- | :-------- | :--------- |
| John       | Smith     | Sales      |
| Jane       | Doe       | Sales      |
