{{
  config(
    materialized='table'
  )
}}

SELECT
  product_guid
  , session_id
  , session_date_utc
  , COUNT(distinct event_id) total_views
  , SUM(CASE WHEN event_type = 'delete_from_cart' THEN 1 ELSE 0 END) AS count_delete_from_cart
  , SUM(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END) AS count_checkout
  , SUM(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) AS count_page_view
  , SUM(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS count_add_to_cart
  , SUM(CASE WHEN event_type = 'package_shipped' THEN 1 ELSE 0 END) AS count_package_shipped
  , SUM(CASE WHEN event_type = 'account_created' THEN 1 ELSE 0 END) AS count_account_created
  , SUM(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END)/COUNT(distinct event_id) as conversion_rate

FROM {{ ref('dim_events') }}

GROUP BY    
product_guid
, session_id
, session_date_utc

