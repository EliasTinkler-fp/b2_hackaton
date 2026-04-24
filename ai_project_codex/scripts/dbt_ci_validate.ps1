param(
    [string]$Target = "ci",
    [string]$StateDir = "",
    [string]$Select = "state:modified+",
    [switch]$RunFreshness
)

$ErrorActionPreference = "Stop"

function Invoke-Dbt {
    param([string[]]$DbtArgs)
    if (Get-Command uv -ErrorAction SilentlyContinue) {
        & uv run dbt @DbtArgs
    } else {
        & dbt @DbtArgs
    }
    if ($LASTEXITCODE -ne 0) {
        throw "dbt command failed: dbt $($DbtArgs -join ' ')"
    }
}

function Get-SelectionArgs {
    param(
        [string]$RawSelect,
        [string]$RawStateDir
    )

    $result = @{
        Select = $RawSelect
        Args   = @()
    }

    $manifestPath = ""
    if ($RawStateDir) {
        $manifestPath = Join-Path $RawStateDir "manifest.json"
    }

    if ($RawSelect -eq "state:modified+" -and (-not $RawStateDir -or -not (Test-Path $manifestPath))) {
        $result.Select = "*"
        return $result
    }

    if ($RawStateDir -and (Test-Path $manifestPath)) {
        $result.Args += @("--state", $RawStateDir, "--defer")
    }

    return $result
}

$selection = Get-SelectionArgs -RawSelect $Select -RawStateDir $StateDir

Write-Host "Running dbt CI validation with target=$Target select=$($selection.Select)"
Invoke-Dbt -DbtArgs @("deps")
Invoke-Dbt -DbtArgs @("parse", "--target", $Target)
Invoke-Dbt -DbtArgs @("compile", "--target", $Target)
$buildArgs = @("build", "--target", $Target, "--select", $selection.Select) + $selection.Args
$testArgs = @("test", "--target", $Target, "--select", $selection.Select) + $selection.Args
Invoke-Dbt -DbtArgs $buildArgs
Invoke-Dbt -DbtArgs $testArgs

if ($RunFreshness) {
    Invoke-Dbt -DbtArgs @("source", "freshness", "--target", $Target)
}

Write-Host "dbt CI validation completed successfully."
