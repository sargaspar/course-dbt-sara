{{
  config(
    materialized='table'
  )
}}

SELECT
  o.order_id as order_guid
  , o.user_guid
  , o.address_guid
  , o.order_cost as order_cost
  , o.order_total 
  , o.status as order_status
  , o.created_at_utc as order_created_at
  , o.delivered_at_utc as order_delivered_at
  , o.shipping_service
  , o.shipping_cost
  , o.delivered_at_utc - o.estimated_delivery_at_utc as estimated_actual_delivery_diff
  , o.delivered_at_utc - o.created_at_utc as time_to_delivery
  , o.tracking_id
  , p.promo_id
  , sum(oi.quantity) as quantity_items
  , count(oi.product_id) as unique_items

FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ ref('stg_order_items') }} oi
  ON oi.order_id = o.order_id 
LEFT JOIN  {{ ref('stg_promos') }} p
  ON p.promo_id = o.promo_id

WHERE order_total > 0

GROUP BY 
  o.order_id
  , o.user_guid
  , o.address_guid
  , order_created_at
  , order_delivered_at
  , order_cost
  , o.order_total
  , o.shipping_service
  , o.shipping_cost
  , order_status
  , estimated_actual_delivery_diff
  , time_to_delivery
  , tracking_id
  , p.promo_id

