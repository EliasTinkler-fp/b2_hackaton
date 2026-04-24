with source as (
    select * from {{ source('b2', 'sales_orders') }}
),

staged as (
    select
        cast(order_number as bigint)             as order_number,
        cast(customer_id as bigint)              as customer_id,
        cast(customer_name as string)            as customer_name,
        cast(order_datetime as timestamp)          as ordered_at,
        cast(number_of_line_items as int)        as number_of_line_items,
        cast(clicked_items as string)            as clicked_items_raw,
        cast(ordered_products as string)         as ordered_products_raw,
        cast(promo_info as string)               as promo_info_raw
    from source
    qualify row_number() over (partition by order_number order by order_datetime desc) = 1
)

select * from staged
