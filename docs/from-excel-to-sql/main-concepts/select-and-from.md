# Gimme data 📁

> [!SUCCESS]
>
> Now you know that SQL is a language for getting data from a database, let's actually get some data!

> [!NOTE]
>
> From here on, we'll be using a [Microsoft SQL Server](https://www.microsoft.com/en-gb/sql-server/sql-server-downloads) database filled with the [AdventureWorks](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure) data. If you want to follow along, you can use the [dbfiddle](https://dbfiddle.uk/rKIFRoNm) site to run the queries against the same data:
>
> - [https://dbfiddle.uk/rKIFRoNm](https://dbfiddle.uk/rKIFRoNm)
>
> Alternatively, follow the instructions [linked in the homepage](../../from-excel-to-sql/from-excel-to-sql.md#the-toolsdata-in-this-course):
>
> - [Introduction to SQL Programming for Excel Users - SQL Server Windows Setup](https://youtu.be/VnJAgND_iLc?si=LduWGyoKy069NP-L)

## `SELECT` and `FROM` are how you "open a file"

If you wanted to get some data from an Excel file, you'd navigate through your folders, open the file, and then click on the sheet that has the data you want.

To do the same thing in SQL, we need to write the `SELECT` and `FROM` clauses:

- `SELECT` tells the database that we want to see some data
- `FROM` tells the database where to get the data from

Although your Excel file might live inside nested folders, SQL databases are a bit more structured.

For the most part, there's only one depth of "folders" which we call the _schema_.

The AdventureWorks database has several of these folders/schemas, which each contains tables. The folders/schemas in the AdventureWorks database are:

- `dbo` (this is a special folder/schema which you can ignore for now)
- `HumanResources`
- `Person`
- `Production`
- `Purchasing`
- `Sales`

Each of these folders/schemas contains a bunch of tables, and we will need to specify both the folder/schema _and_ the table in the `FROM` clause.

For example, the `Person` folder/schema contains a `Person` table (yes, the folder/schema and table are called the same thing 😝), so we would write `Person.Person` in the `FROM` clause to "open that file":

```sql
SELECT BusinessEntityID, FirstName, LastName
FROM Person.Person
;
```

Writing the query is the first part -- to actually get some data, we then need to run the query!

The first few rows from the result of this query are:

| BusinessEntityID | FirstName | LastName   |
| ---------------: | :-------- | :--------- |
|                1 | Ken       | Sánchez    |
|                2 | Terri     | Duffy      |
|                3 | Roberto   | Tamburello |
|                4 | Rob       | Walters    |
|                5 | Gail      | Erickson   |

> [!TIP]
>
> Remember that SQL "sounds like" English, so the query above can be read as:
>
> > "**Select** the **business entity ID**, **first name**, and **last name from** the **`Person.Person`** table".

> [!NOTE]
>
> The `FROM` clause _always_ comes after the `SELECT` clause.

## Specify `*` or column names in the `SELECT` clause

The `Person.Person` table has a bunch of columns, but we only asked for three of them in the `SELECT` clause.

To see more columns, we would just add them to the `SELECT` clause:

```sql
SELECT
    BusinessEntityID,
    PersonType,
    Title,
    FirstName,
    MiddleName,
    LastName
FROM Person.Person
;
```

| BusinessEntityID | PersonType | Title  | FirstName | MiddleName | LastName   |
| ---------------: | :--------- | :----- | :-------- | :--------- | :--------- |
|                1 | EM         | _null_ | Ken       | J          | Sánchez    |
|                2 | EM         | _null_ | Terri     | Lee        | Duffy      |
|                3 | EM         | _null_ | Roberto   | _null_     | Tamburello |
|                4 | EM         | _null_ | Rob       | _null_     | Walters    |
|                5 | EM         | Ms.    | Gail      | A          | Erickson   |

To see _all_ the columns without listing them all explicitly, we can use the `*` character in the `SELECT` clause. The `*` character is a wildcard that means "all columns":

```sql
SELECT *
FROM Person.Person
;
```

> [!TIP]
>
> We read `*` as "all columns" or "everything", so the query above can be read as:
>
> > "**Select all columns from** the **`Person.Person`** table".

There are lots of columns in the `Person.Person` table, so we won't show the result here. If you're following along, you can run the query on the [dbfiddle](https://dbfiddle.uk/rKIFRoNm) site to see the result.

- ✅ The advantage of using the `*` character is that you don't need to know the names of the columns in the table
- ❌ The disadvantage is that you might get _more_ columns than you need, which can make the result harder to read and use.

When you write SQL, it's up to you whether you use the `*` character or list the columns explicitly. There are some best practices depending on the situation, but they won't be covered in this course.

Note that you can also specify the same column multiple times in the `SELECT` clause if you want. The example below is a silly one to prove this, but we'll see more practical examples later:

```sql
SELECT
    BusinessEntityID,
    BusinessEntityID,
    BusinessEntityID
FROM Person.Person
;
```

| BusinessEntityID | BusinessEntityID | BusinessEntityID |
| ---------------: | ---------------: | ---------------: |
|                1 |                1 |                1 |
|                2 |                2 |                2 |
|                3 |                3 |                3 |
|                4 |                4 |                4 |
|                5 |                5 |                5 |

## Use `AS` to "rename" columns

The `AS` keyword is used to rename/alias columns in the `SELECT` clause. Just write `AS` followed by the new name that you want to give the column:

```sql
SELECT
    BusinessEntityID AS ID,
    FirstName AS Forename,
    LastName AS Surname
FROM Person.Person
;
```

|  ID | Forename | Surname    |
| --: | :------- | :--------- |
|   1 | Ken      | Sánchez    |
|   2 | Terri    | Duffy      |
|   3 | Roberto  | Tamburello |
|   4 | Rob      | Walters    |
|   5 | Gail     | Erickson   |

The `AS` keyword should also be used after any calculations to give the calculated column a name. We'll see examples of this later.

> [!TIP]
>
> The `AS` keyword continues to "sound like" English -- the query above can be read as:
>
> > "**Select** the **business entity ID as id**, the **first name as forename**, and the **last name as surname from** the **`Person.Person`** table".

> [!INFO]
>
> The `AS` keyword is optional when you're renaming columns, but it's a good idea to use it for clarity. It's clearer and easier to read `BusinessEntityID AS ID` than `BusinessEntityID ID`!

## `FROM` is optional

> [!TIP]
>
> The `FROM` clause is only required when you're getting data from a table. If you're not getting data from a table, you can leave it out.

Although you would use the `FROM` clause in most situations, it's worth knowing that it's optional. If you write `SELECT` without a `FROM` clause, the SQL will return a single row with the value(s) that you specify:

```sql
SELECT
    'This is some text' AS SOME_TEXT,
    123 AS SOME_NUMBER
;
```

| SOME_TEXT         | SOME_NUMBER |
| :---------------- | ----------: |
| This is some text |         123 |

## You can use the `INFORMATION_SCHEMA` to see what's in the database

> [!WARNING]
>
> This is slightly more advanced, but it's a useful trick to know about.

The hardest part about SQL compared to Excel is that you can't just click around to see what's available -- when you write a query, you need to know what's in the database.

However, most databases hold some special default tables that keep track of what's in the database. The `INFORMATION_SCHEMA` is a special folder/schema that holds these tables.

To see the tables in the database, you can check the `TABLES` table in the `INFORMATION_SCHEMA`:

```sql
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
;
```

| TABLE_SCHEMA   | TABLE_NAME             |
| :------------- | :--------------------- |
| Sales          | SalesTaxRate           |
| Sales          | PersonCreditCard       |
| Person         | vAdditionalContactInfo |
| Person         | PersonPhone            |
| HumanResources | vEmployee              |

To see the columns in the tables, you can check the `COLUMNS` table in the `INFORMATION_SCHEMA`:

```sql
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
;
```

| TABLE_SCHEMA | TABLE_NAME             | COLUMN_NAME      |
| :----------- | :--------------------- | :--------------- |
| Sales        | PersonCreditCard       | BusinessEntityID |
| Sales        | PersonCreditCard       | CreditCardID     |
| Sales        | PersonCreditCard       | ModifiedDate     |
| Person       | vAdditionalContactInfo | BusinessEntityID |
| Person       | vAdditionalContactInfo | City             |
| Person       | vAdditionalContactInfo | CountryRegion    |

> [!TIP]
>
> When you first start using a new database, you might find these queries useful to see what's available.
>
> The Microsoft SQL Server documentation for this `INFORMATION_SCHEMA` folder/schema is available at:
>
> - [https://learn.microsoft.com/en-us/sql/relational-databases/system-information-schema-views/system-information-schema-views-transact-sql](https://learn.microsoft.com/en-us/sql/relational-databases/system-information-schema-views/system-information-schema-views-transact-sql)

## Further reading

Check out the [official Microsoft documentation](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-transact-sql) for more information on the `SELECT` and `FROM` clauses at:

- [https://learn.microsoft.com/en-us/sql/t-sql/queries/select-clause-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-clause-transact-sql)
- [https://learn.microsoft.com/en-us/sql/t-sql/queries/select-examples-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-examples-transact-sql)
