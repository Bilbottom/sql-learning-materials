---
hide:
  - tags
tags:
  - pivot and unpivot
  - linear regression
---

# Predicting values 🎱

> [!SUCCESS] Scenario
>
> Some students are studying [Anscombe's quartet](https://en.wikipedia.org/wiki/Anscombe%27s_quartet) and have been asked to predict the `y` values for a given set of `x` values for each of the four datasets using [linear regression](https://en.wikipedia.org/wiki/Linear_regression).

> [!QUESTION]
>
> For each of the four datasets in Anscombe's quartet, use linear regression to predict the `y` values for `x` values `16`, `17`, and `18`.
>
> The output should have a row for each `x` value (`16`, `17`, `18`), with the columns:
>
> - `x`
> - `dataset_1` as the predicted value for dataset 1, rounded to 1 decimal place
> - `dataset_2` as the predicted value for dataset 2, rounded to 1 decimal place
> - `dataset_3` as the predicted value for dataset 3, rounded to 1 decimal place
> - `dataset_4` as the predicted value for dataset 4, rounded to 1 decimal place
>
> Order the output by `x`.

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/silver/predicting-values.sql"
</details>

There are plenty of resources online that walk through the maths behind linear regression, such as:

- [https://www.youtube.com/watch?v=GAmzwIkGFgE](https://www.youtube.com/watch?v=GAmzwIkGFgE)

The solution can be found at:

- [predicting-values.md](../../solutions/silver/predicting-values.md)

---

<!-- prettier-ignore -->
>? INFO: **Sample input**
>
> Use linear regression to predict the `y` values for `x` values `6` and `8`, using the following datasets:
>
> | dataset_1__x | dataset_1__y | dataset_2__x | dataset_2__y |
> |:-------------|:-------------|:-------------|:-------------|
> | 1            | 2.00         | 1            | 9.12         |
> | 2            | 4.00         | 3            | 31.18        |
> | 3            | 6.00         | 5            | 55.27        |
> | 4            | 8.00         | 7            | 61.12        |
>
--8<-- "docs/challenging-sql-problems/problems/silver/predicting-values--sample-input.sql"

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
> |    x | dataset_1 | dataset_2 |
> |-----:|----------:|----------:|
> |    6 |        12 |      57.2 |
> |    8 |        16 |      75.2 |
>
--8<-- "docs/challenging-sql-problems/problems/silver/predicting-values--sample-output.sql"

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> Unpivot the datasets so that you have a table with headers `dataset`, `x`, and `y`, then apply the linear regression, and finally pivot the results back.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> For databases that support them, use the `regr_slope` and `regr_intercept` functions (or equivalent) to calculate the slope and intercept of the regression line. Otherwise, you'll need to calculate these manually 😄
