```sql
create table user_history (
    user_id int primary key,
    last_update date not null,
    activity_history bigint not null,
);
insert into user_history
values
    (1, '2024-06-01', 1056256),
    (2, '2024-06-01', 907289368),
    (3, '2024-06-01', 201335032),
    (4, '2024-06-01', 9769312),
    (5, '2024-06-01', 246247510),
    (6, '2024-06-01', 492660983)
;
```
