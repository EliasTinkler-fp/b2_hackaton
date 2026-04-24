select
    sha2(concat_ws('||', cast(customer_id as string), cast(valid_from as string)), 256) as customer_version_sk,
    cast(customer_id as bigint) as customer_id,
    nullif(trim(tax_id), '') as tax_id,
    nullif(trim(tax_code), '') as tax_code,
    trim(customer_name) as customer_name,
    upper(trim(state)) as state_code,
    trim(city) as city,
    trim(postcode) as postcode,
    trim(street) as street,
    trim(number) as street_number,
    trim(unit) as unit,
    trim(region) as region,
    trim(district) as district,
    cast(lon as double) as longitude,
    cast(lat as double) as latitude,
    trim(ship_to_address) as ship_to_address,
    cast(valid_from as bigint) as valid_from_epoch,
    to_timestamp(from_unixtime(cast(valid_from as bigint))) as valid_from_ts,
    case
        when valid_to rlike '^[0-9]+$' then cast(valid_to as bigint)
        else null
    end as valid_to_epoch,
    case
        when valid_to rlike '^[0-9]+$' then to_timestamp(from_unixtime(cast(valid_to as bigint)))
        else null
    end as valid_to_ts,
    cast(units_purchased as bigint) as units_purchased,
    cast(loyalty_segment as int) as loyalty_segment
from `fp_hack`.`b2_stg`.`customers`