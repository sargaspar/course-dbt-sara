{{
  config(
    materialized='table'
      )
}}

with promos_source as (
    select *
    from {{ source('tutorial', 'promos') }}
)

, renamed_promos as (
    select 
    promo_id
    , discout as discount
    , status
    
from promos_source
)

select * from renamed_promos