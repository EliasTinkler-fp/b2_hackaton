
  
    
        create or replace table `fp_hack`.`b2_stg`.`stg_b2_stg__wine_quality_analysis`
      
      
    using delta
  
      
      
      
      
      
      
      
      as
      select
    sha2(
        concat_ws(
            '||',
            cast(fixed_acidity as string),
            cast(volatile_acidity as string),
            cast(citric_acid as string),
            cast(residual_sugar as string),
            cast(chlorides as string),
            cast(free_sulfur_dioxide as string),
            cast(total_sulfur_dioxide as string),
            cast(density as string),
            cast(pH as string),
            cast(sulphates as string),
            cast(alcohol as string),
            cast(quality as string)
        ),
        256
    ) as wine_record_sk,
    cast(fixed_acidity as double) as fixed_acidity,
    cast(volatile_acidity as double) as volatile_acidity,
    cast(citric_acid as double) as citric_acid,
    cast(residual_sugar as double) as residual_sugar,
    cast(chlorides as double) as chlorides,
    cast(free_sulfur_dioxide as double) as free_sulfur_dioxide,
    cast(total_sulfur_dioxide as double) as total_sulfur_dioxide,
    cast(density as double) as density,
    cast(pH as double) as ph,
    cast(sulphates as double) as sulphates,
    cast(alcohol as double) as alcohol,
    cast(quality as int) as quality
from `fp_hack`.`b2_stg`.`wine_quality_analysis`
  