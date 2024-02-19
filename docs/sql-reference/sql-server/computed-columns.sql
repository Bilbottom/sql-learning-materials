/*
    Computed columns

    --------------------------------------------------------------------

    A computed column is a column in a table that is computed from other
    columns in the same table. The computed column is computed each time
    it is referenced, but it can be persisted.

    --------------------------------------------------------------------

    Docs:
    - https://learn.microsoft.com/en-us/sql/relational-databases/tables/specify-computed-columns-in-a-table
*/
use AdventureWorks2022;
set statistics time on;


/*
    This example is taken from the docs linked above (slightly tweaked).
*/
drop table if exists #Products;
create table #Products(
    ProductID      int identity (1, 1) not null,
    QtyAvailable   smallint,
    UnitPrice      money,
    InventoryValue as QtyAvailable * UnitPrice persisted
);
insert into #Products(QtyAvailable, UnitPrice)
values
    (25, 2.00),
    (10, 1.5)
;


/*
    Display the rows in the table before updating them -- the updates
    are also reflected in the computed column.
*/
select *
from #Products
;

update #Products
set UnitPrice = 2.5
where ProductID = 1
;

select *
from #Products
;
