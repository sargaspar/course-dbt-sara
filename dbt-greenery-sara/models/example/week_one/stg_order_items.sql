{{
  config(
    materialized='table'
  )
}}

with order_items_source as (
    select *
    from {{ source('tutorial', 'order_items') }}
)

, renamed_order_items_source as (
    select
    order_id
    , product_id
    , quantity

    from order_items_source
)

select * from order_items_source