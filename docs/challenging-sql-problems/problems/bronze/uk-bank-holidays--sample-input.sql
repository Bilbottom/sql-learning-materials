```sql
with bank_holidays("england-and-wales", "scotland", "northern-ireland") as (
    values (
        {
            division: 'england-and-wales',
            events: [
                {date: '2018-01-01', notes: '', bunting: true, title: 'New Year’s Day'},
                {date: '2018-03-30', notes: '', bunting: false, title: 'Good Friday'},
            ],
        },
        {
            division: 'scotland',
            events: [
                {date: '2018-01-01', notes: '', bunting: true, title: 'New Year’s Day'},
                {date: '2018-01-02', notes: '', bunting: true, title: '2nd January'},
            ],
        },
        {
            division: 'northern-ireland',
            events: [
                {date: '2018-01-01', notes: '', bunting: true, title: 'New Year’s Day'},
                {date: '2018-03-19', notes: 'Substitute day', bunting: true, title: 'St Patrick’s Day'},
            ],
        },
    )
)
```
