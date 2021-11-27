SELECT
    order_id
    , product_price
    , quantity
    , total_order_cost
    
FROM {{ ref('fact_orders' )}}
HAVING NOT(product_price*quantity = total_order_cost)