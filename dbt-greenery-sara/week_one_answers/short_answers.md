- How many users do we have? 130

select count(distinct user_id) from dbt_sara_g.stg_users;


- On average, how many orders do we receive per hour? 16

select 
avg(count_orders) 
from (
    select count(distinct order_id) as count_orders
           , extract(hour from created_at_utc) 
           from dbt_sara_g.stg_orders group by 2) a;

- On average, how long does an order take from being placed to being delivered?  3 days 22:13:10.504451

select 
avg(days) as avg_time_to_deliver
from (
    select 
    order_id
    , delivered_at_utc - created_at_utc as days
     from dbt_sara_g.stg_orders group by 1,2)a;

How many users have only made one purchase? Two purchases? Three+ purchases? One order:25; two orders:22; three orders:81

select 
case when count_orders = 1 then 'one_order' 
when count_orders = 2 then 'two_orders' 
when count_orders >= 3 then 'three_or_more_orders' END as user_order_count
, count(distinct user_guid) 
from (
    select user_guid
    , count(distinct order_id_guid) as count_orders 
    from dbt_sara_g.stg_orders group by 1)a group by 1;
    

On average, how many unique sessions do we have per hour?
