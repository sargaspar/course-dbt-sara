-- sessions with add_to_cart for product+x and checkout / sessions with add_to_cart for product_x
{{
  config(
    materialized='table'
  )
}}

{{sessions_with_checkout()}}
, session_with_product AS (
    SELECT  
        session_id,
        split_part(page_url, '/', 5) as product_id
    FROM {{ref('stg_events')}}
    WHERE event_type = add_to_cart
    GROUP BY session_id, product_id
)

SELECT  
    product_id,
    SUM(has_checkout)::numeric/COUNT(session_id) as conv_rate
FROM session_with_checkout
LEFT JOIN session_with_checkout
    USING(session_id)
GROUP BY product_id