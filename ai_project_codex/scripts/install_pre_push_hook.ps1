$ErrorActionPreference = "Stop"

$hookSource = Join-Path ".githooks" "pre-push"
$hookDir = Join-Path ".git" "hooks"
$hookTarget = Join-Path $hookDir "pre-push"

if (-not (Test-Path $hookSource)) {
    throw "Hook source not found at $hookSource"
}

New-Item -ItemType Directory -Path $hookDir -Force | Out-Null
Copy-Item -Path $hookSource -Destination $hookTarget -Force

Write-Host "Installed pre-push hook to $hookTarget"
