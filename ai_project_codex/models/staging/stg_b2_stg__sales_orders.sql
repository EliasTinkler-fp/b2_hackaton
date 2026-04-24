select
    sha2(
        concat_ws(
            '||',
            cast(order_number as string),
            cast(customer_id as string),
            coalesce(cast(order_datetime as string), '')
        ),
        256
    ) as order_event_sk,
    trim(clicked_items) as clicked_items,
    cast(customer_id as bigint) as customer_id,
    trim(customer_name) as customer_name,
    cast(number_of_line_items as int) as number_of_line_items,
    cast(order_datetime as bigint) as order_datetime_epoch,
    case
        when order_datetime is not null then to_timestamp(from_unixtime(cast(order_datetime as bigint)))
        else null
    end as order_datetime_ts,
    cast(order_number as bigint) as order_number,
    trim(ordered_products) as ordered_products,
    trim(promo_info) as promo_info
from {{ source('b2_stg', 'sales_orders') }}

