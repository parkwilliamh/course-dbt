## 1. How many users do we have? 130
	select 
	  count(distinct user_guid)
	from dev_db.dbt_parkwilliam12gmailcom.stg_postgres_users_new;

## 2. On average, how many orders do we receive per hour? 7.52
	with hourly_orders as (
	select 
	    date_trunc('hour',created_at_utc) as hour
	    , count(*) as orders
	from dev_db.dbt_parkwilliam12gmailcom.stg_postgres_orders_new
	group by 1
	)
	
	select 
	    avg(orders)
	from hourly_orders;

## 3. On average, how long does an order take from being placed to being delivered? 3.89 days
	with delivery as (
	select 
	    datediff('day',created_at_utc,delivered_at_utc) as days_until_delivered
	from dev_db.dbt_parkwilliam12gmailcom.stg_postgres_orders_new
	where status = 'delivered'
	)
	
	select 
		avg(days_until_delivered)
	from delivery;

## 4. How many users have only made one purchase? 25 Two purchases? 28 Three+ purchases? 71
	with number_of_purchases as (
	select
		user_guid
		, count(distinct order_guid) as purchases
	from dev_db.dbt_parkwilliam12gmailcom.stg_postgres_orders_new
	group by 1
	)
	
	select 
		case when purchases >= 3 then '3+' else purchases::string end as purchase_bracket
		, count(user_guid)
	from number_of_purchases
	group by 1
	order by 1;

## 5. On average, how many unique sessions do we have per hour? 16.33
	with hourly_sessions as (
	select 
	    date_trunc('hour',created_at_utc) as session_start_hour
	    , count(distinct session_guid) as sessions
	from dev_db.dbt_parkwilliam12gmailcom.stg_postgres_events_new
	group by 1
	      )
	select 
	    avg(sessions)
	from hourly_sessions;
