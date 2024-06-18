```sql
with bank_holidays("england-and-wales", "scotland", "northern-ireland") as (
    values (
        {
            division: 'england-and-wales',
            events: [
                {title: 'New Year’s Day', date: '2018-01-01', notes: '', bunting: true},
                {title: 'Good Friday',    date: '2018-03-30', notes: '', bunting: false},
            ],
        },
        {
            division: 'scotland',
            events: [
                {title: 'New Year’s Day', date: '2018-01-01', notes: '', bunting: true},
                {title: '2nd January',    date: '2018-01-02', notes: '', bunting: true},
            ],
        },
        {
            division: 'northern-ireland',
            events: [
                {title: 'New Year’s Day',   date: '2018-01-01', notes: '',               bunting: true},
                {title: 'St Patrick’s Day', date: '2018-03-19', notes: 'Substitute day', bunting: true},
            ],
        },
    )
)
```
