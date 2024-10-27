with product_events as
(
    select
    *
    from {{ ref('int_product_events') }}
)


select 
    product_guid
    , count(distinct session_guid) as total_sessions
    , count_if(has_purchase = true) as sessions_with_purchase
    , round(cast(count_if(has_purchase = true) as float) / 
          cast(count(distinct session_guid) as float), 3) as purchase_ratio
from product_events
group by product_guid
order by product_guid