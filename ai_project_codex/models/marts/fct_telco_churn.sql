with telco as (
    select * from {{ ref('stg_b2__telco_customer_churn') }}
)

select
    customer_id as telco_customer_id,
    monthly_charges,
    total_charges,
    churn_status,
    case when churn_status = 'Yes' then 1 else 0 end as is_churned
from telco
