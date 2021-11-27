{{
  config(
    materialized='table'
  )
}}

SELECT
oi.order_id
  , o.user_guid
  , o.created_at_utc as order_created_at
  , o.delivered_at_utc as order_delivered_at
  , o.order_cost as total_order_cost
  , o.order_total 
  , o.promo_id
  , o.shipping_service
  , o.shipping_cost
  , o.status as order_status
  , o.tracking_id
  , s.discount
  , o.delivered_at_utc - o.estimated_delivery_at_utc as estimated_actual_delivery_diff
  , o.delivered_at_utc - o.created_at_utc as time_to_delivery
  , oi.product_id 
  , oi.quantity
  , p.name as product_name
  , p.price as product_price

FROM {{ ref('stg_order_items') }} oi
LEFT JOIN {{ ref('stg_orders') }} o
  ON oi.order_id = o.order_id
LEFT JOIN {{ ref('stg_products') }} p
  ON oi.product_id = p.product_id
LEFT JOIN {{ ref('stg_promos') }} s
  ON s.promo_id = o.promo_id

WHERE order_total > 0

GROUP BY 
oi.order_id
  , o.user_guid
  , order_created_at
  , order_delivered_at
  , total_order_cost
  , o.promo_id
  , o.order_total
  , o.shipping_service
  , o.shipping_cost
  , order_status
  , o.tracking_id
  , s.discount
  , estimated_actual_delivery_diff
  , time_to_delivery
  , oi.product_id 
  , oi.quantity
  , product_name
  , product_price
