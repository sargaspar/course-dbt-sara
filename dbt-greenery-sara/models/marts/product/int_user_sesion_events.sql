{{
  config(
    materialized='table'
  )
}}

{% set event_types = [
  "delete_from_cart"
  , "checkout"
  , "page_view"
  , "add_to_cart"
  , "package_shipped"
  , "account_created"
  ]
%}

SELECT
  user_guid
  , session_id
  , session_date_utc
  , COUNT(DISTINCT event_id) AS total_events
  {% for event_type in event_types %}
  , sum(CASE WHEN event_type = '{{event_type}}' THEN 1 ELSE 0 END) AS {{event_type}}_count
{% endfor %}
FROM {{ ref('dim_events') }}

GROUP BY    
user_guid
, session_id
, session_date_utc