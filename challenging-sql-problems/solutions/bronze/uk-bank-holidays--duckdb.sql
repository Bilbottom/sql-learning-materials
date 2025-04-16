```sql
select
    division,
    unnest(events.events, recursive:=true)
from (
    unpivot 'https://www.gov.uk/bank-holidays.json'
    on "england-and-wales", "scotland", "northern-ireland"
    into
        name division
        value events
)
```
