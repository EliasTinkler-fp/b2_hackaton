with sales as (
    select * from {{ ref('stg_b2__sales') }}
),

products as (
    select distinct
        product_code,
        product_name,
        product_category
    from sales
)

select
    {{ dbt_utils.generate_surrogate_key(['product_code']) }} as product_key,
    product_code,
    product_name,
    product_category
from products
