with calendar_bounds as (
    select
        least(
            (select min(order_date) from `fp_hack`.`b2_stg`.`stg_b2_stg__sales`),
            (select min(cast(order_datetime_ts as date)) from `fp_hack`.`b2_stg`.`stg_b2_stg__sales_orders`)
        ) as min_date,
        greatest(
            (select max(order_date) from `fp_hack`.`b2_stg`.`stg_b2_stg__sales`),
            (select max(cast(order_datetime_ts as date)) from `fp_hack`.`b2_stg`.`stg_b2_stg__sales_orders`)
        ) as max_date
),
calendar as (
    select explode(sequence(min_date, max_date, interval 1 day)) as calendar_date
    from calendar_bounds
)
select
    cast(date_format(calendar_date, 'yyyyMMdd') as int) as date_sk,
    calendar_date as date_day,
    year(calendar_date) as year_num,
    quarter(calendar_date) as quarter_num,
    month(calendar_date) as month_num,
    day(calendar_date) as day_of_month,
    dayofweek(calendar_date) as day_of_week,
    date_format(calendar_date, 'E') as day_name_short
from calendar