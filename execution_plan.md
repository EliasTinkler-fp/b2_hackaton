# Execution Plan for `instructions.md`

## Scope
Build a Kimball-style dbt warehouse on Databricks from `fp_hack.b2_stg` into `fp_hack.b2_int`, following: sources -> staging -> intermediate -> marts, with tests/docs/lineage.

## Preconditions
- dbt Core and `dbt-databricks >= 1.11` installed
- Databricks profile configured and authenticated
- Target schema write access: `fp_hack.b2_int`
- Source read access: `fp_hack.b2_stg`

## Deliverables
- Source YAML: `models/sources/_sources.yml`
- Staging models: one per source table in `models/staging/`
- Intermediate models in `models/intermediate/`
- Mart models in `models/marts/` (`dim_*`, `fct_*`, optional bridge)
- Tests + docs in model YAML files
- Successful runs: `dbt run`, `dbt test`, `dbt docs generate`

## Phase 1: Source Profiling and Data Discovery
1. Inventory tables and schemas in `fp_hack.b2_stg`.
2. Pull sample rows (e.g., top 20 each) for all source tables.
3. Compute candidate keys:
   - Column uniqueness checks
   - Null-rate checks
4. Detect likely foreign keys:
   - Name-based heuristics (`*_id`, shared business keys)
   - Value-overlap checks between candidate key columns
5. Infer table grain and role (transaction, master, snapshot, noisy variant).
6. Record profiling output in a working note (`docs/profiling_findings.md`).

Validation gate:
- All 7 source tables have documented grain, candidate PKs, and relationship hypotheses.

## Phase 2: dbt Source Definitions
1. Create `models/sources/_sources.yml` with all source tables under source schema `fp_hack.b2_stg`.
2. Add column entries and descriptions inferred from profiling.
3. Add source freshness/tests only where reliable timestamp/key columns exist.
4. Run `dbt compile`.

Validation gate:
- `dbt compile` succeeds without source reference errors.

## Phase 3: Staging Layer Build
1. Create one staging model per raw table:
   - `stg_b2_stg__customers.sql`
   - `stg_b2_stg__sales.sql`
   - `stg_b2_stg__sales_orders.sql`
   - `stg_b2_stg__telco_customer_churn.sql`
   - `stg_b2_stg__telco_customer_churn_missing.sql`
   - `stg_b2_stg__telco_customer_churn_noisy.sql`
   - `stg_b2_stg__wine_quality_analysis.sql`
2. Standardize naming to snake_case and meaningful business names.
3. Apply explicit type casts and normalization rules (trim/lower/date parsing as needed).
4. Add staging YAML docs and tests for obvious keys.
5. Run `dbt run --select staging`.

Validation gate:
- All staging models run successfully.

## Phase 4: Intermediate + Kimball Marts
1. Build intermediate models for reusable joins/conformance logic:
   - Order/sales transaction unification
   - Customer conformance across domains (if keys support it)
   - Optional quality-clean views for noisy/missing telco variants
2. Define dimensional model at declared grains:
   - Dimensions (minimum): `dim_customer`, `dim_date` (or another robust conformed dim)
   - Fact (minimum): one process fact (likely sales/order fact)
3. Add bridge table only if many-to-many is proven from profiling.
4. Configure materializations (table/incremental where justified).
5. Run `dbt run`.

Validation gate:
- At least one `fct_*` and two `dim_*` models build and are queryable.

## Phase 5: Tests, Documentation, and Lineage
1. Add PK tests (`not_null`, `unique`) to all dimension/fact primary keys.
2. Add FK relationship tests from fact -> dimensions.
3. Complete model + column descriptions for marts.
4. Run `dbt test` and fix failures.
5. Generate docs with `dbt docs generate`.
6. Verify DAG lineage from sources -> staging -> intermediate -> marts.

Validation gate:
- `dbt test` passes.
- Docs generated and lineage graph is complete.

## Execution Checklist (Mapped to Definition of Done)
- [ ] `dbt run` succeeds
- [ ] `dbt test` passes for every PK/FK test
- [ ] At least one fact and two dimensions queryable
- [ ] `dbt docs generate` succeeds
- [ ] DAG shows complete source-to-mart lineage

## Command Sequence (Operational)
```bash
# baseline
 dbt debug
 dbt deps

# profile (using Databricks SQL or ad hoc queries)
 # inspect schema/sample/uniqueness/nulls/value overlaps per table

# implement and validate progressively
 dbt compile
 dbt run --select staging
 dbt run
 dbt test
 dbt docs generate
```

## Risk Controls
- If no robust natural PK exists, define surrogate keys using deterministic hashes.
- If source quality is poor (missing/noisy columns), isolate cleaning logic in staging/intermediate and keep marts strict.
- If relationships are ambiguous, document assumptions and keep marts narrowly scoped to proven joins.