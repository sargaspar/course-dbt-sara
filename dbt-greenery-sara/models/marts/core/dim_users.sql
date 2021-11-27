{{
  config(
    materialized='table'
  )
}}

SELECT
  u.user_id
  , u.user_guid
  , u.first_name
  , u.last_name
  , u.email
  , u.phone_number
  , u.created_at_utc
  , u.updated_at_utc
  , u.address_guid
  , a.zipcode
  , a.address
  , a.state
  , a.country


FROM {{ ref('stg_users') }} u
LEFT JOIN {{ ref('stg_addresses') }} a
  on u.user_id = a.user_id