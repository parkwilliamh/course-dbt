with events as (
    select
    * 
    from {{ ref('stg_postgres_events_new') }} 
)


select
    session_guid
    ,sum(case when events.event_type='page_view' then 1 else 0 end) as page_views
    ,sum(case when events.event_type='add_to_cart' then 1 else 0 end) as add_to_carts
    ,sum(case when events.event_type='checkout' then 1 else 0 end) as checkouts
    ,sum(case when events.event_type='package_shipped' then 1 else 0 end) as packages_shipped
    ,sum(case when events.order_guid is not null then 1 else 0 end) as orders
    ,min(created_at_utc) as session_started_at
    ,max(created_at_utc) as session_ended_at

from events
group by 1