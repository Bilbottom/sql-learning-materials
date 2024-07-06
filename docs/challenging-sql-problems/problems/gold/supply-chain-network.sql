```sql
create table locations (
    location_id   integer primary key,
    location_type varchar check (location_type in ('supplier', 'depot', 'store'))
);
create table deliveries (
    delivery_datetime timestamp,
    from_location_id  integer references locations(location_id),
    to_location_id    integer references locations(location_id),
    product_id        integer,
    quantity          integer not null,
    primary key (delivery_datetime, from_location_id, to_location_id, product_id)
);
create table sales (
    sale_datetime timestamp,
    store_id      integer references locations(location_id),
    product_id    integer,
    quantity      integer not null,
    primary key (sale_datetime, store_id, product_id)
);

insert into locations
values
    (1, 'supplier'),
    (2, 'supplier'),
    (3, 'depot'),
    (4, 'depot'),
    (5, 'depot'),
    (6, 'store'),
    (7, 'store'),
    (8, 'store')
;
insert into deliveries
values
    ('2024-01-01 01:10:50', 1, 3, 1001, 25),
    ('2024-01-01 01:23:53', 1, 4, 1001, 25),
    ('2024-01-01 04:54:05', 2, 4, 1001, 20),
    ('2024-01-01 16:23:50', 2, 5, 1001, 20),
    ('2024-01-01 20:49:37', 2, 6, 1001, 10),
    ('2024-01-02 04:46:17', 3, 7, 1001, 10),
    ('2024-01-02 05:10:39', 3, 8, 1001, 10),
    ('2024-01-02 09:44:57', 4, 6, 1001, 35),
    ('2024-01-02 11:08:09', 5, 6, 1001, 10),
    ('2024-01-02 11:47:35', 5, 7, 1001, 5),
    ('2024-01-02 13:06:56', 5, 8, 1001, 5),
    ('2024-01-02 14:18:25', 3, 5, 1001, 5),
    ('2024-01-02 15:58:54', 1, 3, 1001, 30),
    ('2024-01-02 18:22:16', 2, 4, 1001, 25),
    ('2024-01-02 23:16:51', 2, 5, 1001, 25),
    ('2024-01-03 12:43:57', 3, 6, 1001, 25),
    ('2024-01-03 14:55:35', 4, 7, 1001, 20),
    ('2024-01-03 15:49:15', 4, 8, 1001, 15),
    ('2024-01-03 18:07:21', 5, 8, 1001, 20),
    ('2024-01-03 18:12:31', 5, 4, 1001, 5),
    ('2024-01-03 19:44:16', 1, 3, 1001, 20),
    ('2024-01-03 19:37:32', 1, 4, 1001, 30),
    ('2024-01-03 22:33:48', 2, 6, 1001, 20),
    ('2024-01-04 02:46:31', 3, 6, 1001, 15),
    ('2024-01-04 05:58:24', 3, 8, 1001, 10),
    ('2024-01-04 06:04:52', 4, 7, 1001, 25),
    ('2024-01-04 13:32:47', 4, 8, 1001, 5),
    ('2024-01-04 19:32:47', 4, 6, 1001, 5),
    ('2024-01-04 20:38:40', 5, 6, 1001, 5)
;
insert into sales
values
    ('2024-01-02 07:12:21'::timestamp, 6, 1001,  2),
    ('2024-01-02 09:51:01'::timestamp, 7, 1001,  4),
    ('2024-01-02 10:55:42'::timestamp, 8, 1001,  9),
    ('2024-01-02 11:21:10'::timestamp, 7, 1001, 19),
    ('2024-01-02 15:02:20'::timestamp, 7, 1001,  1),
    ('2024-01-02 16:18:00'::timestamp, 7, 1001,  1),
    ('2024-01-02 18:47:13'::timestamp, 7, 1001,  9),
    ('2024-01-02 19:15:12'::timestamp, 8, 1001,  5),
    ('2024-01-02 20:38:01'::timestamp, 6, 1001, 14),
    ('2024-01-03 07:00:27'::timestamp, 7, 1001, 13),
    ('2024-01-03 08:56:40'::timestamp, 6, 1001,  1),
    ('2024-01-03 09:40:07'::timestamp, 6, 1001, 14),
    ('2024-01-03 10:21:06'::timestamp, 7, 1001,  4),
    ('2024-01-03 12:31:10'::timestamp, 6, 1001, 10),
    ('2024-01-03 15:56:56'::timestamp, 8, 1001,  5),
    ('2024-01-03 17:49:04'::timestamp, 7, 1001, 12),
    ('2024-01-03 18:02:34'::timestamp, 6, 1001,  1),
    ('2024-01-03 20:19:42'::timestamp, 7, 1001,  7),
    ('2024-01-03 20:28:00'::timestamp, 6, 1001,  8),
    ('2024-01-04 13:07:02'::timestamp, 7, 1001, 24),
    ('2024-01-04 14:03:39'::timestamp, 8, 1001, 16)
;
```
