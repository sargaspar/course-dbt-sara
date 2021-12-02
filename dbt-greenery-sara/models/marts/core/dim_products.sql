{{
  config(
    materialized='table'
  )
}}

SELECT
  product_id
  , name as product_name
  , quantity as products_in_stock
  , price
  
FROM {{ ref('stg_products') }}

-- removed price as it changes over time!
