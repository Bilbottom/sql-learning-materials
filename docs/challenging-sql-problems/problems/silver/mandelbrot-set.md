# Mandelbrot set 🌀

> [!INFO]
>
> This is just for fun, there's no real-world application for this (as far as I know) 😝

> [!QUESTION]
>
> Plot an image of the Mandelbrot set.
>
> Start with a 51x51 grid of points ranging from -2 to 2 on both the x and y axes. A sample of some points in the grid are:
>
> |             |                |        |               |            |
> | :---------: | :------------: | :----: | :-----------: | :--------: |
> |   (-2, 2)   |   (-1.92, 2)   |  ...   |   (1.92, 2)   |   (2, 2)   |
> | (-2, 1.92)  | (-1.92, 1.92)  |  ...   | (1.92, 1.92)  | (2, 1.92)  |
> |     ...     |      ...       | (0, 0) |      ...      |    ...     |
> | (-2, -1.92) | (-1.92, -1.92) |  ...   | (1.92, -1.92) | (2, -1.92) |
> |  (-2, -2)   |  (-1.92, -2)   |  ...   |  (1.92, -2)   |  (2, -2)   |
>
> Apply the Mandelbrot set formula to each point in the grid for 100 iterations. If the point remains inside this grid after 100 iterations, mark it with a `•`. If it diverges, mark it with a space.
>
> Once you know which points are in the set, return a single cell with a string representation of the grid.
>
> For example, an output might look like the following string:
>
> ```
>           •
>          •
>          ••
>        •••••
>      • •••••
> ••••••••••••
>      • •••••
>        •••••
>          ••
>          •
>           •
> ```

The Mandelbrot set is a set of complex numbers `c` for which the function `f(z) = z^2 + c` does not diverge when iterated from `z = 0`.

We can plot the Mandelbrot set by considering the complex plane as a grid of coordinates. Given two points `(a, b)` and `(c, d)`, we can define addition and multiplication as:

- Addition: `(a, b) + (c, d) = (a + c, b + d)`
- Multiplication: `(a, b) * (c, d) = (a * c - b * d, a * d + b * c)`

Note that, by considering the complex plane as a grid of coordinates, the complex number `0` is represented as `(0, 0)`.

The solution can be found at:

- [mandelbrot-set.md](../../solutions/silver/mandelbrot-set.md)

A worked example is provided below to help illustrate the loan calculations.

---

<!-- prettier-ignore -->
>? INFO: **Sample input**
>
> Plot an image of the Mandelbrot set on a 21x21 grid.

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
>
> ```
>           •
>          •
>          ••
>        •••••
>      • •••••
> ••••••••••••
>      • •••••
>        •••••
>          ••
>          •
>           •
> ```
>
--8<-- "docs/challenging-sql-problems/problems/silver/mandelbrot-set--sample-output.sql"

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> Generate the grid of points into a table with columns `x` and `y` ranging from -2 to 2 in steps of 0.08.

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> Use a [recursive CTE](../../../from-excel-to-sql/advanced-concepts/recursive-ctes.md) to iterate over the grid points for 100 iterations, applying the Mandelbrot set formula to each point.

---

### Worked examples

To help illustrate the Mandelbrot set calculations, consider the following points:

- (-2, 2)
- (-2, 0)
- (-1, 0)
- (0, 0)
- (2, 0)
- (1.04, 1.04)

Let's walk through the steps for these.

We'll use two additional details:

1. For a complex number `z = (a, b)`, the square of `z` is `z^2 = (a^2 - b^2, 2ab)`
2. Any complex number that exceeds -2 or 2 on either axis will diverge

#### (-2, 2)

In the function `f(z) = z^2 + c`, we start with `z = (0, 0)` and `c = (-2, 2)`. The first two iterations are:

- `f((0, 0)) = (0, 0)^2 + (-2, 2) = (-2, 2)`
- `f((-2, 2)) = (-2, 2)^2 + (-2, 2) = (4 - 4, 2 * -2 * 2) + (-2, 2) = (0, -8) + (-2, 2) = (-2, -6)`

After the second iteration, the resulting point is outside the grid, so it will diverge; therefore, the point `(-2, 2)` _is not_ in the set.

#### (-2, 0)

In the function `f(z) = z^2 + c`, we start with `z = (0, 0)` and `c = (-2, 0)`. The first few iterations are:

- `f((0, 0)) = (0, 0)^2 + (-2, 0) = (-2, 0)`
- `f((-2, 0)) = (-2, 0)^2 + (-2, 0) = (4 - 0, 2 * -2 * 0) + (-2, 0) = (4, 0) + (-2, 0) = (2, 0)`
- `f((2, 0)) = (2, 0)^2 + (-2, 0) = (4 - 0, 2 * 2 * 0) + (-2, 0) = (4, 0) + (-2, 0) = (2, 0)`

After the second iteration, the resulting point remains the same and within the grid; therefore, the point `(-2, 0)` _is_ in the set.

#### (0, 0)

In the function `f(z) = z^2 + c`, we start with `z = (0, 0)` and `c = (0, 0)`. The first iteration is:

- `f((0, 0)) = (0, 0)^2 + (0, 0) = (0, 0)`

The resulting point remains the same after the first iteration, so it will not diverge; therefore, the point `(0, 0)` _is_ in the set.

#### (2, 0)

In the function `f(z) = z^2 + c`, we start with `z = (0, 0)` and `c = (2, 0)`. The first two iterations are:

- `f((0, 0)) = (0, 0)^2 + (2, 0) = (2, 0)`
- `f((2, 0)) = (2, 0)^2 + (2, 0) = (4 - 0, 2 * 2 * 0) + (2, 0) = (4, 0) + (2, 0) = (6, 0)`

After the second iteration, the resulting point is outside the grid, so it will diverge; therefore, the point `(2, 0)` _is not_ in the set.

#### (1.04, 1.04)

In the function `f(z) = z^2 + c`, we start with `z = (0, 0)` and `c = (1.04, 1.04)`. The first two iterations are:

- `f((0, 0)) = (0, 0)^2 + (1.04, 1.04) = (1.04, 1.04)`
- `f((1.04, 1.04)) `<br>`= (1.04, 1.04)^2 + (1.04, 1.04) `<br>`= (1.0816 - 1.0816, 2 * 1.04 * 1.04) + (1.04, 1.04) `<br>`= (0, 2.1632) + (1.04, 1.04) `<br>`= (1.04, 3.2032)`

After the second iteration, the resulting point is outside the grid, so it will diverge; therefore, the point `(1.04, 1.04)` _is not_ in the set.
