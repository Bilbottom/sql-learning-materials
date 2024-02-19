/*
    SQL Server extension of the `internals/indexes.sql` file

    --------------------------------------------------------------------

    There are 12 types in indexes in SQL Server (or just 10, depending
    on how you count it), but we'll just talk about the following 4:

    1.  Clustered
    2.  Non-Clustered
    3.  Unique
    4.  Filtered

    The canonical example of a clustered vs non-clustered index is a
    customer table that has both customer ID and customer name. You'd
    (most likely) stick a clustered index on the ID and a non-clustered
    index on the name.
*/


/*
    + Clustered +

    This usually coincides with your primary key -- in fact, primary key
    constraints will, by default, create a clustered (unique, non-NULL)
    index on the table over the primary key columns in SQL Server.

    A clustered index changes the order in which rows are physically
    stored. This can slow down INSERT/UPDATE/DELETE operations, but it
    makes SELECT statements that filter, join, or sort the columns in
    the clustered index much faster.
*/
create clustered index clustered_index_name
    on schema_name.table_name(column_name_1, column_name_2)
;


/*
    + Non-Clustered+

    You'd add a non-clustered index to columns of high cardinality (few
    duplicated values) that are regularly used in WHERE, JOIN, or ORDER
    BY clauses.

    A non-clustered index creates a new "table" (behind the scenes). The
    columns in this "table" are the columns used in the index, plus any
    columns in the INCLUDE clause. The index's table will have rows that
    are ordered by the columns used in the index so that lookups on
    these columns are quick (you can think of the non-clustered index's
    table as having its own clustered index on the non-clustered index's
    columns).

    The non-clustered index's "table" also has a "pointer" that relates
    the rows in the index's "table" back to the original table. This is
    one of the things that makes non-clustered indexes fast: it's very
    quick to search for values in the index, and then fast to find the
    row(s) that they came from in the original table.
*/
create nonclustered index clustered_index_name
    on schema_name.table_name(column_name_1, column_name_2)
;


/*
    + Unique +

    "I thought that unique was a constraint?"

    It is, but it's also an index -- the unique constraint creates a
    unique index in SQL Server. Unique indexes are non-clustered, unless
    they correspond to the clustered index (and the clustered index is
    specified to be unique).

    A unique index also speeds up searches both because of the ordering
    and because it can stop when it finds what it's looking for. If we
    don't tell the database that the values of a column are unique, it
    won't know!
*/
create unique index unique_index_name
    on schema_name.table_name(column_name_1, column_name_2)
;


/*
    + Filtered +

    A non-clustered index can also include a WHERE clause which reduces
    the number of rows that are saved in the index's table.

    This is particularly helpful in cases where there is a specific
    value of a specific column that we generally want to filter on, such
    as the latest indicator column in SCD2 tables.
*/
create nonclustered index filtered_index_name
    on schema_name.table_name(column_name_1, column_name_2)
    where column_to_filter <filter condition>
;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* SQL Server */
use AdventureWorks2022;
set statistics time on;
set statistics xml on;
