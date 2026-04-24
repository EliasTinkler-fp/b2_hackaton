with customers as (
    select * from {{ ref('stg_b2__customers') }}
)

select
    customer_id,
    customer_name,
    tax_id,
    tax_code,
    state,
    city,
    postcode,
    street,
    street_number,
    unit,
    region,
    district,
    longitude,
    latitude,
    ship_to_address,
    valid_from_at,
    valid_to_at,
    units_purchased,
    loyalty_segment
from customers
