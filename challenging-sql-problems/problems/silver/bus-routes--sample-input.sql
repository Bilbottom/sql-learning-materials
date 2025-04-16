```sql
with bus_stops(bus_id, from_stop, to_stop) as (
    values
        (1, 'Stop A',        'Stop B'),
        (1, 'Stop B',        'Stop C'),
        (1, 'Stop C',        'Stop A'),
        (2, 'First Street',  'Second Street'),
        (2, 'Second Street', 'Third Street'),
        (2, 'Third Street',  'First Street')
)
```
