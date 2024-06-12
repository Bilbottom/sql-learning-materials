# Mandelbrot set 🌀

> [!TIP]
>
> Solution to the following problem:
>
> - [mandelbrot-set.md](../../problems/silver/mandelbrot-set.md)

## Result Set

Regardless of the database, the result set should be a single cell with a value looking something like:

```
                       ••
                       ••
                      •••
                   ••••••••• •
                  •••••••••••
                  ••••••••••••
                 ••••••••••••••
           •••  ••••••••••••••
           •••• ••••••••••••••
          ••••••••••••••••••••
•••••••••••••••••••••••••••••
          ••••••••••••••••••••
           •••• ••••••••••••••
           •••  ••••••••••••••
                 ••••••••••••••
                  ••••••••••••
                  •••••••••••
                   ••••••••• •
                      •••
                       ••
                       ••
```

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/solutions/silver/mandelbrot-set.sql"
</details>

> [!SUCCESS]
>
> If you want to see a more interesting solution which "colours" the points based on how quickly they diverge, you can find it at:
>
> - [https://thedailywtf.com/articles/stupid-coding-tricks-the-tsql-madlebrot](https://thedailywtf.com/articles/stupid-coding-tricks-the-tsql-madlebrot)

## Solution

Some SQL solutions per database are provided below.

<!-- prettier-ignore -->
> SUCCESS: **DuckDB**
>
--8<-- "docs/challenging-sql-problems/solutions/silver/mandelbrot-set--duckdb.sql"
