select
    sha2(concat_ws('||', s.sales_line_sk, cast(s.customer_id as string), cast(s.order_date as string)), 256) as sales_fact_sk,
    s.sales_line_sk,
    d_customer.customer_sk,
    d_date.date_sk,
    s.customer_id,
    s.conformed_customer_name as customer_name,
    s.product_name,
    s.product_category,
    s.product_brand,
    s.order_date,
    s.total_price as sales_amount
from {{ ref('int_sales_line_items') }} s
left join {{ ref('dim_customer') }} d_customer
    on s.customer_id = d_customer.customer_id
left join {{ ref('dim_date') }} d_date
    on s.order_date = d_date.date_day

