# Customer 360 + Churn & Revenue Intelligence

## Nulage utan `b2_int__martin`

Utifran den metadata som gick att lasa i Databricks ar `fp_hack.b2_int` det schema som bor vara huvudsparet om ni inte vill anvanda Martin-varianten.

### Det som finns idag i `fp_hack.b2_int`

**Staging**

- `stg_b2_stg__customers`
- `stg_b2_stg__sales`
- `stg_b2_stg__sales_orders`
- `stg_b2_stg__telco_customer_churn`
- `stg_b2_stg__telco_customer_churn_missing`
- `stg_b2_stg__telco_customer_churn_noisy`
- `stg_b2_stg__wine_quality_analysis`

**Intermediate**

- `int_customer_current`
- `int_sales_line_items`
- `int_sales_orders_unified`
- `int_telco_customer_conformed`

**Marts**

- `dim_customer`
- `dim_date`
- `fct_sales`

### Bedomning

Det finns redan en bra grund for ett Kimball-inspirerat DW, men allt ligger inte helt ratt om malbilden ar ett tydligt lagerupplagg.

**Det som ar bra**

- Staging finns for alla viktiga kalltabeller.
- Intermediate-lagret finns och ser rimligt ut for ateranvandbar logik.
- Ni har redan minst tva dimensioner och en faktatabell:
  - `dim_customer`
  - `dim_date`
  - `fct_sales`

**Det som inte ar klart an**

- `fct_orders` saknas.
- `fct_churn_risk_snapshot` saknas.
- Marts ligger idag i `b2_int`, vilket gor att staging, intermediate och marts blandas i samma schema.
- Det finns ett separat `fp_hack.b2_mart`, men dar ligger bara:
  - `dim_customer`
  - `dim_date`
  - `fct_sales`

### Slutsats

Om vi utgar fran Customer 360-projektet har ni **delvis** de fakta och dimensioner som behovs, men inte hela malbilden.

**Finns**

- `dim_customer`
- `dim_date`
- `fct_sales`

**Saknas eller bor byggas**

- `fct_orders`
- `fct_churn_risk_snapshot`
- eventuellt `dim_product` om ni vill analysera churn eller revenue per produkt
- eventuellt `dim_segment` eller segmenteringslogik som attribut pa `dim_customer`

**Ligger de ratt?**

- Logiskt: ganska ratt
- Fysiskt/schema-massigt: inte helt ratt

Det renaste upplagget ar:

- `fp_hack.b2_stg`: kallsystem och eventuellt endast raw/sources
- `fp_hack.b2_int`: staging + intermediate
- `fp_hack.b2_mart`: dimensions + facts som konsumeras av Power BI eller app

Med andra ord: om ni kor vidare pa det nuvarande sparet bor `dim_*` och `fct_*` i slutlagen flyttas eller byggas om till `b2_mart`.

## Verifierade luckor i `b2`-sparet

Efter kontroll mot Databricks metadata for `fp_hack.b2_int` och `fp_hack.b2_mart` ar den viktigaste slutsatsen att **radatan och mellanlagren finns**, men att delar av den slutliga Customer 360-martmodellen fortfarande saknas.

### Finns redan i `b2`

- `dim_customer`
- `dim_date`
- `fct_sales`

Notera att dessa idag finns bade i `b2_int` och delvis i `b2_mart`, vilket tyder pa att modellen ar pa vag men inte fullt konsoliderad till ett tydligt konsumtionslager.

### Saknas i `b2`

- `dim_product`
- `fct_orders`
- `fct_churn_risk_snapshot`

### Finns tillrackligt underlag for att bygga det saknade?

**Ja, till stor del.**

Det finns redan kolumner och mellanlager som stoder detta:

**For `fct_orders`**

- kalla: `b2_stg.sales_orders`
- staging: `b2_int.stg_b2_stg__sales_orders`
- intermediate: `b2_int.int_sales_orders_unified`

Tillgangliga nyckel- och analysfalt inkluderar bland annat:

- `order_number`
- `customer_id`
- `order_datetime_ts`
- `order_date`
- `number_of_line_items`
- `clicked_items`
- `ordered_products`
- `promo_info`

Det betyder att `fct_orders` inte saknas pa grund av brist pa data, utan pa grund av att modellen inte ar byggd som slutlig mart annu.

**For `fct_churn_risk_snapshot`**

- kalla: `b2_stg.telco_customer_churn`
- staging: `b2_int.stg_b2_stg__telco_customer_churn`
- intermediate: `b2_int.int_telco_customer_conformed`

Tillgangliga churn- och intaktsnara falt inkluderar:

- `customer_id`
- `tenure_months`
- `contract_type`
- `payment_method`
- `monthly_charges_base`
- `monthly_charges_missing_variant`
- `monthly_charges_noisy_variant`
- `total_charges_base`
- `is_churned_base`

Detta ar tillrackligt for att bygga en snapshot-fakta med churn-status och en intaktsproxy, till exempel `monthly_charges_base` som grund for "at-risk revenue".

**For `dim_product`**

- kalla: `b2_stg.sales`
- staging: `b2_int.stg_b2_stg__sales`

Tillgangliga produktfalt:

- `product_name`
- `product_category`
- `product_brand`

Det betyder att en enkel `dim_product` ocksa ar byggbar med dagens data.

### Praktisk slutsats

For Customer 360-projektet ar problemet alltsa inte att `b2`-schemat saknar kallinformation. Det som saknas ar:

- slutliga dbt-modeller for vissa marts
- tydlig placering av slutliga facts/dimensions i `b2_mart`
- tillhorande tests, docs och CI-kontroller
