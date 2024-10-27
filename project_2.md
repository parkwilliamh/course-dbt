# Part 1: Models

## 1. What is our user repeat rate?

79.8%

        with orders_cohort as (
            select
                user_guid
                , count(distinct order_guid) as user_orders
            from DEV_DB.DBT_PARKWILLIAM12GMAILCOM.STG_POSTGRES_ORDERS_NEW
            group by 1
        )
        
        , user_bucket as (
            select
                user_guid
                , (user_orders = 1)::int as has_one_purchases
                , (user_orders = 2)::int as has_two_purchases
                , (user_orders = 3)::int as has_three_purchases
                , (user_orders >= 2)::int as has_two_plus_purchases
            from orders_cohort
        )
        
        select
            sum(has_two_plus_purchases) as two_plus_purchases
            , count(distinct user_guid) as num_users_w_purchase
            , div0(two_plus_purchases, num_users_w_purchase) as repeat_rate
        from user_bucket


## 2. What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

Having user review data would allow us to assess user satisfaction with past orders. Positive reviews suggest that users are more likely to make future purchases from the company, whereas negative reviews indicate a decreased likelihood of repeat purchases. By analyzing existing data, we can track how often a user views a product page. The more frequently they view it, the higher the likelihood that they will make a purchase soon.

Some good indicators of a user who will likely NOT purchase again are how many times the user abandons their cart after adding items as well as users who only purchase once whenever there are giant discounts

## 3. Explain the product mart models you added. Why did you organize the models in the way you did?
In the product marts schema, I included the fact_page_views model to gather insights into various events on the page that are of interest to our stakeholders. It's crucial to track session lengths and the potential outcomes of each session, such as the number of pages viewed, whether items were added to the cart, if the user proceeded to checkout, and the number of products shipped. Additionally, I developed an intermediate data model for session aggregations to perform some preliminary transformations.


# Part 2: Tests

## 1. What assumptions are you making about each model? (i.e. why are you adding each test?)

I had to make several assumptions for this model: primary key fields must be unique, and null values are not permitted. This rule applied to almost all staging models, except for the stg_postgres_order_items table, which also had a no-null-values policy due to existing relationships. Additionally, in the events table, there is a relationship test with the users table using the user_guid field. The event_type field is restricted to accepted values such as "checkout," "package shipped," "add to cart," and "page view" to prevent messy data from entering the system.

## 2. Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?
During the walkthrough video, it was noted that the zip code value had to be a 5-digit entry, but some leading zeroes were missing. I added padding to the zip code field to include the leading zeroes.


## 3. Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.
To ensure that the state of the data at Greenery is consistently monitored, verified, and communicated to stakeholders, you can implement a robust data quality monitoring and alerting system. Here's a structured approach you might consider:

Define Data Quality Metrics:
1.  Start by determining the key data quality metrics that are important to your stakeholders. These may include factors such as accuracy, completeness, consistency, timeliness, and uniqueness.
2.  Engage with stakeholders to understand their specific data-related concerns and integrate these considerations into your metrics. 

Next, utilize a data observation tool, such as Monte Carlo, which can track the freshness of data, monitor test executions, and record outcomes. Ensure that you maintain detailed logs of test runs, including timestamps, results, and any errors that occur.

Establish Alerting Mechanisms:
1.  Set up alerts to be triggered when a test fails or when data does not meet quality standards.
2.  Use communication tools such as email or slack to notify relevant stakeholders.
3.  Classify alerts by severity to distinguish between minor issues and critical failures, preventing stakeholders from becoming overwhelmed with notifications.



# Part 3: dbt Snapshots 

## 1 Which products had their inventory change from week 1 to week 2? 
Philodendron, String of pearls, Pothos, Monstera
 
        with change as (
        select * from dev_db.dbt_parkwilliam12gmailcom.products_snapshot
        where dbt_valid_to is not null
        )
        
        select distinct p.product_id, p.name from dev_db.dbt_parkwilliam12gmailcom.products_snapshot p
        join change c on c.product_id = p.product_id and c.inventory != p.inventory

