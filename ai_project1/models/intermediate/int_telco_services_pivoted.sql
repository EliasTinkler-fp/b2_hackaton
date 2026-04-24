with churn as (
    select * from {{ ref('stg_b2__telco_customer_churn') }}
),

service_counts as (
    select
        customer_id,
        gender,
        is_senior_citizen,
        has_partner,
        has_dependents,
        tenure_months,
        contract_type,
        is_paperless_billing,
        payment_method,
        monthly_charges,
        total_charges,
        churn_status,
        (case when has_phone_service = 'Yes' then 1 else 0 end
         + case when has_multiple_lines = 'Yes' then 1 else 0 end
         + case when internet_service_type != 'No' then 1 else 0 end
         + case when has_online_security = 'Yes' then 1 else 0 end
         + case when has_online_backup = 'Yes' then 1 else 0 end
         + case when has_device_protection = 'Yes' then 1 else 0 end
         + case when has_tech_support = 'Yes' then 1 else 0 end
         + case when has_streaming_tv = 'Yes' then 1 else 0 end
         + case when has_streaming_movies = 'Yes' then 1 else 0 end
        ) as active_service_count
    from churn
)

select * from service_counts
