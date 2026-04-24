select
    sha2(concat_ws('||', wine_record_sk, cast(quality as string)), 256) as wine_quality_fact_sk,
    wine_record_sk,
    quality,
    quality_band,
    alcohol,
    total_acidity,
    residual_sugar,
    chlorides,
    density,
    free_to_total_sulfur_ratio
from {{ ref('int_wine_quality_features') }}
