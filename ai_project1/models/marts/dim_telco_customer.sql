with telco as (
    select * from {{ ref('stg_b2__telco_customer_churn') }}
)

select
    customer_id as telco_customer_id,
    gender,
    is_senior_citizen,
    has_partner,
    has_dependents,
    tenure_months,
    contract_type,
    is_paperless_billing,
    payment_method,
    has_phone_service,
    has_multiple_lines,
    internet_service_type,
    has_online_security,
    has_online_backup,
    has_device_protection,
    has_tech_support,
    has_streaming_tv,
    has_streaming_movies
from telco
