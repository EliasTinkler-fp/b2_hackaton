
  
  
  create or replace view `fp_hack`.`b2_int`.`int_sales_orders_unified`
  
  as (
    select
    order_event_sk,
    order_number,
    customer_id,
    customer_name,
    order_datetime_ts,
    cast(order_datetime_ts as date) as order_date,
    number_of_line_items,
    clicked_items,
    ordered_products,
    promo_info
from `fp_hack`.`b2_stg`.`stg_b2_stg__sales_orders`
  )
