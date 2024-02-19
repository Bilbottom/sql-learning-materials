/*
    Indexes

    --------------------------------------------------------------------

    Indexes are on row-store DBMS's: SQLite, SQL Server, and PostgreSQL.

    A great resource for learning about indexes is:

    - https://use-the-index-luke.com/

    --------------------------------------------------------------------

    Heaps

    Before we talk about indexes, we'll first note that tables without indexes
    are called *heaps* (in SQL Server). There are some cases where you want heap
    tables, but in most cases you want to avoid these.

    --------------------------------------------------------------------

    Binary Search

    Again, before talking about indexes, it's worth introducing the
    binary search as motivation to understand why indexes are so
    important.

    - Linear search is O(n)
    - Binary search is O(log_2 n)

    Indexes don't use binary search, but they do use a similar idea with
    similar performance improvements.

    --------------------------------------------------------------------

    Docs:
    - https://www.sqlite.org/lang_createindex.html
    - https://www.postgresql.org/docs/current/indexes.html
    - https://learn.microsoft.com/en-us/sql/relational-databases/indexes/indexes

    --------------------------------------------------------------------

    Also see:
    - `sql-server/indexes.sql`
*/


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* SQL Server */
use AdventureWorks2022;
set statistics time on;
set statistics xml on;
-- set statistics xml off;


/*
    The syntax can be found in the docs -- since it's a broad topic with
    subtle differences between DBMS's, this will just have examples to
    illustrate the concepts.
*/


/* Clustered index (PK) lookup is fastest */
select
    BusinessEntityID,
    FirstName,
    MiddleName,
    LastName
from Person.Person
where BusinessEntityID = 100
;


/* Non-clustered index lookup is still fast */
select
    BusinessEntityID,
    FirstName,
    MiddleName,
    LastName
from Person.Person
where FirstName = ''
  and MiddleName = ''
  and LastName = ''
;


/* ...but only when you use the right columns in the right order */
select
    BusinessEntityID,
    FirstName,
    MiddleName,
    LastName
from Person.Person
where FirstName = ''
  and LastName = ''
;
select
    BusinessEntityID,
    FirstName,
    MiddleName,
    LastName
from Person.Person
where FirstName = ''
;


/* Physical Locations (SQL Server */
select top 10
    %%physloc%% as [%%physloc%%],
    sys.fn_PhysLocFormatter(%%physloc%%) as [File:Page:Slot],

    BusinessEntityID,
    FirstName,
    MiddleName,
    LastName
from Person.Person
;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* SQL Server */
use AdventureWorksDW2022;
set statistics time on;
set statistics xml on;


select top 10 *
from FactFinance
;


select
    min(DateKey) as min_DateKey,
    max(DateKey) as max_DateKey,
    count(distinct OrganizationKey) as OrganizationKey,
    count(distinct DepartmentGroupKey) as DepartmentGroupKey,
    count(distinct ScenarioKey) as ScenarioKey,
    count(distinct AccountKey) as AccountKey
from FactFinance
;

select
    DateKey,
    count(*)
from FactFinance
group by DateKey
order by DateKey
;

select
    AccountKey,
    count(*),
    count(distinct OrganizationKey) as OrganizationKey,
    count(distinct DepartmentGroupKey) as DepartmentGroupKey,
    count(distinct ScenarioKey) as ScenarioKey
from FactFinance
group by AccountKey
order by AccountKey
;











drop table if exists #balances;
create table #balances(
    balance_id       integer primary key, -- sk_id
    scenario         integer,             -- source
    department_group integer,             -- balance type
    account_id       integer,
    balance          float,
    balance_date     date
);
insert into #balances
    select
        FinanceKey,
        ScenarioKey,
        DepartmentGroupKey,
        AccountKey,
        sum(Amount) over (
            partition by
                AccountKey,
                ScenarioKey,
                DepartmentGroupKey,
                OrganizationKey
            order by DateKey rows unbounded preceding
        ),
        Date
    from FactFinance
    order by FinanceKey
;


/* Latest Balances - V1 */
select
    scenario,
    account_id,
    balance_date,
    department_group,
    balance
from (
    select
        *,
        row_number() over(
            partition by account_id  -- , department_group
            order by balance_date desc
        ) as row_num
    from #balances
    where scenario = 1  /* Important to do it on the inside! */
      and department_group = 1
) as bal
where row_num = 1
order by account_id
;
/* Latest Balances - V2 */
select
    scenario,
    account_id,
    balance_date,
    department_group,
    balance
from #balances
where scenario = 1
  and department_group = 1
  and balance_date = (
    select max(balance_date)
    from #balances as bal_i
    where #balances.account_id = bal_i.account_id
      and #balances.scenario = bal_i.scenario
      and #balances.department_group = bal_i.department_group
  )
order by account_id
;


/*
    Auto-sync inspection
*/
DROP TABLE IF EXISTS dbo.Allica_Balances;
CREATE TABLE dbo.Allica_Balances(
    SK_ID                INT
        CONSTRAINT SK_ID_Balances2 PRIMARY KEY,
    balance_natural_key  NVARCHAR(100),
    [source]             NVARCHAR(100),
    balance_type         NVARCHAR(100),
    account_id           NVARCHAR(100),
    currency             NVARCHAR(10),
    balance              FLOAT,
    account_closing_date DATETIME
);
INSERT INTO dbo.Allica_Balances
    SELECT
        SK_ID,
        balance_natural_key,
        [source],
        balance_type,
        account_id,
        currency,
        balance,
        account_closing_date
    FROM Allica.Balances
    WHERE source = 'HAZEL'
    ORDER BY SK_ID
;


/* dbo.Allica_Balances Latest Balances - V1 */
SELECT
    [source],
    account_id,
    account_closing_date AS balance_date,
    balance_type,
    balance
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY account_id  -- , balance_type
            ORDER BY account_closing_date DESC
        ) AS row_num
    FROM dbo.Allica_Balances
    WHERE [source] = 'HAZEL'  /* Important to do it on the inside! */
      AND balance_type = 'Outstanding_Balance'
) AS bal
WHERE row_num = 1
--   AND account_id = 'AL200013700'

ORDER BY account_id
;


/* dbo.Allica_Balances Latest Balances - V2 */
SELECT
    [source],
    account_id,
    account_closing_date AS balance_date,
    balance_type,
    balance
FROM dbo.Allica_Balances
WHERE [source] = 'HAZEL'
  AND balance_type = 'Outstanding_Balance'
  AND account_closing_date = (
    SELECT MAX(account_closing_date)
    FROM dbo.Allica_Balances AS bal_i
    WHERE Allica_Balances.account_id = bal_i.account_id
      AND Allica_Balances.[source] = bal_i.[source]
      AND Allica_Balances.balance_type = bal_i.balance_type
  )
--   AND account_id = 'AL200013700'

ORDER BY account_id
;


/* dbo.Allica_Balances Latest Balances - V3 */
SELECT
    [source],
    account_id,
    account_closing_date AS balance_date,
    balance_type,
    balance
FROM (
    SELECT TOP 1 WITH TIES *
    FROM dbo.Allica_Balances
    WHERE [source] = 'HAZEL'
      AND balance_type = 'Outstanding_Balance'
    ORDER BY ROW_NUMBER() OVER(
        PARTITION BY account_id  -- , balance_type
        ORDER BY account_closing_date DESC
    )
) AS bal
-- WHERE account_id = 'AL200013700'

ORDER BY account_id
;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/*
    How many indexes? :P
*/
DROP TABLE IF EXISTS dbo.bill_balances;
CREATE TABLE dbo.bill_balances(
    natural_key  NVARCHAR(100) NOT NULL UNIQUE,
    [source]     NVARCHAR(100) NOT NULL,
    balance_type NVARCHAR(100) NOT NULL,
    account_id   NVARCHAR(100) NOT NULL,
    date_from    DATE NOT NULL,
    date_to      DATE NOT NULL,
    current_flag BIT NOT NULL,
    currency     NVARCHAR(10) NOT NULL,  /* Maybe in PK, depends */
    balance      DECIMAL(19, 4) NOT NULL,

    CONSTRAINT balances_pk PRIMARY KEY ([source], balance_type, account_id, date_from)  /* If we generally want each account_id per some balance_type */
--     CONSTRAINT balances_pk PRIMARY KEY ([source], account_id, balance_type, date_from)  /* If we generally want each balance_type per some account_id */
);
INSERT INTO dbo.bill_balances
    SELECT
        balance_natural_key AS natural_key,
        [source],
        balance_type,
        account_id,
        account_closing_date AS date_from,
        COALESCE(DATEADD(
            DAY, -1,
            LEAD(account_closing_date) OVER(
                PARTITION BY account_id, balance_type
                ORDER BY account_closing_date
            )
        ), '9999-12-31') AS date_to,
        CAST(IIF(
            account_closing_date = MAX(account_closing_date) OVER(PARTITION BY account_id, balance_type),
            1, 0
        ) AS BIT) AS current_flag,
        currency,
        balance
    FROM (
        SELECT DISTINCT
            balance_natural_key,
            [source],
            account_id,
            account_closing_date,
            balance_type,
            currency,
            balance
        FROM Allica.Balances
        WHERE [source] = 'HAZEL'
    ) AS dedup
;

-- DROP INDEX IF EXISTS balances_current_flag ON dbo.bill_balances;
CREATE NONCLUSTERED INDEX balances_current_flag
    ON dbo.bill_balances([source], account_id, date_from)
    INCLUDE (balance_type, currency, balance)
    WHERE current_flag = 1
;
-- DROP INDEX IF EXISTS balances_date_from_to ON dbo.bill_balances;
CREATE NONCLUSTERED INDEX balances_date_from_to
    ON dbo.bill_balances(date_from, date_to)
    INCLUDE (balance)
;
-- DROP INDEX IF EXISTS balances_date_to_from ON dbo.bill_balances;
CREATE NONCLUSTERED INDEX balances_date_to_from
    ON dbo.bill_balances(date_to, date_from)
    INCLUDE (balance)
;


/* Counts */
    SELECT 'dbo.Allica_Balances', COUNT(*)
    FROM dbo.Allica_Balances
    WHERE [source] = 'HAZEL'
UNION
    SELECT 'dbo.bill_balances', COUNT(*)
    FROM dbo.bill_balances
;


/* Bill Balances */
SELECT TOP 20 *
FROM dbo.bill_balances
;


/*
    + Compare Against Allica.Balances
*/

/* dbo.bill_balances Latest Balances - V1 */
SELECT
    [source],
    account_id,
    date_from AS balance_date,
    balance_type,
    balance
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY account_id  -- , balance_type
            ORDER BY date_from DESC
        ) AS row_num
    FROM dbo.bill_balances
    WHERE [source] = 'HAZEL'  /* Important to do it on the inside! */
      AND balance_type = 'Outstanding_Balance'
) AS bal
WHERE row_num = 1
--   AND account_id = 'AL200013700'

ORDER BY account_id
;


/* dbo.bill_balances Latest Balances - V2 */
SELECT
    [source],
    account_id,
    date_from AS balance_date,
    balance_type,
    balance
FROM dbo.bill_balances
WHERE [source] = 'HAZEL'
  AND balance_type = 'Outstanding_Balance'
  AND date_from = (
    SELECT MAX(date_from)
    FROM dbo.bill_balances AS bal_i
    WHERE bill_balances.account_id = bal_i.account_id
      AND bill_balances.[source] = bal_i.[source]
      AND bill_balances.balance_type = bal_i.balance_type
  )
--   AND account_id = 'AL200013700'

ORDER BY account_id
;


/* dbo.bill_balances Latest Balances - V3 */
SELECT
    [source],
    account_id,
    date_from AS balance_date,
    balance_type,
    balance
FROM (
    SELECT TOP 1 WITH TIES *
    FROM dbo.bill_balances
    WHERE [source] = 'HAZEL'
      AND balance_type = 'Outstanding_Balance'
    ORDER BY ROW_NUMBER() OVER(
        PARTITION BY account_id  -- , balance_type
        ORDER BY date_from DESC
    )
) AS bal
-- WHERE account_id = 'AL200013700'

ORDER BY account_id
;


/* dbo.bill_balances Latest Balances - V4 */
SELECT
    [source],
    account_id,
    date_from AS balance_date,
    balance_type,
    balance
FROM dbo.bill_balances
WHERE [source] = 'HAZEL'
  AND balance_type = 'Outstanding_Balance'
  AND current_flag = 1
--   AND account_id = 'AL200013700'

ORDER BY account_id
;


-- /* dbo.bill_balances Latest Balances - V4b */
-- SELECT
--     [source],
--     account_id,
--     date_from AS balance_date,
--     balance_type,
--     balance
-- FROM dbo.bill_balances
-- WHERE [source] = 'HAZEL'
--   AND balance_type = 'Outstanding_Balance'
--   AND current_flag = 1
-- --   AND account_id = 'AL200013700'
--
-- ORDER BY account_id
-- OPTION(TABLE HINT (dbo.bill_balances, INDEX(balances_current_flag)))
-- ;


/* dbo.bill_balances Latest Balances - V5 */
SELECT
    [source],
    account_id,
    date_from AS balance_date,
    balance_type,
    balance
FROM dbo.bill_balances
WHERE [source] = 'HAZEL'
  AND balance_type = 'Outstanding_Balance'
  AND GETDATE() BETWEEN date_from AND date_to
--   AND account_id = 'AL200013700'

ORDER BY account_id
;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/* Latest Balance using dbo.Allica_Balances */
SELECT TOP 20
    Account.account_id,
    Account.product,
    bal.balance,
    bal.account_closing_date AS date_from
FROM Allica.Account
    LEFT JOIN (
        SELECT
            *,
            ROW_NUMBER() OVER(
                PARTITION BY account_id  -- , balance_type
                ORDER BY account_closing_date DESC
            ) AS row_num
        FROM dbo.Allica_Balances
        WHERE [source] = 'HAZEL'  /* Important to do it on the inside! */
          AND balance_type = 'Outstanding_Balance'
    ) AS bal
        ON  bal.row_num = 1
        AND Account.source = bal.source
        AND Account.account_id = bal.account_id
WHERE Account.source = 'HAZEL'
ORDER BY Account.SK_ID
;

/* Latest Balance using Bill Balances */
SELECT TOP 20
    Account.account_id,
    Account.product,
    bill_balances.balance,
    bill_balances.date_from
FROM Allica.Account
    LEFT JOIN dbo.bill_balances
        ON  Account.source = bill_balances.source
        AND Account.account_id = bill_balances.account_id
        AND bill_balances.balance_type = 'Outstanding_Balance'
        AND bill_balances.current_flag = 1
WHERE Account.source = 'HAZEL'
ORDER BY Account.SK_ID
;
/* Latest Balance using Bill Balances - V2 (without source) */
SELECT TOP 20
    Account.account_id,
    Account.product,
    bill_balances.balance,
    bill_balances.date_from
FROM Allica.Account
    LEFT JOIN dbo.bill_balances
        ON  Account.account_id = bill_balances.account_id
        AND bill_balances.balance_type = 'Outstanding_Balance'
        AND GETDATE() BETWEEN bill_balances.date_from AND bill_balances.date_to
WHERE Account.source = 'HAZEL'
ORDER BY Account.SK_ID
;


/* Jun-22 Month-End Balance using dbo.Allica_Balances */
SELECT TOP 20
    Account.account_id,
    Account.product,
    bal.balance,
    bal.account_closing_date AS date_from
FROM Allica.Account
    LEFT JOIN (
        SELECT
            *,
            ROW_NUMBER() OVER(
                PARTITION BY account_id  -- , balance_type
                ORDER BY account_closing_date DESC
            ) AS row_num
        FROM dbo.Allica_Balances
        WHERE [source] = 'HAZEL'  /* Important to do it on the inside! */
          AND balance_type = 'Outstanding_Balance'
          AND account_closing_date < '2022-07-01'
    ) AS bal
        ON  bal.row_num = 1
        AND Account.source = bal.source
        AND Account.account_id = bal.account_id
WHERE Account.source = 'HAZEL'
ORDER BY Account.SK_ID
;

/* Jun-22 Month-End Balance using Bill Balances */
SELECT TOP 20
    Account.account_id,
    Account.product,
    bill_balances.balance,
    bill_balances.date_from
FROM Allica.Account
    LEFT JOIN dbo.bill_balances
        ON  Account.source = bill_balances.source
        AND bill_balances.balance_type = 'Outstanding_Balance'
        AND Account.account_id = bill_balances.account_id
        AND '2022-06-30' BETWEEN bill_balances.date_from AND bill_balances.date_to
WHERE Account.source = 'HAZEL'
ORDER BY Account.SK_ID
;

/* Jun-22 Month-End Balance (All Balance Types) */
SELECT TOP 20
    Account.account_id,
    Account.product,
    bill_balances.balance,
    bill_balances.date_from
FROM Allica.Account
    LEFT JOIN dbo.bill_balances
        ON  Account.source = bill_balances.source
        AND Account.account_id = bill_balances.account_id
        AND '2022-06-30' BETWEEN bill_balances.date_from AND bill_balances.date_to
WHERE Account.source = 'hazel'
ORDER BY Account.SK_ID
;


/* Latest Balance - All Balance Types V1 */
SELECT TOP 20
    Account.account_id,
    Account.product,
    bill_balances.balance,
    bill_balances.date_from
FROM Allica.Account
    LEFT JOIN dbo.bill_balances
        ON  Account.source = bill_balances.source
        AND Account.account_id = bill_balances.account_id
        AND bill_balances.current_flag = 1
WHERE Account.source = 'hazel'
ORDER BY Account.SK_ID
;

/* Latest Balance - All Balance Types V2 */
SELECT TOP 20
    Account.account_id,
    Account.product,
    bill_balances.balance,
    bill_balances.date_from
FROM Allica.Account
    LEFT JOIN dbo.bill_balances
        ON  Account.source = bill_balances.source
        AND Account.account_id = bill_balances.account_id
        AND GETDATE() BETWEEN bill_balances.date_from AND bill_balances.date_to
WHERE Account.source = 'hazel'
ORDER BY Account.SK_ID
;


/* Example using balances_date_from_to index */
SELECT SUM(balance)
FROM dbo.bill_balances
WHERE '2022-06-30' BETWEEN date_from AND date_to
OPTION(TABLE HINT (dbo.bill_balances, INDEX(balances_date_from_to)))
;
SELECT SUM(balance)
FROM dbo.bill_balances
WHERE '2022-06-30' BETWEEN date_from AND date_to
OPTION(TABLE HINT (dbo.bill_balances, INDEX(balances_date_to_from)))
;


/* Example why `SELECT *` is bad! */
SELECT *
FROM dbo.bill_balances
WHERE current_flag = 1
-- OPTION(TABLE HINT (dbo.bill_balances, INDEX(balances_current_flag)))
;
SELECT
--     natural_key,
    [source],
    account_id,
    date_from,
--     current_flag,
    balance_type,
    currency,
    balance
FROM dbo.bill_balances
WHERE current_flag = 1
;
