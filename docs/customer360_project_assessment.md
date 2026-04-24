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

## Rekommenderad malarkitektur

### Lager

**Sources**

- `source('b2_stg', 'customers')`
- `source('b2_stg', 'sales')`
- `source('b2_stg', 'sales_orders')`
- `source('b2_stg', 'telco_customer_churn')`
- `source('b2_stg', 'telco_customer_churn_missing')`
- `source('b2_stg', 'telco_customer_churn_noisy')`

**Staging i `b2_int`**

- standardiserade namn
- explicita typer
- enkla kvalitetsregler

**Intermediate i `b2_int`**

- order/sales-unifiering
- konformering av kund
- telco cleaning och churn-underlag

**Marts i `b2_mart`**

- `dim_customer`
- `dim_date`
- `fct_sales`
- `fct_orders`
- `fct_churn_risk_snapshot`

## Rekommenderade tabeller for projektet

### Dimensioner

**`dim_customer`**

- kundnyckel
- kundattribut
- segment/lojalitet
- geografiska attribut

**`dim_date`**

- datumnyckel
- ar, manad, vecka
- kvartal

**Valfri `dim_product`**

- produkt
- kategori
- brand

### Fakta

**`fct_sales`**

- finns redan som grund
- bor landa i `b2_mart`

**`fct_orders`**

- en rad per order eller orderevent beroende pa vald grain
- bygger pa `sales_orders` och eventuell enrichment

**`fct_churn_risk_snapshot`**

- en rad per kund och snapshot-datum
- churn-status/risk
- MRR/ARR eller intaktsproxy om mojligt
- mojliggora "at-risk revenue"

## Power BI eller app

Den enklaste leveransen ar Power BI ovanpa `b2_mart`.

Bra dashboards:

- churn-risk per kundsegment
- intakt per segment, region, produkt
- at-risk revenue
- kunder med hog risk och hogt varde

Om ni senare vill bygga en app kan samma mart-tabeller ligga bakom:

- kundsok
- segmentoversikt
- riskforklaring
- rekommenderad retention-insats

## Agenter for tester, code review och dokumentation

### Kort svar

Ja, ni kan skapa ett flode dar agenter hjalper till med:

- kodgranskning
- testforslag
- dokumentation
- dbt-model review
- PR-kommentarer

Men det viktiga ar att skilja pa:

1. **lokala agentverktyg**
2. **delat teamflode i repo/CI**

### Vad bor vara lokalt

Lokalt pa varje utvecklares dator:

- Codex eller Claude Code
- Databricks CLI-auth
- lokal `profiles.yml` eller projektlokal profil
- eventuell MCP-koppling till Databricks

Detta ar personligt eftersom auth, browser-login och lokala klienter normalt ar anvandarspecifika.

### Vad bor vara delat i repot

Det ni verkligen vill dela i teamet ar inte sjalva inloggningen, utan **regelverket och arbetsflodet**:

- gemensamma prompts/instruktioner
- kodstandard
- PR-mallar
- GitHub Actions eller Azure DevOps pipelines
- scripts for verifiering
- dbt tests
- docs-krav

Det gor att alla i teamet kan anvanda samma setup och fa samma flode.

## Hur ett delat agentflode bor sattas upp

### 1. Lagg agentregler i repot

Skapa till exempel:

- `docs/agent-workflow.md`
- `.github/pull_request_template.md`
- `.github/workflows/dbt-ci.yml`
- `prompts/reviewer.md`
- `prompts/model-author.md`
- `prompts/docs-writer.md`

Dar beskriver ni:

- hur en ny datakalla onboardas
- naming conventions
- krav pa tester
- krav pa dokumentation
- vilka PR-kontroller som maste passera

### 2. Bygg CI/CD som alltid kor samma kontroller

Exempel pa PR-flode:

1. utvecklare eller agent skapar/andrar modeller
2. reviewer-agent granskar SQL, tester och docs lokalt eller i PR
3. CI kor:
   - `dbt deps`
   - `dbt compile`
   - `dbt test`
   - eventuell `dbt docs generate`
4. merge till `main`
5. deployment till dev/qa/prod-schema

### 3. Anvand agenter som roller, inte som infrastruktur

Bra roller:

- **Model Author Agent**
  - bygger source, staging, intermediate och marts for en ny datakalla
- **Test Agent**
  - lagger till `not_null`, `unique`, `relationships`, `accepted_values`
- **Documentation Agent**
  - uppdaterar YAML descriptions och projekt-dokumentation
- **Reviewer Agent**
  - granskar grain, nycklar, namnstandard, join-risker och testluckor

Detta kan goras lokalt i Codex/Claude, men styras av filer i repot sa att alla jobbar likadant.

## Ar det bara lokalt eller kan teamet anvanda samma setup?

**Bade och.**

**Lokalt**

- varje person maste ha sin egen klient och inloggning

**Delat**

- repo-struktur
- PR-process
- CI/CD
- agentprompts
- kvalitetspolicies

Det ar den delade delen som skapar ett ateranvandbart "flode".

Om ni vill kunna saga "nu onboardar vi en ny datakalla" och fa samma process varje gang, bor ni paketera flodet som:

- en dbt-projektmall
- en onboarding-checklista
- ett CI-workflow
- agentprompts for varje roll

## Rekommenderat nasta steg

1. Gor `b2_int` till ert arbetslager for staging/intermediate.
2. Flytta eller bygg om slutliga `dim_*` och `fct_*` till `b2_mart`.
3. Bygg klart:
   - `fct_orders`
   - `fct_churn_risk_snapshot`
4. Lagg till dbt tests och YAML-docs pa alla marts.
5. Skapa ett delat CI-workflow i repot.
6. Skapa delade agentprompts for:
   - modellering
   - test
   - dokumentation
   - review

## Praktisk rekommendation for teamet

Om ni vill ha ett flode som fungerar aven for framtida datakallor, sikta pa att standardisera:

- en mall for `sources.yml`
- en mall for staging-modeller
- en mall for mart-YAML med tests/docs
- en PR-template
- en CI-pipeline
- en uppsattning agentinstruktioner i repot

Da blir agentdelen inte beroende av en enda persons laptop, utan en del av ert gemensamma arbetssatt.
