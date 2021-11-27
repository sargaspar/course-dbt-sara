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
, u.created_at_utc
, u.updated_at_utc
, MIN(o.order_created_at) as first_order_created_at_utc
, MAX(o.order_created_at) as last_order_created_at_utc
, COUNT(order_id) as count_orders
, AVG(o.total_order_cost) as avg_cost_order
, SUM(o.quantity)/count(o.order_id) as avg_basket_size
, SUM(CASE WHEN o.order_status = 'shipped' THEN 1 ELSE 0 END) AS count_orders_shipped
, SUM(CASE WHEN o.order_status = 'pending' THEN 1 ELSE 0 END) AS count_orders_pending
, SUM(CASE WHEN o.order_status = 'preparing' THEN 1 ELSE 0 END) AS count_orders_preparing
, SUM(CASE WHEN o.order_status = 'delivered' THEN 1 ELSE 0 END) AS count_orders_delivered
, SUM(CASE o.discount WHEN NULL THEN 0 ELSE 1 END) AS orders_with_promo

FROM {{ ref('fact_orders') }} o
LEFT JOIN {{ ref('dim_users') }} u
    on o.user_guid = u.user_guid

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
, u.created_at_utc
, u.updated_at_utc

