-- sessions with add_to_cart for product_x and checkout / sessions with add_to_cart for product_x
{{
  config(
    materialized='table'
  )
}}

WITH session_bool as (
SELECT
session_id
, session_date_utc
, MAX(CASE WHEN event_type='checkout' THEN 1 ELSE 0 END) as checkout
, MAX(CASE WHEN event_type='add_to_cart' or event_type='checkout' THEN 1 ELSE 0 END) as atc_checkout
, MAX(CASE WHEN event_type='page_view' or event_type ='checkout' or event_type = 'add_to_cart' THEN 1 ELSE 0 END) as atc_checkout_pv
, MAX(CASE WHEN event_type IS NOT NULL THEN 1 ELSE 0 END) as session_count
FROM {{ ref('dim_events') }} 
GROUP BY session_id
, session_date_utc
)

SELECT  
  session_date_utc
  ,
   SUM(session_count) as unique_sessions
  , SUM(CASE WHEN (atc_checkout_pv > 0 or atc_checkout > 0 or checkout > 0) THEN 1 ELSE 0 END) as level1
  , SUM(CASE WHEN (atc_checkout > 0 or checkout > 0) THEN 1 ELSE 0 END) as level2
  , SUM(CASE WHEN checkout > 0 THEN 1 ELSE 0 END) as level3
  FROM session_bool

GROUP BY 
session_date_utc
order by session_date_utc asc