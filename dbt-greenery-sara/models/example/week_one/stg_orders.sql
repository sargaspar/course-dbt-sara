{{
  config(
    materialized='table'
  )
}}

with orders_source as (
    select *
    from {{ source('tutorial', 'orders') }}
)

, renamed_orders as (
    select 
    id                          as user_id
    , order_id
    , user_id                   as user_guid
    , promo_id
    , address_id                as address_guid
    , created_at                as created_at_utc
    , order_cost
    , shipping_cost
    , order_total
    , tracking_id
    , shipping_service
    , estimated_delivery_at     as estimated_delivery_at_utc
    , delivered_at              as delivered_at_utc
    , status

from orders_source
)

select * from renamed_orders
