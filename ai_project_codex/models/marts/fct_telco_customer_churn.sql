select
    sha2(cast(customer_id as string), 256) as telco_churn_fact_sk,
    customer_id,
    gender,
    senior_citizen,
    partner,
    dependents,
    tenure_months,
    tenure_band,
    contract_type,
    payment_method,
    paperless_billing,
    internet_service,
    monthly_charges,
    total_charges,
    is_churned
from {{ ref('int_telco_customer_features') }}
