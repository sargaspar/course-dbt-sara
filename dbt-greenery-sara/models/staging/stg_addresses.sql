{{
  config(
    materialized='view'
  )
}}

with addresses_source as (
    select *
    from {{ source('tutorial', 'addresses') }}
)

, renamed_addresses as (
    select
    id                  as user_id
    , address_id        as address_guid
    , address
    , zipcode
    , state
    , country
    
from addresses_source
)

select * from renamed_addresses
