SELECT
    order_id
    , SUM(total_item_cost) as overall_total_item_cost
    , total_order_cost
    
FROM {{ ref('fct_orders' )}}
GROUP BY 
order_id
, total_item_cost
, total_order_cost
HAVING NOT(overall_total_item_cost = total_order_cost)