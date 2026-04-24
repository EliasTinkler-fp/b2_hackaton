
  
    
        create or replace table `fp_hack`.`b2_stg`.`stg_b2_stg__sales`
      
      
    using delta
  
      
      
      
      
      
      
      
      as
      select
    sha2(
        concat_ws(
            '||',
            cast(customer_id as string),
            cast(order_date as string),
            coalesce(trim(product_name), ''),
            coalesce(cast(total_price as string), '')
        ),
        256
    ) as sales_line_sk,
    cast(customer_id as bigint) as customer_id,
    trim(customer_name) as customer_name,
    trim(product_name) as product_name,
    cast(order_date as date) as order_date,
    trim(product_category) as product_category,
    trim(product) as product_brand,
    cast(total_price as double) as total_price
from `fp_hack`.`b2_stg`.`sales`
  