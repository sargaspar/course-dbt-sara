-- num of sessions that had checkout event / total unique sessions
{{
  config(
    materialized='table'
  )
}}


{{sessions_with_checkout()}}
SELECT  
    SUM(has_checkout)::numeric/COUNT(session_id) as conv_rate
FROM sessions_with_checkout