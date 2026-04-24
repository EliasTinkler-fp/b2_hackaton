param(
    [string]$BaseRef = "origin/main",
    [string]$Target = "ci",
    [string]$StateDir = "",
    [switch]$RunFreshness
)

$ErrorActionPreference = "Stop"

function Get-ChangedFiles {
    param([string]$Ref)

    $files = @()
    $hasRef = $false
    & git rev-parse --verify $Ref *> $null
    if ($LASTEXITCODE -eq 0) {
        $hasRef = $true
    }

    if ($hasRef) {
        $baseFiles = & git diff --name-only "$Ref...HEAD"
        if ($LASTEXITCODE -eq 0 -and $baseFiles) {
            $files += $baseFiles
        }
    } else {
        $headFiles = & git diff --name-only HEAD~1..HEAD
        if ($LASTEXITCODE -eq 0 -and $headFiles) {
            $files += $headFiles
        }
    }

    $unstaged = & git diff --name-only
    if ($LASTEXITCODE -eq 0 -and $unstaged) {
        $files += $unstaged
    }

    $staged = & git diff --name-only --cached
    if ($LASTEXITCODE -eq 0 -and $staged) {
        $files += $staged
    }

    return $files | Sort-Object -Unique
}

function Is-DbtImpactingFile {
    param([string]$Path)
    return $Path -match '^(models|macros|seeds|snapshots|tests)/' -or
           $Path -match '^dbt_project\.yml$' -or
           $Path -match '^profiles\.yml$' -or
           $Path -match '^packages\.yml$' -or
           $Path -match '^dependencies\.yml$'
}

$changedFiles = Get-ChangedFiles -Ref $BaseRef
$dbtFiles = @($changedFiles | Where-Object { Is-DbtImpactingFile -Path $_ })

if (-not $dbtFiles -or $dbtFiles.Count -eq 0) {
    Write-Host "No dbt-impacting changes detected. Skipping pre-push dbt validation."
    exit 0
}

if (-not $env:DBT_CI_SCHEMA) {
    $userName = if ($env:USERNAME) { $env:USERNAME } else { "local" }
    $stamp = Get-Date -Format "yyyyMMddHHmmss"
    $env:DBT_CI_SCHEMA = "b2_ci_${userName}_$stamp".ToLower()
}

$reportDir = Join-Path ".artifacts" "ai-agent"
New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
$reportPath = Join-Path $reportDir "pre-push-report.md"

$reportHeader = @"
# AI Pre-Push Validation Report

- Timestamp: $(Get-Date -Format s)
- Base ref: $BaseRef
- Target: $Target
- CI schema: $($env:DBT_CI_SCHEMA)
- Changed dbt-impacting files:
"@

Set-Content -Path $reportPath -Value $reportHeader
$dbtFiles | ForEach-Object { Add-Content -Path $reportPath -Value "  - $_" }

try {
    $validateScript = Join-Path "scripts" "dbt_ci_validate.ps1"
    $validateArgs = @(
        "-File", $validateScript,
        "-Target", $Target,
        "-Select", "state:modified+"
    )
    if ($StateDir) {
        $validateArgs += @("-StateDir", $StateDir)
    }
    if ($RunFreshness) {
        $validateArgs += "-RunFreshness"
    }

    & pwsh @validateArgs
    if ($LASTEXITCODE -ne 0) {
        throw "Validation command failed with exit code $LASTEXITCODE"
    }

    Add-Content -Path $reportPath -Value ""
    Add-Content -Path $reportPath -Value "## Result"
    Add-Content -Path $reportPath -Value "- Status: PASS"
    Write-Host "AI pre-push guard passed."
    exit 0
} catch {
    Add-Content -Path $reportPath -Value ""
    Add-Content -Path $reportPath -Value "## Result"
    Add-Content -Path $reportPath -Value "- Status: FAIL"
    Add-Content -Path $reportPath -Value "- Error: $($_.Exception.Message)"
    Write-Error "AI pre-push guard failed. See $reportPath"
    exit 1
}
