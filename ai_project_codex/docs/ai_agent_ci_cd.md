# dbt + Databricks AI Agent CI/CD

This project now includes an AI-agent-friendly validation flow that blocks bad dbt changes before push and enforces the same checks in CI.

## What is implemented

- Branch/run-isolated CI schemas through `DBT_CI_SCHEMA`.
- Databricks profile target `ci` in `profiles.yml`.
- Pre-push guard script: `scripts/ai_pre_push_guard.ps1`.
- Core validation script: `scripts/dbt_ci_validate.ps1`.
- GitHub Actions workflow: `.github/workflows/dbt-ci.yml`.
- Hook installer: `scripts/install_pre_push_hook.ps1`.

## Required GitHub Secrets

- `DBT_DATABRICKS_HOST`
- `DBT_DATABRICKS_HTTP_PATH`
- `DBT_DATABRICKS_CATALOG`
- `DBT_DATABRICKS_TOKEN`

Optional environment variables:

- `DBT_THREADS` (default `4`)
- `DBT_DATABRICKS_CI_AUTH_TYPE` (default `pat`)

## Local setup

1. Install the pre-push hook:

```powershell
pwsh -File scripts/install_pre_push_hook.ps1
```

2. Ensure Databricks credentials are available in environment variables:

```powershell
$env:DBT_DATABRICKS_HOST="https://<workspace-url>"
$env:DBT_DATABRICKS_HTTP_PATH="/sql/1.0/warehouses/<warehouse-id>"
$env:DBT_DATABRICKS_CATALOG="<catalog>"
$env:DBT_DATABRICKS_TOKEN="<token>"
```

3. Run validation manually:

```powershell
pwsh -File scripts/dbt_ci_validate.ps1 -Target ci -Select "state:modified+"
```

## AI Agent contract (before push)

When dbt-impacting files change, the AI agent must:

1. Run `scripts/ai_pre_push_guard.ps1`.
2. Stop push if validation fails.
3. Create/update `.artifacts/ai-agent/pre-push-report.md` with:
   - changed files,
   - pass/fail result,
   - error details if failed.
4. After fixes, rerun validation until all checks pass.

## CI policy

- `dbt-ci` workflow on pull requests and `main` pushes.
- Required gate steps:
  - `dbt deps`
  - `dbt parse`
  - `dbt compile`
  - `dbt build`
  - `dbt test`
- Artifacts uploaded each run:
  - `target/manifest.json`
  - `target/run_results.json`
  - `logs/dbt.log`
