# Fibonacci sequence 🔢

> [!INFO]
>
> This is just for fun, there's no real-world application for this (as far as I know) 😝

> [!QUESTION]
>
> Generate the first 45 terms of the [Fibonacci sequence](https://en.wikipedia.org/wiki/Fibonacci_sequence).
>
> The output should have one row per term in the sequence, with the columns:
>
> - `n` as the term number
> - `f_n` as the corresponding Fibonacci number
>
> Order the output by `n`.

The [Fibonacci sequence](https://en.wikipedia.org/wiki/Fibonacci_sequence) is defined as _f<sub>n</sub> = f<sub>n-1</sub> + f<sub>n-2</sub>_, where _f<sub>1</sub> = f<sub>2</sub> = 1_.

For example:

- The third term is _f<sub>3</sub> = f<sub>2</sub> + f<sub>1</sub> = 1 + 1 = 2_
- The fourth term is _f<sub>4</sub> = f<sub>3</sub> + f<sub>2</sub> = 2 + 1 = 3_
- ...
- The tenth term is _f<sub>10</sub> = f<sub>9</sub> + f<sub>8</sub> = 34 + 21 = 55_

The solution can be found at:

- [fibonacci-sequence.md](../../solutions/bronze/fibonacci-sequence.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample input**
>
> Generate the first 10 terms of the Fibonacci sequence.

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> |  n | f_n |
> |---:|----:|
> |  1 |   1 |
> |  2 |   1 |
> |  3 |   2 |
> |  4 |   3 |
> |  5 |   5 |
> |  6 |   8 |
> |  7 |  13 |
> |  8 |  21 |
> |  9 |  34 |
> | 10 |  55 |
>
--8<-- "docs/challenging-sql-problems/problems/bronze/fibonacci-sequence--sample-output.sql"

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> Use a [recursive CTE](../../../from-excel-to-sql/advanced-concepts/recursive-ctes.md) to generate the sequence.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> Use the columns `n`, `f_n`, and `f_m` to keep track of the current term, the current Fibonacci number, and the previous Fibonacci number.
