

{{ dbt_utils.log_info("doing fact_conversion_rate.sql") }}

with session_events as (
  select * 
  from {{ ref('int_session_events') }}
),
purchases as (
    select 
        session_guid,
        sum(checkouts) as has_purchase
    from session_events
    group by session_guid
)

select 
    count(distinct session_guid) as total_sessions,
    sum(has_purchase) as sessions_with_purchase,
    round(cast(sum(has_purchase) as float) / cast(count(distinct session_guid) as float), 3) as conversion_ratio
from purchases