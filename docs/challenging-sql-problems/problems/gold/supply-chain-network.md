# Supply chain network 🚛

> [!SUCCESS] Scenario
>
> A supermarket's supply chain has three main components: stores, depots, and suppliers.
>
> In general, stock is sent from a supplier to a depot, and then from the depot to a store; however, there are cases where suppliers send stock directly to stores and depots send stock to other depots.
>
> For example:
>
> ```mermaid
> graph LR
>   supplier_2 ----> store_6
>   supplier_2 ---> depot_5
>   supplier_2 ---> depot_4
>   supplier_1 --> depot_3
>   supplier_1 ---> depot_4
>   depot_5 --> depot_4
>   depot_5 ---> store_6
>   depot_5 ---> store_7
>   depot_5 ---> store_8
>   depot_4 ---> store_6
>   depot_4 ---> store_7
>   depot_4 ---> store_8
>   depot_3 --> depot_5
>   depot_3 ---> store_6
>   depot_3 ---> store_7
>   depot_3 ---> store_8
> ```
>
> Although the supermarket knows how much stock is transported between locations, it doesn't know how much of each stock came from each supplier.
>
> This makes it difficult to report various metrics to the suppliers, like the stock balances and sales volumes of their products.

> [!QUESTION]
>
> Determine what the most likely proportion of stock in a store at the end of each day is from each supplier.
>
> Assume that stock moves in a queue ([first in, first out](https://en.wikipedia.org/wiki/Stock_rotation)) in both the depots and the stores.
>
> The output should have a row per store per supplier per day, with the columns:
>
> - `stock_date`
> - `store_id` as the ID of the store
> - `supplier_id` as the ID of the supplier
> - `stock_volume` as the derived volume of stock in the store from the supplier at the end of the day
> - `stock_proportion` as the derived proportion of stock in the store from the supplier. Express this as a percentage rounded to two decimal places
>
> Order the output by `stock_date`, `store_id`, and `supplier_id`.
>
> You can choose to show stores that have no stock from a supplier on a given day (i.e., you can show a row with a `stock_volume` of 0 or not show the row at all, whatever is easiest for you).

<details>
<summary>Expand for the DDL</summary>
--8<-- "docs/challenging-sql-problems/problems/gold/supply-chain-network.sql"
</details>

The solution can be found at:

- [supply-chain-network.md](../../solutions/gold/supply-chain-network.md)

A worked example is provided below to help illustrate the "shuffling" within the locations.

---

<!-- prettier-ignore -->
>? INFO: **Sample input**
>
> **Locations**
>
> | location_id | location_type |
> |------------:|:--------------|
> |           1 | supplier      |
> |           2 | supplier      |
> |           3 | depot         |
> |           4 | depot         |
> |           5 | store         |
>
> **Deliveries**
>
> | delivery_date       | from_location_id |  to_location_id | product_id | quantity |
> |:--------------------|-----------------:|----------------:|-----------:|---------:|
> | 2024-01-01 01:23:53 |                1 |               3 |        123 |       25 |
> | 2024-01-01 06:27:54 |                2 |               4 |        123 |       25 |
> | 2024-01-01 12:27:39 |                4 |               5 |        123 |       25 |
> | 2024-01-01 17:12:59 |                1 |               3 |        123 |       30 |
> | 2024-01-02 01:27:57 |                3 |               5 |        123 |       25 |
> | 2024-01-02 05:16:08 |                3 |               4 |        123 |       30 |
> | 2024-01-02 05:40:53 |                2 |               3 |        123 |       20 |
> | 2024-01-02 07:29:53 |                1 |               4 |        123 |       30 |
> | 2024-01-02 09:22:53 |                3 |               5 |        123 |       20 |
> | 2024-01-02 18:28:39 |                4 |               5 |        123 |       60 |
>
> **Sales**
>
> | sale_datetime       | store_id | product_id | quantity |
> |:--------------------|---------:|-----------:|---------:|
> | 2024-01-01 14:56:12 |        5 |        123 |        5 |
> | 2024-01-01 16:28:24 |        5 |        123 |        3 |
> | 2024-01-01 16:35:38 |        5 |        123 |        4 |
> | 2024-01-01 20:13:46 |        5 |        123 |        2 |
> | 2024-01-02 09:37:11 |        5 |        123 |       12 |
> | 2024-01-02 14:02:57 |        5 |        123 |       30 |
> | 2024-01-02 14:21:39 |        5 |        123 |        3 |
> | 2024-01-02 16:44:26 |        5 |        123 |        8 |
> | 2024-01-02 18:28:37 |        5 |        123 |        2 |
>
> **Network diagram**
>
> ```mermaid
> graph LR
>   supplier_1 --> depot_3
>   supplier_1 --> depot_4
>   supplier_2 --> depot_3
>   supplier_2 --> depot_4
>   depot_3 --> depot_4
>   depot_3 --> store_5
>   depot_4 --> store_5
> ```
>
--8<-- "docs/challenging-sql-problems/problems/gold/supply-chain-network--sample-input.sql"

<!-- prettier-ignore -->
>? INFO: **Sample output**
>
>| stock_date | store_id | supplier_id | stock_volume | stock_proportion |
>|:-----------|---------:|------------:|-------------:|-----------------:|
>| 2024-01-01 |        5 |           1 |            0 |             0.00 |
>| 2024-01-01 |        5 |           2 |           11 |           100.00 |
>| 2024-01-02 |        5 |           1 |           30 |            49.18 |
>| 2024-01-02 |        5 |           2 |           31 |            50.82 |
>
--8<-- "docs/challenging-sql-problems/problems/gold/supply-chain-network--sample-output.sql"

<!-- prettier-ignore -->
>? TIP: **Hint 1**
>
> (to be added)

<!-- prettier-ignore -->
>? TIP: **Hint 2**
>
> (to be added)

---

### Worked example

To help illustrate the stock movement within the locations, consider the locations and deliveries in the **Sample input**.

We'll walk through each of the deliveries and how they contribute to end-of-day stock levels.

Since each delivery and sale correspond to the same product, we'll omit mentioning the product ID in the following walkthrough.

#### 2024-01-01

First, consider the deliveries:

- **Supplier 1** sends 25 units to **Depot 3**; **Depot 3** has 25 units from **Supplier 1** and 0 units from **Supplier 2**.
- **Supplier 2** sends 25 units to **Depot 4**; **Depot 4** has 0 units from **Supplier 1** and 25 units from **Supplier 2**.
- **Depot 4** sends 25 units to **Store 5**; all 25 units are originally from **Supplier 2** so:
  - **Store 5** has 0 units from **Supplier 1** and 25 units from **Supplier 2**.
  - **Depot 4** has 0 units from either supplier.
- **Supplier 1** sends 30 units to **Depot 3**; **Depot 3** has 55 units from **Supplier 1** and 0 units from **Supplier 2**.

Then the sales, which we can roll up to the end of the day:

- **Store 5** sells 14 units throughout the day; all units are from **Supplier 2** so **Store 5** has 0 units from **Supplier 1** and 11 units from **Supplier 2**.

Therefore, at the end of 2024-01-01, the proportion for **Store 5** is 100% from **Supplier 2**:

| stock_date | store_id | supplier_id | stock_volume | stock_proportion |
| :--------- | -------: | ----------: | -----------: | ---------------: |
| 2024-01-01 |        5 |           1 |            0 |             0.00 |
| 2024-01-01 |        5 |           2 |           11 |           100.00 |

#### 2024-01-02

First, consider the deliveries:

- **Depot 3** sends 25 units to **Store 5**; all 25 units are from **Supplier 2** so:
  - **Store 5** has 0 units from **Supplier 1** and 36 units from **Supplier 2**.
  - **Depot 3** has 30 units from **Supplier 1** and 0 units from **Supplier 2**.
- **Depot 3** sends 30 units to **Depot 4**; all 30 units are from **Supplier 2** so:
  - **Depot 4** has 0 units from **Supplier 1** and 30 units from **Supplier 2**.
  - **Depot 3** has 0 units from either supplier.
- **Supplier 2** sends 20 units to **Depot 3**; **Depot 3** has 20 units from **Supplier 2** and 0 units from **Supplier 1**.
- **Supplier 1** sends 30 units to **Depot 4**; **Depot 4** has 30 units from **Supplier 1** and 30 units from **Supplier 2**. The 30 units from **Supplier 2** and first in the queue, followed by the 30 units from **Supplier 1**.
- **Depot 3** sends 20 units to **Store 5**; all 20 units are from **Supplier 2** so:
  - **Store 5** has 0 units from **Supplier 1** and 56 units from **Supplier 2**.
  - **Depot 3** has 0 units from either supplier.
- **Depot 4** sends 60 units to **Store 5**; 30 units are from **Supplier 1** and 30 units are from **Supplier 2** so:
  - **Store 5** has 30 units from **Supplier 1** and 86 units from **Supplier 2**. The existing 56 units from **Supplier 2** are first in the queue, followed by the new 30 units from **Supplier 2**, followed by the 30 units from **Supplier 1**.
  - **Depot 4** has 0 units from either supplier.

Then the sales, which we can roll up to the end of the day:

- **Store 5** sells 55 units throughout the day; all 86 units from **Supplier 2** are first in the queue, so **Store 5** has 30 units from **Supplier 1** and 31 units from **Supplier 2**.

Therefore, at the end of 2024-01-02, the proportion for **Store 5** is 49.18% from **Supplier 1** and 50.82% from **Supplier 2**:

| stock_date | store_id | supplier_id | stock_volume | stock_proportion |
| :--------- | -------: | ----------: | -----------: | ---------------: |
| 2024-01-02 |        5 |           1 |           30 |            49.18 |
| 2024-01-02 |        5 |           2 |           31 |            50.82 |

Combined with the output from 2024-01-01, the output is the same as the **Sample output**.
