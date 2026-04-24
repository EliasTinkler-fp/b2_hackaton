with base as (
    select * from {{ ref('stg_b2_stg__telco_customer_churn') }}
),
missing as (
    select * from {{ ref('stg_b2_stg__telco_customer_churn_missing') }}
),
noisy as (
    select * from {{ ref('stg_b2_stg__telco_customer_churn_noisy') }}
)
select
    b.customer_id,
    coalesce(b.gender, m.gender, n.gender) as gender,
    coalesce(b.senior_citizen, m.senior_citizen, n.senior_citizen) as senior_citizen,
    coalesce(b.partner, m.partner, n.partner) as partner,
    coalesce(b.dependents, m.dependents, n.dependents) as dependents,
    coalesce(b.tenure_months, m.tenure_months, n.tenure_months) as tenure_months,
    coalesce(b.phone_service, m.phone_service, n.phone_service) as phone_service,
    coalesce(b.multiple_lines, m.multiple_lines, n.multiple_lines) as multiple_lines,
    coalesce(b.internet_service, m.internet_service, n.internet_service) as internet_service,
    coalesce(b.online_security, m.online_security, n.online_security) as online_security,
    coalesce(b.online_backup, m.online_backup, n.online_backup) as online_backup,
    coalesce(b.device_protection, m.device_protection, n.device_protection) as device_protection,
    coalesce(b.tech_support, m.tech_support, n.tech_support) as tech_support,
    coalesce(b.streaming_tv, m.streaming_tv, n.streaming_tv) as streaming_tv,
    coalesce(b.streaming_movies, m.streaming_movies, n.streaming_movies) as streaming_movies,
    coalesce(b.contract_type, m.contract_type, n.contract_type) as contract_type,
    coalesce(b.paperless_billing, m.paperless_billing, n.paperless_billing) as paperless_billing,
    coalesce(b.payment_method, m.payment_method, n.payment_method) as payment_method,
    b.monthly_charges as monthly_charges_base,
    m.monthly_charges as monthly_charges_missing_variant,
    n.monthly_charges as monthly_charges_noisy_variant,
    b.total_charges as total_charges_base,
    m.total_charges as total_charges_missing_variant,
    n.total_charges as total_charges_noisy_variant,
    b.is_churned as is_churned_base
from base b
left join missing m
    on b.customer_id = m.customer_id
left join noisy n
    on b.customer_id = n.customer_id

