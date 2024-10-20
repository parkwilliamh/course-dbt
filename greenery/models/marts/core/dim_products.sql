WITH order_items AS (
    SELECT
    product_guid
    ,COUNT(DISTINCT order_guid) as volume_of_orders
    ,SUM(quantity) as product_quantity_ordered
    FROM {{ ref('stg_postgres_order_items') }}
    GROUP BY 1
)

SELECT product_guid
,name
,price
,inventory
,order_items.volume_of_orders
,order_items.product_quantity_ordered

FROM {{ ref('stg_postgres_products_new') }} AS products
LEFT JOIN order_items USING (product_guid)