# Date formatting 📆

> [!SUCCESS]
>
> Formatting dates in SQL is very similar to formatting dates in Excel -- the `FORMAT` function is SQL's equivalent of the `TEXT` function in Excel.

> [!INFO]
>
> I'm from the UK so I've used UK date formats in the examples, but you can find US date formats in the [Microsoft SQL Server documentation](https://learn.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql#date-and-time-styles).

## Formatting dates in Excel

You may have noticed that different systems/tools deal with dates differently. Excel stores dates as numbers where the number corresponds to how many days have passed since 1899-12-31:

- The date 1900-01-01 is the number 1
- The date 1900-02-01 is the number 32
- The date 2024-01-01 is the number 45292

| Date       | Number |     Excel Formula |
| :--------- | :----- | ----------------: |
| 1900-01-01 | 1      |  `=TEXT(A1, "#")` |
| 1900-01-02 | 2      |  `=TEXT(A2, "#")` |
| 1900-01-03 | 3      |  `=TEXT(A3, "#")` |
| ...        | ...    |                   |
| 1900-01-31 | 31     |  `=TEXT(A5, "#")` |
| 1900-02-01 | 32     |  `=TEXT(A6, "#")` |
| 1900-02-02 | 33     |  `=TEXT(A7, "#")` |
| ...        | ...    |                   |
| 2024-01-01 | 45292  |  `=TEXT(A9, "#")` |
| 2024-01-02 | 45293  | `=TEXT(A10, "#")` |
| 2024-01-03 | 45294  | `=TEXT(A11, "#")` |

This has many convenient implications, such as adding 1 to a date increases it by 1 day.

### SQL dates are different to Excel dates

SQL databases store dates differently, so applying the usual Excel-type logic to dates in SQL, such as adding the number 1 to a date won't work (in Microsoft SQL Server).

Manipulating dates in SQL is outside the scope of this course, but it's worth getting up to speed with some of the date manipulation functions such as:

- [`DATEADD`](https://learn.microsoft.com/en-us/sql/t-sql/functions/dateadd-transact-sql) for adding to or subtracting from dates
- [`DATEDIFF`](https://learn.microsoft.com/en-us/sql/t-sql/functions/datediff-transact-sql) for finding the difference between two dates
- [`DATEPART`](https://learn.microsoft.com/en-us/sql/t-sql/functions/datepart-transact-sql) for extracting parts of a date (year, quarter, day of year, etc.)
- [`YEAR`](https://learn.microsoft.com/en-us/sql/t-sql/functions/year-transact-sql), [`MONTH`](https://learn.microsoft.com/en-us/sql/t-sql/functions/month-transact-sql), and [`DAY`](https://learn.microsoft.com/en-us/sql/t-sql/functions/day-transact-sql) which are specific versions of `DATEPART`

## Formatting dates in SQL

Although this course won't cover date manipulation, it will cover formatting dates. The two main functions to use for this are:

- [`CONVERT`](https://learn.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql) which is good for formatting dates using pre-defined styles
- [`FORMAT`](https://learn.microsoft.com/en-us/sql/t-sql/functions/format-transact-sql) which is good for formatting dates using custom styles

These functions are used in slightly different ways.

### `CONVERT` has three parameters and has some pre-defined styles

For [`CONVERT`](https://learn.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql), you need to specify three parameters:

1. The data type that you want to convert your data into, e.g. `VARCHAR`
2. The data that you want to convert, e.g. `SOME_DATE_COLUMN`
3. The style that you want to use, e.g. `103` for `dd/MM/yyyy`

The styles that you can use are all documented in the Microsoft SQL Server documentation:

- [https://learn.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql#date-and-time-styles](https://learn.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql#date-and-time-styles)

Here's an example of using `CONVERT` to format some order dates:

```sql
SELECT DISTINCT TOP 5
    OrderDate,
    CONVERT(VARCHAR, OrderDate, 101) AS OrderDateFormatted
FROM Sales.SalesOrderHeader
;
```

| OrderDate               | OrderDateFormatted |
| :---------------------- | :----------------- |
| 2011-05-31 00:00:00.000 | 05/31/2011         |
| 2011-06-01 00:00:00.000 | 06/01/2011         |
| 2011-06-02 00:00:00.000 | 06/02/2011         |
| 2011-06-03 00:00:00.000 | 06/03/2011         |
| 2011-06-04 00:00:00.000 | 06/04/2011         |

### `FORMAT` has two (required) parameters and is good for custom styles

For [`FORMAT`](https://learn.microsoft.com/en-us/sql/t-sql/functions/format-transact-sql), you need to specify two parameters:

1. The data that you want to format, e.g. `SOME_DATE_COLUMN`
2. The style that you want to use, e.g. `MM/dd/yyyy`

Similar to Excel, there are pre-defined characters which correspond to different parts of the date. For example, `MM` is the month, `dd` is the day, and `yyyy` is the year.

These pre-defined characters are different to Excel's characters and, unlike Excel's, are case-sensitive -- you can find the SQL characters in the Microsoft SQL Server documentation:

- [https://learn.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings#table-of-format-specifiers](https://learn.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings#table-of-format-specifiers)

Here's an example of using `FORMAT` to format some order dates:

```sql
SELECT DISTINCT TOP 5
    OrderDate,
    FORMAT(OrderDate, 'MM/dd/yyyy') AS OrderDateFormatted
FROM Sales.SalesOrderHeader
;
```

| OrderDate               | OrderDateFormatted |
| :---------------------- | :----------------- |
| 2011-05-31 00:00:00.000 | 05/31/2011         |
| 2011-06-01 00:00:00.000 | 06/01/2011         |
| 2011-06-02 00:00:00.000 | 06/02/2011         |
| 2011-06-03 00:00:00.000 | 06/03/2011         |
| 2011-06-04 00:00:00.000 | 06/04/2011         |

Note that this is the same result as the `CONVERT` example above -- there is a lot of overlap between the two functions, so it's up to you which one you use.

## More formatting examples and handy styles

It can be a bit intimidating getting up to speed with these different styles and characters, so some of the most common ones that you'll likely need are below for reference.

Note that some of these formats don't have a pre-defined style for `CONVERT`, so we _have_ to use `FORMAT` for them. The examples are all how the date `2024-12-01` with the time `11:30:45` would be formatted:

| Style (`CONVERT`) | Format (`FORMAT`)           | Example                   |
| :---------------- | :-------------------------- | :------------------------ |
| `103`             | `dd/MM/yyyy`                | 01/12/2024                |
| `106`             | `dd MMM yyyy`               | 01 Dec 2024               |
| `108`             | `HH:mm:ss`                  | 11:30:45                  |
| `120`             | `yyyy-MM-dd HH:mm:ss`       | 2024-12-01 11:30:45       |
| `109`             | `MMM d yyyy HH:mm:ss:ffftt` | Dec 1 2024 11:30:45:000AM |
|                   | `yyyy-MM`                   | 2024-12                   |
|                   | `MMM-yy`                    | Dec-24                    |
|                   | `MMMM yyyy`                 | December 2024             |
|                   | `dddd, dd MMMM yyyy`        | Sunday, 01 December 2024  |

<details>
<summary>Expand for some SQL to run yourself</summary>

These are more examples created just for this course, so they aren't in the AdventureWorks database. If you want to run these examples yourself, you can use the SQL below -- but note that this is using some features that we haven't covered yet!

```sql
SELECT
    CONVERT(VARCHAR, EXAMPLE_DATE, 103),
    FORMAT(EXAMPLE_DATE, 'dd/MM/yyyy'),
    CONVERT(VARCHAR, EXAMPLE_DATE, 106),
    FORMAT(EXAMPLE_DATE, 'dd MMM yyyy'),
    CONVERT(VARCHAR, EXAMPLE_DATE, 108),
    FORMAT(EXAMPLE_DATE, 'HH:mm:ss'),
    CONVERT(VARCHAR, EXAMPLE_DATE, 120),
    FORMAT(EXAMPLE_DATE, 'yyyy-MM-dd HH:mm:ss'),
    CONVERT(VARCHAR, EXAMPLE_DATE, 109),
    FORMAT(EXAMPLE_DATE, 'MMM d yyyy HH:mm:ss:ffftt'),
    FORMAT(EXAMPLE_DATE, 'yyyy-MM'),
    FORMAT(EXAMPLE_DATE, 'MMM-yy'),
    FORMAT(EXAMPLE_DATE, 'MMMM yyyy'),
    FORMAT(EXAMPLE_DATE, 'dddd, dd MMMM yyyy')
FROM (
    VALUES (CAST('2024-12-01 11:30:45' AS DATETIME))
) AS V(EXAMPLE_DATE)
;
```

</details>

## Further reading

Check out the official Microsoft documentation for more information on [`CONVERT`](https://learn.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql) and [`FORMAT`](https://learn.microsoft.com/en-us/sql/t-sql/functions/format-transact-sql) at:

- [https://learn.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql)
- [https://learn.microsoft.com/en-us/sql/t-sql/functions/format-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/functions/format-transact-sql)

The video version of this content is also available at:

- [https://youtu.be/gYjYLL99jaQ](https://youtu.be/gYjYLL99jaQ)

### Additional date functions

Manipulating dates in SQL is fairly different to Excel, but it's outside the scope of this course. However, it's recommended that you check some out to see what options are available:

- [https://learn.microsoft.com/en-us/sql/t-sql/functions/dateadd-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/functions/dateadd-transact-sql)
- [https://learn.microsoft.com/en-us/sql/t-sql/functions/datediff-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/functions/datediff-transact-sql)
- [https://learn.microsoft.com/en-us/sql/t-sql/functions/datepart-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/functions/datepart-transact-sql)
- [https://learn.microsoft.com/en-us/sql/t-sql/functions/year-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/functions/year-transact-sql)
- [https://learn.microsoft.com/en-us/sql/t-sql/functions/month-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/functions/month-transact-sql)
- [https://learn.microsoft.com/en-us/sql/t-sql/functions/day-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/functions/day-transact-sql)
