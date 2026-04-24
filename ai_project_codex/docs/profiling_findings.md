# Source Profiling Findings (`fp_hack.b2_stg`)

## Summary
- Source tables profiled: 7/7
- Primary modeled domain for Kimball marts: `customers`, `sales`, `sales_orders`
- Additional analytical domains kept in staging/intermediate: telco churn variants, wine quality

## Table-by-Table Findings

### `customers`
- Row count: 28,813
- Candidate keys:
  - `customer_id`: not null, not unique (`28,670` distinct)
  - `(customer_id, valid_from)`: unique (`28,813` distinct) and not null
  - Staging key used: `customer_version_sk = sha2(customer_id || valid_from)`
- Grain hypothesis: customer version/history row (SCD-like), not purely one row per customer.
- Notes:
  - `valid_to` is mostly null/open (`27,380` rows open-ended).
  - Suitable conformed customer dimension is current/latest row per `customer_id`.

### `sales`
- Row count: 360
- Candidate keys:
  - No robust natural PK found.
  - Hash candidate `(customer_id, order_date, product_name, total_price)` has `352` distinct values; duplicates exist.
- Grain hypothesis: sales line item, potentially with duplicate lines.
- Relationship hypotheses:
  - `sales.customer_id -> customers.customer_id` is strong (25/25 sales customers found in customers).

### `sales_orders`
- Row count: 4,074
- Candidate keys:
  - `order_number` not unique (`4,000` distinct) and represents multi-event order logging.
  - Staging key used: `order_event_sk = sha2(order_number || customer_id || order_datetime)`.
- Grain hypothesis: order event/activity row.
- Relationship hypotheses:
  - `sales_orders.customer_id -> customers.customer_id` appears strong (1,942/1,942 IDs found in customers).

### `telco_customer_churn`
- Row count: 7,043
- Candidate keys:
  - `customerID` unique and not null (`7,043` distinct).
- Grain hypothesis: one row per telco customer.
- Notes:
  - `TotalCharges` has 11 missing/blank values.

### `telco_customer_churn_missing`
- Row count: 7,043
- Candidate keys:
  - `customerID` unique and not null.
- Grain hypothesis: one row per telco customer (same entity set as base table).
- Notes:
  - Higher missingness (`715` missing/blank `TotalCharges`) and nulls in other feature columns.

### `telco_customer_churn_noisy`
- Row count: 7,043
- Candidate keys:
  - `customerID` unique and not null.
- Grain hypothesis: one row per telco customer (same entity set as base table).
- Notes:
  - Numeric perturbations and noise, including negative values in sample.
  - `715` missing `TotalCharges`.

### `wine_quality_analysis`
- Row count: 1,144
- Candidate keys:
  - No natural key found.
  - Full-row fingerprint distinct count: `1,031` (duplicates exist).
- Grain hypothesis: wine sample measurement record.
- Notes:
  - Independent analytical dataset with no join key to other domains.

## Cross-Table Relationship Checks

- Customer-domain overlaps:
  - `sales.customer_id` distinct: 25, all present in `customers`.
  - `sales_orders.customer_id` distinct: 1,942, all present in `customers`.
  - `sales` and `sales_orders` overlap only partially by customer (`3` shared IDs), so direct linkage between those two tables is weak.
- Telco-domain overlaps:
  - All three telco tables share full customer key overlap (`7,043/7,043`) and can be conformed by `customerID`.
- Wine-quality table:
  - No reliable key overlaps with other domains.

## Modeling Decisions
- Kimball marts prioritize the proven retail relationship path:
  - `customers` + `sales` -> `dim_customer`, `dim_date`, `fct_sales`.
- `sales_orders` retained in intermediate for reusable event unification but not forced into fact joins due weak/proven linkage to `sales`.
- Telco variants conformed in intermediate as a quality-comparison view.
- No bridge table created; no proven many-to-many requirement for the selected mart process.

