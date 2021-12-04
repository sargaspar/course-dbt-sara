
## Questions week 3

## What's our overall conversion rate?
36.1% 

```sql
SELECT
COUNT(DISTINCT CASE WHEN event_type = 'checkout' THEN session_id ELSE NULL END) AS count_checkouts,
, COUNT(DISTINCT session_id) AS count_sessions
, 1.0*COUNT(DISTINCT CASE WHEN event_type = 'checkout' THEN session_id ELSE NULL END)/COUNT(DISTINCT session_id) AS conversion_rate
FROM dbt_sara_g.fct_events;
```

## What is our conversion rate by product?
To answer this question, we've created two int tables and joined them, as follows:

int_session_product.sql
```sql
SELECT
    session_id
    , product_guid

FROM {{ ref('dim_events') }}

WHERE product_guid !=''

group by 
session_id
, product_guid
```

int_checkout_sessions.sql
```sql
SELECT
  session_id
  , CASE WHEN event_type='checkout' THEN 1 ELSE 0 END AS has_checkout  
  
  FROM {{ ref('dim_events') }}
  
  group by 
  session_id
  , has_checkout
  , product_guid
```

fct_conversion_products.sql
```sql 
SELECT
  sp.product_guid
  , sp.product_name
  , SUM(CASE WHEN has_checkout = 1 THEN 1 ELSE 0 END) AS count_checkouts
  , COUNT(DISTINCT sp.session_id) AS count_sessions
  , ROUND(SUM(CASE WHEN has_checkout = 1 THEN 1 ELSE 0 END)*1.0/COUNT(DISTINCT sp.session_id),2) AS conversion_rate
 
FROM {{ ref('int_session_product') }} sp
LEFT JOIN  {{ ref('int_checkout_sessions') }} pe
on sp.session_id = pe.session_id


GROUP BY    
product_guid
, product_name
  ```

  This has given results such as 56% of CR for `product_guid`: 05df0866-1a66-41d8-9ed7-e2bbcddd6a3d, or 45% for `product_guid` = 35550082-a52d-4301-8f06-05b30f6f3616
