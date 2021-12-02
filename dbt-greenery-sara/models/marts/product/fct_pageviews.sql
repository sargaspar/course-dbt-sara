{{
  config(
    materialized='table'
  )
}}

SELECT
  event_id
  , session_id
  , user_guid
  , event_type
  , page_url
  , event_created_at_utc 
  , session_date_utc
  , split_part(page_url, '/', 5) as product_guid

FROM {{ ref('dim_events') }} 
WHERE event_type = 'page_view'