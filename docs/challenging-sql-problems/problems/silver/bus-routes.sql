```sql
create table bus_stops (
    bus_id    int,
    from_stop varchar,
    to_stop   varchar,
    primary key (bus_id, from_stop)
);
insert into bus_stops
values
    (1, 'Bakers March',   'West Quay Stop'),
    (3, 'Birch Park',     'Farfair'),
    (1, 'Cavendish Road', 'Bakers March'),
    (3, 'Cavendish Road', 'Birch Park'),
    (1, 'Crown Street',   'Leather Lane'),
    (3, 'Farfair',        'Golden Lane'),
    (2, 'Fellows Road',   'Riverside'),
    (2, 'Furlong Reach',  'Hillside'),
    (3, 'Golden Lane',    'Goose Green'),
    (1, 'Goose Green',    'Crown Street'),
    (3, 'Goose Green',    'Sailors Rest'),
    (2, 'Hillside',       'Fellows Road'),
    (2, 'Laddersmith',    'Furlong Reach'),
    (1, 'Leather Lane',   'Old Street'),
    (1, 'Old Street',     'Cavendish Road'),
    (2, 'Riverside',      'Laddersmith'),
    (3, 'Sailors Rest',   'Cavendish Road'),
    (1, 'West Quay Stop', 'Goose Green')
;
```
