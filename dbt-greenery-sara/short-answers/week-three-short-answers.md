
## Questions week 3

## What's our overall conversion rate?
36.1% 

```sql
SELECT
COUNT(DISTINCT CASE WHEN event_type = 'checkout' THEN session_id ELSE NULL END) AS count_checkouts,
COUNT(DISTINCT session_id) AS count_sessions,
1.0*COUNT(DISTINCT CASE WHEN event_type = 'checkout' THEN session_id ELSE NULL END)/COUNT(DISTINCT session_id) AS conversion_rate
FROM dbt_sara_g.fct_events;
```

## What is our conversion rate by product?
 
