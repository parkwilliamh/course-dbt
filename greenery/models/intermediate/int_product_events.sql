 {{
    config(
        materialized='view'
    )
}}


with product_sessions as
(
    select * 
    from {{ ref('stg_postgres_events_new') }}
    where product_guid is not null
),
purchase as
(
    select session_guid
    from {{ ref('stg_postgres_events_new') }}
    where event_type = 'checkout'
)

select 
    s.session_guid
    , s.product_guid
    , sum(case when p.session_guid is not null then 1
        else 0 end) as has_purchase
from product_sessions s
left join purchase p
on s.session_guid = p.session_guid
group by 1,2
order by s.product_guid, s.session_guid