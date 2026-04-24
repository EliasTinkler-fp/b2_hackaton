select
    wine_record_sk,
    fixed_acidity,
    volatile_acidity,
    citric_acid,
    residual_sugar,
    chlorides,
    free_sulfur_dioxide,
    total_sulfur_dioxide,
    density,
    ph,
    sulphates,
    alcohol,
    quality,
    case
        when quality >= 7 then 'high'
        when quality >= 5 then 'medium'
        else 'low'
    end as quality_band,
    fixed_acidity + volatile_acidity + citric_acid as total_acidity,
    free_sulfur_dioxide / nullif(total_sulfur_dioxide, 0) as free_to_total_sulfur_ratio
from {{ ref('stg_b2_stg__wine_quality_analysis') }}
