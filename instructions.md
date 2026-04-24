# AI/MCP Instruction: Build dbt Data Warehouse on Databricks

## Goal
Create a Kimball-style dimensional data warehouse in dbt from existing Databricks source tables.

Use:
- dbt project structure: sources → staging → intermediate → marts
- Kimball methodology: facts, dimensions, conformed dimensions, declared grain
- Databricks/Delta best practices
- Clear documentation, tests, and lineage

References: dbt recommends separating staging, intermediate, and marts layers; marts should represent business-defined entities at a clear grain. Databricks recommends medallion-style lakehouse layering for reliable BI-ready data products. :contentReference[oaicite:0]{index=0}

---

## Input
You will receive:
- A list of fetched Databricks tables
- Table names, schemas, columns, and data types
- Optional sample rows
- Optional relationships or business descriptions

Assume source tables are raw/bronze unless stated otherwise.

---

## Required Output
Generate a dbt project with:

```text
models/
  sources/
    _sources.yml
  staging/
    <source_system>/
      stg_<source>__<entity>.sql
      _<source_system>__models.yml
  intermediate/
    int_<business_process>__<purpose>.sql
  marts/
    core/
      dim_<entity>.sql
      fct_<business_process>.sql
      bridge_<relationship>.sql
      _core__models.yml
macros/
seeds/
snapshots/
tests/
dbt_project.yml
README.md