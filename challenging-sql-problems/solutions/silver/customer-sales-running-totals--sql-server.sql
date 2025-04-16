```sql
with

Dates as (
        select cast('2014-06-01' as date) as BalanceDate
    union all
        select dateadd(day, 1, BalanceDate)
        from Dates
        where BalanceDate < '2014-06-30'
),

CustomerSalesUnioned as (
        select
            CustomerID,
            '2014-05-31' as OrderDate,
            sum(TotalDue) as TotalDue
        from Sales.SalesOrderHeader
        where 1=1
            and CustomerID in (11176, 11091, 11287)
            and OrderDate < '2014-06-01'
        group by CustomerID
    union all
        select
            CustomerID,
            OrderDate,
            sum(TotalDue) as TotalDue
        from Sales.SalesOrderHeader
        where 1=1
            and CustomerID in (11176, 11091, 11287)
            and OrderDate between '2014-06-01' and '2014-06-30'
        group by
            CustomerID,
            OrderDate
),

CustomerSales as (
    select
        CustomerID,
        OrderDate,
        -1 + lead(OrderDate, 1, '2014-07-01') over CustomerByOrderDate as NextOrderDate,
        sum(TotalDue) over CustomerByOrderDate as RunningTotal
    from CustomerSalesUnioned
    window CustomerByOrderDate as (
        partition by CustomerID
        order by OrderDate
    )
)

select
    Dates.BalanceDate,
    CustomerSales.CustomerID,
    CustomerSales.RunningTotal
from Dates
    left join CustomerSales
        on Dates.BalanceDate between CustomerSales.OrderDate and CustomerSales.NextOrderDate
order by
    Dates.BalanceDate,
    CustomerSales.CustomerID
```
