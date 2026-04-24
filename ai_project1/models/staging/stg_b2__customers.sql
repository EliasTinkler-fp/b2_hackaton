with source as (
    select * from {{ source('b2', 'customers') }}
),

staged as (
    select
        cast(customer_id as bigint)          as customer_id,
        cast(tax_id as string)               as tax_id,
        cast(tax_code as string)             as tax_code,
        cast(customer_name as string)        as customer_name,
        cast(state as string)                as state,
        cast(city as string)                 as city,
        cast(postcode as string)             as postcode,
        cast(street as string)               as street,
        cast(number as string)               as street_number,
        cast(unit as string)                 as unit,
        cast(region as string)               as region,
        cast(district as string)             as district,
        cast(lon as double)                  as longitude,
        cast(lat as double)                  as latitude,
        cast(ship_to_address as string)      as ship_to_address,
        cast(valid_from as timestamp)         as valid_from_at,
        cast(cast(valid_to as bigint) as timestamp) as valid_to_at,
        cast(units_purchased as bigint)      as units_purchased,
        cast(loyalty_segment as int)         as loyalty_segment
    from source
    qualify row_number() over (partition by customer_id order by valid_from desc) = 1
)

select * from staged
