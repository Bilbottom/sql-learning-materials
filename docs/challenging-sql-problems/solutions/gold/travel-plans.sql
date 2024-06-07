```sql
select *
from values
    ('New York - London Gatwick - London St Pancras - Paris', '2024-01-01 18:00:00', '2024-01-02 14:30:00', '20:30:00', 212.00),
    ('New York - Paris',                                      '2024-01-01 23:00:00', '2024-01-02 16:45:00', '17:45:00', 279.00)
as solution(route, departure_datetime_utc, arrival_datetime_utc, duration, cost)
```
