with source as (
    select * from {{ source('b2', 'sales') }}
),

staged as (
    select
        {{ dbt_utils.generate_surrogate_key(['customer_id', 'product_name', 'order_date', 'total_price']) }}
            as sales_line_key,
        cast(customer_id as bigint)          as customer_id,
        cast(customer_name as string)        as customer_name,
        cast(product_name as string)         as product_name,
        cast(order_date as date)             as order_date,
        cast(product_category as string)     as product_category,
        cast(product as string)              as product_code,
        cast(total_price as bigint)          as total_price
    from source
    qualify row_number() over (partition by customer_id, product_name, order_date, total_price order by customer_id) = 1
)

select * from staged
