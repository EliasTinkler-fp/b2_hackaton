with source as (
    select * from {{ source('b2', 'wine_quality_analysis') }}
),

staged as (
    select
        {{ dbt_utils.generate_surrogate_key(['fixed_acidity', 'volatile_acidity', 'citric_acid',
            'residual_sugar', 'chlorides', 'free_sulfur_dioxide', 'total_sulfur_dioxide',
            'density', 'pH', 'sulphates', 'alcohol', 'quality']) }}
            as wine_sample_key,
        cast(fixed_acidity as double)        as fixed_acidity,
        cast(volatile_acidity as double)     as volatile_acidity,
        cast(citric_acid as double)          as citric_acid,
        cast(residual_sugar as double)       as residual_sugar,
        cast(chlorides as double)            as chlorides,
        cast(free_sulfur_dioxide as double)  as free_sulfur_dioxide,
        cast(total_sulfur_dioxide as double) as total_sulfur_dioxide,
        cast(density as double)              as density,
        cast(pH as double)                   as ph,
        cast(sulphates as double)            as sulphates,
        cast(alcohol as double)              as alcohol,
        cast(quality as int)                 as quality_score
    from source
)

select distinct * from staged
