select
    s.sales_line_sk,
    s.customer_id,
    c.customer_name as conformed_customer_name,
    s.product_name,
    s.product_category,
    s.product_brand,
    s.order_date,
    s.total_price
from {{ ref('stg_b2_stg__sales') }} s
left join {{ ref('int_customer_current') }} c
    on s.customer_id = c.customer_id

