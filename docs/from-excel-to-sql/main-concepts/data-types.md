# Data types 🧱

> [!SUCCESS]
>
> Understanding data types is a fundamental part of working with SQL.

> [!WARNING]
>
> This is one of the biggest differences between Excel and SQL. In Excel, you can just type whatever you want into a cell, and it will be interpreted as a number, a date, or some text appropriately.
>
> In SQL, each column will have an explicit type of data that it can hold.

## There are lots of data types

When we work with Excel, we really only think about two (maybe three) types of data:

- Numbers
- Text
- Dates (but these are really numbers, anyway)

In SQL database, there are _loads_ of different data types!

Even something like numbers has several different data types, each covering a different range of numbers and whether to care about decimal places.

This might feel like a pain, but SQL databases are able to do some things so well precisely because we have to be explicit about the data types. We won't go into _why_ in this course, but just know that it's a good thing!

### Microsoft SQL Server data types

> [!WARNING]
>
> You are not expected to understand this straight away. This is just to give you an idea of the variety of data types that are available.

The data types that Microsoft SQL Server has (be default) are all documented at:

- [https://learn.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql)

We'll just call out a few of the most common ones here so that you can get a feel for what's available and start to recognise them.

| Data type    | Description                                                                                                        |
| ------------ | ------------------------------------------------------------------------------------------------------------------ |
| `INT`        | Whole numbers (no decimal places) in the range -2,147,483,648 to 2,147,483,647 (-2^31^ to 2^31^ - 1)               |
| `DECIMAL`\*  | Numbers with decimal places. When maximum precision is used, valid values are from -10^38^ + 1 through 10^38^ - 1. |
| `VARCHAR`\*  | Variable-length string of text. Maximum length is specified.                                                       |
| `NVARCHAR`\* | Variable-length string of text that allows unicode characters. Maximum length is specified.                        |
| `DATE`       | Date values in the range 0001-01-01 through 9999-12-31.                                                            |
| `TIME`       | Time values in the range 00:00:00.0000000 through 23:59:59.9999999.                                                |
| `DATETIME`   | Date and time values in the range 1753-01-01 through 9999-12-31.                                                   |

> [!NOTE]
>
> The data types denoted with the `*` also require specifying a precision and scale (if they're a type of number) or a length (if they're a type of text).
>
> For example:
>
> - `DECIMAL(10, 2)` would be a number with 10 total digits and 2 decimal places (so 8 digits before the decimal place).
> - `VARCHAR(50)` would be a string of text with a maximum length of 50 characters.

If you're not sure what data type the column you're working with is, you can check the `INFORMATION_SCHEMA.COLUMNS` table to see the data types of the columns in a table. For example, the query below shows the data types of the columns in the `HumanResources.Department` table:

```sql
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'HumanResources'
  AND TABLE_NAME = 'Department'
;
```

| COLUMN_NAME  | DATA_TYPE |
| :----------- | :-------- |
| DepartmentID | smallint  |
| Name         | nvarchar  |
| GroupName    | nvarchar  |
| ModifiedDate | datetime  |

## Use the `CAST` function to change data types

Now that we know what data types are available, we want to know how to change the data type of a column 😄

It's worth noting that SQL will regularly do behind-the-scenes conversions of data types for you, but it's good to be explicit about what you're doing.

When you want (or need) to be explicit about the data type of a column, use the `CAST` function:

- [https://learn.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql)

This function looks a bit different to the functions that we'll have seen so far or in Excel. To use it, we write the column that we want to change the data type of, then the `AS` keyword, then the new data type that we want to change it to.

For example, if we want to change the `DepartmentID` column to text or to a number with decimal places, we could use the following query:

```sql
SELECT TOP 5
    DepartmentID,
    CAST(DepartmentID AS VARCHAR(10)) AS DepartmentID_VARCHAR,
    CAST(DepartmentID AS DECIMAL(8, 2)) AS DepartmentID_DECIMAL
FROM HumanResources.Department
;
```

| DepartmentID | DepartmentID_VARCHAR | DepartmentID_DECIMAL |
| -----------: | :------------------- | -------------------: |
|           12 | 12                   |                12.00 |
|            1 | 1                    |                 1.00 |
|           16 | 16                   |                16.00 |
|           14 | 14                   |                14.00 |
|           10 | 10                   |                10.00 |

The text version looks the same, but I can guarantee that it's not a number any more! 😝

> [!NOTE]
>
> After using Excel for so long, this might feel a bit weird -- but Excel will sometimes hold numbers as text, and it's not always obvious when it's doing that.
>
> You can store a number as text yourself in Excel in loads of ways, for example using `="123"`, `='123`, or just typing `123` into a cell that's formatted as text.

### What about casting something that can't be converted?

If you try to cast a value to a data type that it can't be converted to, you'll get an error.

For example, the following will break:

```sql
SELECT CAST('abc' AS INT)
;
```

SQL doesn't know how to convert the text `'abc'` into a number, so it will complain!

## `NULL` is a special value that can be used in any data type

> [!WARNING]
>
> `NULL` values can be a pain to work with, but they're a fundamental part of SQL. It's worth getting to grips with them early on.

`NULL` is a special value that can be used in any data type. It's used to represent the absence of a value, and it's different to `0`, `''`, or any other value that you might use to represent "nothing".

Excel has a similar concept, but it's not as explicit as it is in SQL. In Excel, your cells can be empty, and this is similar to `NULL` in SQL. An empty cell is not the same as a cell with a value of `0` or `""`!

### What's this mysterious `''`/`""`?

This is known as the "empty string", and Excel has it too -- `''` is the SQL version and `""` is the Excel version.

It's a piece of text that has no characters in it. 😄

It's not the same as `NULL`, but it's also not the same as a string of text with a space in it!

> [!WARNING]
>
> If you've not seen this before, don't worry too much about it. It's just something to be aware of.

### `NULL` vs `''` vs `0`

The concept of a `NULL` value doesn't exist only in SQL, so when people start to learn about it for the first time, you'll usually see an image like the one below shown to help explain it:

[![](https://i.stack.imgur.com/T9M2J.png)](https://cseducators.stackexchange.com/a/6981)

Humour aside, it's a good way to think about it. `NULL` is not the same as `''` or `0`; rather than saying that something is "empty" or "zero", it's saying that there's no value there _at all_.

## Further reading

Check out the [official Microsoft documentation](https://learn.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql) for more information on data types at:

- [https://learn.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql)

The docs for `NULL` are at:

- [https://learn.microsoft.com/en-us/sql/t-sql/language-elements/null-and-unknown-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/null-and-unknown-transact-sql)

The video version of this content is also available at:

- https://youtu.be/Vp40VH4_OX8
