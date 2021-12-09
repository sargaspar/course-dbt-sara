-- sessions with add_to_cart for product+x and checkout / sessions with add_to_cart for product_x
{{
  config(
    materialized='table'
  )
}}

SELECT
SUM(DISTINCT session_id)