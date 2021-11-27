{{
  config(
    materialized='table'
  )
}}

SELECT
  user_id
  , user_guid
  , address_guid
  , first_name
  , last_name
  , email
  , phone_number
  , created_at_utc
  , updated_at_utc

FROM {{ ref('stg_users') }}