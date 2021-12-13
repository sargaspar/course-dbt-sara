-- sessions with add_to_cart for product+x and checkout / sessions with add_to_cart for product_x
{{
  config(
    materialized='table'
  )
}}

SELECT
--session_date_utc
--,
 SUM(level1)/NULLIF(SUM(unique_sessions),0) as percent_sessions_with_pageview
, SUM(level2)/NULLIF(SUM(level1),0) as percent_pageview_sessions_with_addtocart
, SUM(level3)/NULLIF(SUM(level2),0) as percent_addtocart_sessions_with_checkout
, SUM(level3)/NULLIF(SUM(level1),0) as percent_pageview_sessions_with_checkout

FROM {{ ref('int_sessions_for_funnel') }} 
--GROUP BY session_date_utc