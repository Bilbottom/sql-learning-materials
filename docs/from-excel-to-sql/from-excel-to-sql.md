# From Excel to SQL

## About this course

> [!SUCCESS]
>
> SQL for the Excel user 🎉
>
> Prefer videos? Check out the corresponding YouTube playlist:
>
> - [https://www.youtube.com/playlist?list=PLEiRgvTilK5rhnVPQ_Tj3Q-CI0rGn_uiD](https://www.youtube.com/playlist?list=PLEiRgvTilK5rhnVPQ_Tj3Q-CI0rGn_uiD)

There are _loads_ of resources online for learning SQL, such as:

- [W3Schools](https://www.w3schools.com/sql/)
- [SQLZoo](https://sqlzoo.net/)
- [Mode Analytics](https://mode.com/sql-tutorial/)
- [Khan Academy](https://www.khanacademy.org/computing/computer-programming/sql)
- [Codecademy](https://www.codecademy.com/learn/learn-sql)
- [SQLBolt](https://sqlbolt.com/)
- [SQLCourse](http://www.sqlcourse.com/)
- [Analyst Builder](https://www.analystbuilder.com/)
- [DataLemur](https://datalemur.com/)

...and the list goes on.

This course is another one to add to the list, but the focus is _coming from an Excel background_!

> [!NOTE]
>
> Some of the information provided here is simplified for the sake of learning. In reality, there may be additional caveats depending on the SQL flavour that you use.
>
> There is also _plenty_ of information that is not covered here, even in the advanced concepts section. This is just a starting point, and you are encouraged to check out the documentation for the SQL flavour that you're using 📝

## The tools/data in this course

Since this course is aimed at [Microsoft Excel](https://www.microsoft.com/en-gb/microsoft-365/excel) users, the "SQL flavour" that we'll use is the [Microsoft SQL Server](https://learn.microsoft.com/en-us/sql/t-sql/queries/queries) dialect ([_Transact-SQL_](https://learn.microsoft.com/en-us/sql/t-sql/language-reference)).

Any time a comment is made about how SQL does something, it's referring to the Microsoft SQL Server dialect which may not be the same as other SQL dialects.

The data will be the [_AdventureWorks_](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure) data. You can access this data for free at a few different places; the following site is recommended since it has an interactive query tool:

- [https://dbfiddle.uk/](https://dbfiddle.uk/)

The documentation for the **AdventureWorks** data is available at:

- [https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure)

You can download and install applications to run SQL on your own machine. This won't be covered in this course, but there are several alternative guides online such as:

- [Introduction to SQL Programming for Excel Users - SQL Server Windows Setup](https://youtu.be/VnJAgND_iLc?si=LduWGyoKy069NP-L)

> [!TIP]
>
> If you're aiming to run SQL at work (assuming there's some SQL at your work to play with 😝), you'll need to ask around to see what flavour of SQL is being used and what tools/methods for using it are available to you. This is almost entirely at the discretion of your IT department (or similar).

## Outline

1. **Getting started**
   1. [Setting the context](getting-started/setting-the-context.md)
   2. [Syntax rules](getting-started/sql-syntax.md)
2. **Main concepts**
   1. [Gimme data (`SELECT` and `FROM`)](main-concepts/select-and-from.md)
   2. [Filtering (`WHERE`)](main-concepts/where.md)
   3. [Ordering (`ORDER BY`)](main-concepts/order-by.md)
   4. [Comments (`--` and `/**/`)](main-concepts/comments.md)
   5. [`TOP` and `DISTINCT`](main-concepts/top-and-distinct.md)
   6. [Data types](main-concepts/data-types.md)
   7. [Operators](main-concepts/operators.md)
   8. [Conditional logic (`CASE` and `IIF`)](main-concepts/conditionals.md)
   9. [Date formatting (`FORMAT`)](main-concepts/date-formatting.md)
   10. [Aggregations (`GROUP BY`)](main-concepts/group-by.md)
   11. [Pivot Tables (`ROLLUP`)](main-concepts/rollup.md)
   12. [Joins (`JOIN`)](main-concepts/join.md)
   13. [Unions (`UNION`)](main-concepts/union.md)
   14. [Subqueries](main-concepts/subqueries.md)
   15. [Window functions (`OVER`)](main-concepts/window-functions.md)
   16. [Logical processing order](main-concepts/logical-processing-order.md)
   17. [Style guide](main-concepts/style-guide.md)
3. **Advanced concepts**
   1. [Advanced aggregations](advanced-concepts/advanced-aggregations.md)
   2. [Correlated subqueries](advanced-concepts/correlated-subqueries.md)
   3. [Recursive CTEs](advanced-concepts/recursive-ctes.md)

> [!WARNING]
>
> The advanced concepts are _advanced_! They are not necessary for most day-to-day SQL usage, but they are good to know about.
>
> It is recommended that you practise the main concepts a lot and come back to the advanced concepts later.
