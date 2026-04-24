# AI/MCP Instruction: Build dbt Data Warehouse on Databricks

## Goal

Create a Kimball-style dimensional data warehouse in dbt from existing Databricks source tables.

Use:
- dbt project structure: sources → staging → intermediate → marts
- Kimball methodology: facts, dimensions, conformed dimensions, declared grain
- Databricks/Delta best practices
- Clear documentation, tests, and lineage

## Environment

- **Adapter:** dbt-databricks >= 1.11
- **Source catalog/schema:** `fp_hack.b2_stg`
- **Target catalog/schema for intermediate models:** `fp_hack.b2_int`
- **Source tables:**
  - `customers`
  - `sales`
  - `sales_orders`
  - `telco_customer_churn`
  - `telco_customer_churn_missing`
  - `telco_customer_churn_noisy`
  - `wine_quality_analysis`

## Input

Assume source tables are raw/bronze. No business descriptions or relationships are provided upfront — the agent must reverse-engineer relationships, grain, and business context by profiling the data (inspecting schemas, sample rows, value distributions, and foreign key patterns).

---

## Workflow

Follow these steps iteratively. Validate each step before moving to the next.

### Step 1: Profile source tables

- Inspect all source table schemas (columns, data types)
- Pull sample rows from each table
- Identify primary keys, foreign keys, and join relationships
- Determine the grain of each table
- Document findings before proceeding

### Step 2: Define sources

- Create `models/sources/_sources.yml` with all source tables
- Include column descriptions based on profiling
- Run `dbt compile` to validate

### Step 3: Build staging models

- Create one `stg_<source>__<entity>.sql` per source table
- Rename columns to consistent conventions (snake_case, meaningful names)
- Cast data types explicitly
- Run `dbt run --select staging` and fix any errors before continuing

### Step 4: Build intermediate and mart models

- Create intermediate models for business logic joins and transformations
- Create dimension tables (`dim_<entity>.sql`) and fact tables (`fct_<process>.sql`)
- Only create bridge tables if many-to-many relationships exist in the data
- Run `dbt run` and fix any errors before continuing

### Step 5: Add tests and documentation

- Add generic tests: `not_null`, `unique` on all primary keys
- Add referential integrity tests between facts and dimensions
- Add column descriptions to all mart models
- Run `dbt test` and ensure all tests pass

---

## Definition of Done

- [ ] All models build successfully with `dbt run`
- [ ] `dbt test` passes with tests on every primary key and foreign key
- [ ] At least one fact table and two dimension tables are queryable in Databricks
- [ ] Documentation generated with `dbt docs generate`
- [ ] Source-to-mart lineage is traceable through the DAG
