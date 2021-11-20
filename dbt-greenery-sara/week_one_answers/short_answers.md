## Questions week 1

## How many users do we have? 
130

```sql
select count(distinct user_id) 
from dbt_sara_g.stg_users;
```


### On average, how many orders do we receive per hour? 
16.25

```sql
select avg(count_orders) 
from (
    select 
    extract('hour' from created_at_utc)
    ,count(distinct order_id) as count_orders
    from dbt_sara_g.stg_orders
    where created_at_utc is not null group by 1)a;
```

### On average, how long does an order take from being placed to being delivered? 
4 days approx (3 days 22:13:10.504451)

```sql
select 
avg(days) as avg_time_to_deliver
from (
    select 
    order_id
    , delivered_at_utc - created_at_utc as days
     from dbt_sara_g.stg_orders group by 1,2)a;
```

### How many users have only made one purchase? Two purchases? Three+ purchases?
One order:25; two orders:22; three orders:81

```sql
select 
case when count_orders = 1 then 'one_order' 
when count_orders = 2 then 'two_orders' 
when count_orders >= 3 then 'three_or_more_orders' END as user_order_count
, count(distinct user_guid) 
from (
    select user_guid
    , count(distinct order_id_guid) as count_orders 
    from dbt_sara_g.stg_orders group by 1)a group by 1;
```
    

### On average, how many unique sessions do we have per hour? 
120.56

```sql
select avg(total) 
from (
    select extract('hour' from  created_at_utc)
    , count(distinct session_id) as total 
    from dbt_sara_g.stg_events group by 1) a;
```