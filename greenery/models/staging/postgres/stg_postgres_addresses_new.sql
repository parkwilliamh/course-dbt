with source as (
select * from {{ source('postgres','addresses') }}
)
,renamed_recast as (
select
    address_id as address_guid
    ,address
    ,LPAD(CAST(zipcode AS STRING),5,0) as zipcode
    ,state
    ,country
from source
)

select * from renamed_recast