select
    customer_id,
    gender,
    senior_citizen,
    partner,
    dependents,
    tenure_months,
    phone_service,
    multiple_lines,
    internet_service,
    online_security,
    online_backup,
    device_protection,
    tech_support,
    streaming_tv,
    streaming_movies,
    contract_type,
    paperless_billing,
    payment_method,
    coalesce(
        monthly_charges_base,
        monthly_charges_missing_variant,
        monthly_charges_noisy_variant
    ) as monthly_charges,
    coalesce(
        total_charges_base,
        total_charges_missing_variant,
        total_charges_noisy_variant
    ) as total_charges,
    case
        when tenure_months < 12 then 'new_customer'
        when tenure_months < 24 then 'early_tenure'
        when tenure_months < 48 then 'mid_tenure'
        else 'long_tenure'
    end as tenure_band,
    is_churned_base as is_churned
from {{ ref('int_telco_customer_conformed') }}
