with sales as (
    select * from {{ ref('stg_b2__sales') }}
),

products as (
    select * from {{ ref('dim_product') }}
)

select
    s.sales_line_key,
    s.customer_id,
    p.product_key,
    s.order_date,
    s.total_price
from sales s
left join products p
    on s.product_code = p.product_code
