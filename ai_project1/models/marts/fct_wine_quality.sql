with wine as (
    select * from {{ ref('stg_b2__wine_quality') }}
)

select
    wine_sample_key,
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
    quality_score
from wine
