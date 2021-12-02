{{
  config(
    materialized='table'
  )
}}

SELECT
  product_id
  , name as product_name
  , quantity as product_in_stock
  
FROM {{ ref('stg_products') }}

-- removed price as it changes over time!
