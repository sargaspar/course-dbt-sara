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
  , created_at_utc as event_created_at_utc
  , DATE(created_at_utc) as session_date_utc
  , split_part(page_url, '/', 5) as product_guid

FROM {{ ref('stg_events') }} 

