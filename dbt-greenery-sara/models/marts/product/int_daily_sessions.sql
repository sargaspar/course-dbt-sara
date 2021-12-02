{{
  config(
    materialized='table'
  )
}}

SELECT
  session_id
  , CASE WHEN event_type = 'checkout' then 1 else 0 end as checkout_session
  , user_guid

FROM {{ ref('stg_events') }} 