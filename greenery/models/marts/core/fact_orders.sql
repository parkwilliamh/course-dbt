WITH orders AS (
    SELECT 
        *
    FROM {{ ref(('stg_postgres_orders_new'))}}
),

addresses AS (
    SELECT
        *
    FROM {{ ref(('stg_postgres_addresses_new'))}}
),

products_in_order AS (
    SELECT 
        order_guid
        ,count(product_guid) as products_in_order
    FROM {{ ref(('stg_postgres_order_items'))}}
    GROUP BY 1
)

SELECT 
    orders.order_guid
    ,orders.user_guid
    ,orders.promo_guid
    ,orders.address_guid
    ,addresses.state
    ,addresses.country
    ,orders.created_at_utc
    ,orders.estimated_delivery_at_utc
    ,orders.delivered_at_utc
    ,orders.order_cost
    ,orders.shipping_cost
    ,orders.order_total
    ,orders.tracking_guid
    ,orders.shipping_service
    ,orders.status
    ,products_in_order.products_in_order


FROM orders
LEFT JOIN addresses
    ON addresses.address_guid=orders.address_guid
LEFT JOIN products_in_order
    ON products_in_order.order_guid=orders.order_guid