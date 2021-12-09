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
, COUNT(CASE WHEN event_type='page_view' THEN 1 ELSE 0 END) as checkout
, COUNT(CASE WHEN event_type='add_to_cart' or event_type='checkout' THEN 1 ELSE 0 END) as atc_checkout
, COUNT(CASE WHEN event_type='page_view' or event_type ='checkout' or event_type = 'add_to_cart' THEN 1 ELSE 0 END) as atc_checkout_pv

FROM {{'stg_events'}}
GROUP BY session_id
)
SELECT  
  COUNT(CASE WHEN (atc_checkout_pv > 0 or atc_checkout > 0 or checkout > 0))

FROM session_bool