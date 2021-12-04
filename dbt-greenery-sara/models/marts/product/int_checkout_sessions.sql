{{
  config(
    materialized='table'
  )
}}


SELECT
  session_id
  , CASE WHEN event_type='checkout' THEN 1 ELSE 0 END AS has_checkout  
  
  FROM {{ ref('dim_events') }}
  
  group by 
  session_id
  , has_checkout
  , product_guid


--session with product_x in add_to_cart and checkout / Session with product_x in add_to_cart