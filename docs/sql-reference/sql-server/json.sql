/*
    JSON support

    OPENJSON
    JSON_VALUE
    JSON_QUERY

    --------------------------------------------------------------------

    SQL Server supports some JSON functionality. JSON data is just
    stored as text and is parsed on the fly.

    --------------------------------------------------------------------

    Docs:
    - https://learn.microsoft.com/en-us/sql/t-sql/functions/json-functions-transact-sql
*/
use AdventureWorks2022;
set statistics time on;


declare @JSONBlock nvarchar(max) = N'{
    "type": "Basic",
    "info": {
        "type": 1,
        "tags": ["Sport", "Water polo"],
        "address": {
            "town": "Bristol",
            "county": "Avon",
            "country": "England"
        }
    }
}'
;
/* Value and Query */
select
    @JSONBlock AS json_block,
    json_value(@JSONBlock, '$.type') as type,
    json_value(@JSONBlock, '$.info.type') as info_type,
    json_query(@JSONBlock, '$.info') as info,
    json_query(@JSONBlock, '$.info.tags') as info_tags
;


declare @JSONBlock nvarchar(max) = N'{
    "data": [
        {"id": 1, "name": "Alice"},
        {"id": 2, "name": "Bob"},
        {"id": 3, "name": "Charlie"}
    ]
}'
;
/* Open JSON */
select *
from openjson(@JSONBlock, '$.data')
-- with (
--     [id] int,
--     [name] varchar(16)
-- )
with (
    user_id int '$.id',
    user_name varchar(16) '$.name'
);
