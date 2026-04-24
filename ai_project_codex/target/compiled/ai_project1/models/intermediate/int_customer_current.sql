with ranked as (
    select
        *,
        row_number() over (
            partition by customer_id
            order by valid_from_epoch desc, valid_to_epoch desc nulls last
        ) as row_num
    from `fp_hack`.`b2_stg`.`stg_b2_stg__customers`
)
select
    customer_id,
    customer_name,
    state_code,
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
    valid_from_ts,
    valid_to_ts,
    units_purchased,
    loyalty_segment
from ranked
where row_num = 1