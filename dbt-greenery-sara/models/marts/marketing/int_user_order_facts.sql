{{
  config(
    materialized='table'
  )
}}

SELECT
u.user_id
, u.user_guid
, u.first_name
, u.last_name
, u.email
, u.address_guid
, u.address
, u.zipcode
, u.state
, u.country
, u.phone_number
, u.user_created_at
, u.updated_at_utc
, u.time_customer
, COALESCE(COUNT(distinct o.order_guid),0) as count_orders
, MIN(o.order_created_at) as first_order_created_at_utc
, MAX(o.order_created_at) as last_order_created_at_utc
, SUM(order_cost) as total_user_cost
, AVG(o.order_cost) as avg_order_cost
, SUM(CASE WHEN o.order_status = 'shipped' THEN 1 ELSE 0 END) AS count_orders_shipped
, SUM(CASE WHEN o.order_status = 'pending' THEN 1 ELSE 0 END) AS count_orders_pending
, SUM(CASE WHEN o.order_status = 'preparing' THEN 1 ELSE 0 END) AS count_orders_preparing
, SUM(CASE WHEN o.order_status = 'delivered' THEN 1 ELSE 0 END) AS count_orders_delivered
, SUM(CASE o.promo_id WHEN NULL THEN 0 ELSE 1 END) AS orders_with_promo

FROM {{ ref('dim_users') }} u
LEFT JOIN {{ ref('fct_orders') }} o
  ON u.user_guid = o.user_guid 


GROUP BY
u.user_id
, u.user_guid
, u.first_name
, u.last_name
, u.email
, u.address_guid
, u.address
, u.zipcode
, u.state
, u.country
, u.phone_number
, u.user_created_at
, u.updated_at_utc 
, u.time_customer

