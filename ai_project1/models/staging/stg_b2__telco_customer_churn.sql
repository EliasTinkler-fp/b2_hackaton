with source as (
    select * from {{ source('b2', 'telco_customer_churn') }}
),

staged as (
    select
        cast(customerID as string)           as customer_id,
        cast(gender as string)               as gender,
        cast(SeniorCitizen as int)           as is_senior_citizen,
        cast(Partner as string)              as has_partner,
        cast(Dependents as string)           as has_dependents,
        cast(tenure as int)                  as tenure_months,
        cast(PhoneService as string)         as has_phone_service,
        cast(MultipleLines as string)        as has_multiple_lines,
        cast(InternetService as string)      as internet_service_type,
        cast(OnlineSecurity as string)       as has_online_security,
        cast(OnlineBackup as string)         as has_online_backup,
        cast(DeviceProtection as string)     as has_device_protection,
        cast(TechSupport as string)          as has_tech_support,
        cast(StreamingTV as string)          as has_streaming_tv,
        cast(StreamingMovies as string)      as has_streaming_movies,
        cast(Contract as string)             as contract_type,
        cast(PaperlessBilling as string)     as is_paperless_billing,
        cast(PaymentMethod as string)        as payment_method,
        cast(MonthlyCharges as double)       as monthly_charges,
        try_cast(TotalCharges as double)     as total_charges,
        cast(Churn as string)                as churn_status
    from source
)

select * from staged
