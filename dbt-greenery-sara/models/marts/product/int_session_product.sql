{{
  config(
    materialized='table'
  )
}}

SELECT
    e.session_id
    , e.product_guid
    , p.product_name

FROM {{ ref('dim_events') }} e
LEFT JOIN {{ ref('dim_products') }} p
on e.product_guid = p.product_id

WHERE product_guid !=''

group by 
session_id
, product_guid
, product_name


