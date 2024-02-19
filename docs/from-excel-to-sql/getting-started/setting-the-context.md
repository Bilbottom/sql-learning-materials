# Setting the context 🤔

## What _the fudge_ is SQL?

> [!SUCCESS]
>
> SQL stands for Structured Query Language.

SQL is [a programming language oriented around data](https://en.wikipedia.org/wiki/SQL). The confusing part about SQL is that it isn't _one_ language: there are _loads_ of different "flavours" of SQL!

### Spreadsheets and SQL

To help make this a bit more relatable, think about the general concept of a "spreadsheet".

This is a general concept because there are lots of different "implementations" of spreadsheet software, for example:

- [Microsoft Excel](https://www.microsoft.com/en-gb/microsoft-365/excel)
- [Google Sheets](https://www.google.co.uk/sheets/about/)
- [Apple Numbers](https://www.apple.com/uk/numbers/)
- [LibreOffice](https://www.libreoffice.org/)

SQL is also a general concept; there are loads of different "implementations" of SQL, for example:

- [Microsoft SQL Server](https://www.microsoft.com/en-gb/sql-server/sql-server-downloads)
- [Google BigQuery](https://cloud.google.com/bigquery)
- [PostgreSQL](https://www.postgresql.org/download/)
- [MySQL](https://www.mysql.com/)

> [!TIP]
>
> If someone claims that they're a "SQL wiz", always ask them "which flavour?" 😝

### What does SQL do?

The point of SQL is to interact with data that lives in a ["database"](https://en.wikipedia.org/wiki/Database).

Since SQL is a programming language, you write some code, then you run it. Running SQL code means running it on this "database", and we usually call the SQL code a "query".

The reason that we have so many different flavours of SQL is because each one is specific to the database that it's running on.

If you want to write SQL on your own machine, you'll need to install a database. This is just like needing to install a spreadsheet application (e.g. Excel) to work with spreadsheets 😋

## What _the fudge_ is a database?

> [!SUCCESS]
>
> A database is just some software that stores and manipulates data.

There are a few different types of databases, but SQL is designed for databases that store their data as tables. This makes these types of databases very familiar to us: they're like spreadsheets!

### Database tables are like Excel tables

One of the awesome things about spreadsheets is that the sheets are super flexible, and you can have data pretty much wherever you want.

Databases are a bit more rigid. The tables in databases are like the tables in spreadsheets, with a few key differences -- the most important differences to know are:

- Database tables cannot have merged cells
- Columns in database tables have a specific data type ([more on this later](../main-concepts/data-types.md))

Database tables are very similar to the table structures in Excel that you create with the "_Format as Table_" feature:

- [https://support.microsoft.com/en-gb/office/bf0ce08b-d012-42ec-8ecf-a2259c9faf3f](https://support.microsoft.com/en-gb/office/bf0ce08b-d012-42ec-8ecf-a2259c9faf3f)

It'll be important to understand these Excel "tables" as we go through this course, so if you're not familiar with them, it's worth checking out the link above or the one below:

- [https://exceljet.net/articles/excel-tables](https://exceljet.net/articles/excel-tables)

## Why _the fudge_ should you use SQL?

> [!SUCCESS]
>
> SQL is _everywhere_!

If you're looking to move into a more data-oriented role (e.g. data analyst, data scientist, data engineer, analytics engineer), SQL is a _must-have_ skill.

Even if you're just looking to find ways to improve your existing role, knowing SQL can empower you to crunch more data, streamline/automate more processes, and generally make your life easier.
