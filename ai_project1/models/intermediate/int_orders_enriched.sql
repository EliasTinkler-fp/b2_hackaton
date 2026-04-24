with orders as (
    select * from {{ ref('stg_b2__sales_orders') }}
),

customers as (
    select * from {{ ref('stg_b2__customers') }}
),

enriched as (
    select
        o.order_number,
        o.customer_id,
        c.customer_name,
        c.region,
        c.district,
        c.city,
        c.state,
        c.loyalty_segment,
        o.ordered_at,
        o.number_of_line_items,
        o.ordered_products_raw,
        o.clicked_items_raw,
        o.promo_info_raw
    from orders o
    left join customers c
        on o.customer_id = c.customer_id
)

select * from enriched
