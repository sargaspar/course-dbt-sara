{{
  config(
    materialized='table'
  )
}}

SELECT
  sp.product_guid
  , sp.product_name
  , SUM(CASE WHEN has_checkout = 1 THEN 1 ELSE 0 END) AS count_checkouts
  , COUNT(DISTINCT sp.session_id) AS count_sessions
  , ROUND(SUM(CASE WHEN has_checkout = 1 THEN 1 ELSE 0 END)*1.0/COUNT(DISTINCT sp.session_id),2) AS conversion_rate
 
FROM {{ ref('int_session_product') }} sp
LEFT JOIN  {{ ref('int_checkout_sessions') }} pe
on sp.session_id = pe.session_id


GROUP BY    
product_guid
, product_name
