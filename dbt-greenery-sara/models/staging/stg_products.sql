{{
  config(
    materialized='view'
  )
}}

with products_source as (
    select *
    from {{ source('tutorial', 'products') }}
)

, renamed_products as (
   select 
    product_id
    , name
    , price
    , quantity

    from products_source
)

select * from renamed_products