## Questions week 2

### **PART ONE**
### What is our user repeat rate? 
80.5%

(Repeat Rate = Users who purchased 2 or more times / users who purchased)

```sql
    SELECT 
    (repeat_buyers*1.0/shoppers)*100 from (
        SELECT 
        SUM(CASE WHEN count_orders >0 THEN 1 ELSE 0 END) AS shoppers, 
        SUM(CASE WHEN count_orders >=2 THEN 1 ELSE 0 END) AS repeat_buyers FROM dbt_sara_g.int_user_order_facts)a
```

## What are good indicators of a user who will likely purchase again? 
## What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

Customers who have a good experience with Greenery are more likely to come back. 
For instance, Users who received their order before or on the same day of `estimated delivery`;
Users who show high engagement - visit the website on a regular cadence. or `create an account` (which is an event_type).

There probably is a correlation with repeat purchasers also being more likely to come back(loyal customers).

Contrarily, users that have a bad experience with Greenery could indicate low probability to return: long/missed delivery, low engagement - lapsed customers who haven't visited the website for a long time.

Understand users' patterns on our website would be key to predict their lifetime value. Some interesting metrics ould include recency, frecuency, time since last purchase (and probability to churn).

# Marts models
Why did you organize the models in the way you did?
- We've created in marts/core three models: 
`dim_products`, `dim_users` and `fact_orders` where we capture details about product, users and orders:
`dim_users` contain main details about Greenery's userbase, including their actual addresses and days since user_id was created;  
`dim_products` contanis main details about Greenery's inventory: product_ids, name, quantity and price;
`fact-orders` containins *order x product-level* information, which means multiple rows for those orders that include more than one product_id. That way, we can see which products are associated with every order, and be able to pinpoint best/worst selling items.

Using the above, we've created `int_user_order_facts` model under marts/marketing, which provides a summary of orders at user level: we've added some business logic / calculations for example count or orders per user, avg cost of order, avg basket size, count of orders shipped/pending/prepared/delivered, whether orders had a promotion or not, and the "age" of customers

We've also added `dim_events` and `int_pageviews` to marts/product, in which we capture page view events from greenery’s events data, and an aggregated view of events per user session: sum of interactions including pageviews, checkout, delete from cart, among others.

### **PART TWO**

## What assumptions are you making about each model? (i.e. why are you adding each test?)
- We've added some generic tests using `not_null`, `positive_values` across most columns, including `accepted_values` for `order_status`.
- Morevoer, we've added two unique tests, one for `fact_orders` where we check that product_price * quantity should equal total_order cost, and one for `int_pageviews` in which we make sure that the breakdown of events (add to cart, create acccount, etc...) equals the count of unique events overall.

# Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?
One of my tests failed for fact_orders as there was one instance of order_total < o (order_id='fd47d88b-69d6-403b-bf53-b108819098f0'). Since it was just one row, I decided to remove it by applying a filter in `fact_orders.sql`.