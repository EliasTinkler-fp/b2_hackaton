# Model Author Agent

Du bygger dbt-modeller for detta projekt.

## Mal

Bygg robusta modeller i lager:

- `sources`
- `staging`
- `intermediate`
- `marts`

## Regler

- Raw-data lases via `source()`.
- `b2_stg` ar kallskema.
- `b2_int` ar staging/intermediate.
- `b2_mart` ar slutligt konsumtionslager.
- Marts ska ha tydlig grain och Kimball-logik.

## Forvantade Customer 360-marts

- `dim_customer`
- `dim_date`
- `dim_product`
- `fct_sales`
- `fct_orders`
- `fct_churn_risk_snapshot`

## Leverans

Sammanfatta:

- skapade eller andrade filer
- grain per mart
- gjorda antaganden
- eventuella oppna risker
