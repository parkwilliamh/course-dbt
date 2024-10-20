with events as (
    select * 
    from {{ ref('stg_postgres_events_new') }}
)

,order_items as (
    select * 
    from {{ ref('stg_postgres_order_items') }}
)

,session_timing_agg as (
    select
        *
    from {{ ref('int_session_events_agg') }}

)

select
    e.session_guid
    , e.user_guid
    , coalesce(e.product_guid, oi.product_guid) as product_guid
    , s.session_started_at
    , s.session_ended_at
    , s.page_views
    , s.add_to_carts
    , s.checkouts
    , s.packages_shipped
    , datediff('minute', session_started_at, session_ended_at) as session_length_minutes
from events e
left join order_items oi 
    on oi.order_guid = e.order_guid
left join session_timing_agg s
    on s.session_guid = e.session_guid
--group by 1,2,3,4,5