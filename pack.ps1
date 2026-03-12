# GDBS Free — pack.ps1
# Copies the compiled GDBS binary distribution into this directory
# and deploys the zip to wwwroot for site hosting.
#
# Usage:
#   ./pack.ps1        — copy + deploy to wwwroot
#   ./pack.ps1 -skip  — just verify source exists, no copy

param([switch]$skip)

$ErrorActionPreference = 'Stop'
$root    = Split-Path $PSScriptRoot -Parent
$gdbs    = Join-Path $root '..\gdbs\dist'           # C:\repos\gdbs\dist
$wwwroot = Join-Path $root 'core\GdbsWeb.Api\wwwroot'

$version = '1.0.0'
$zipName = "GDBS-$version-win64.zip"
$srcZip  = Join-Path $gdbs $zipName

if (-not (Test-Path $srcZip)) { Write-Error "Missing: $srcZip"; exit 1 }
Write-Host "Source: $srcZip ($([math]::Round((Get-Item $srcZip).Length/1mb, 1)) MB)" -ForegroundColor Cyan

if ($skip) { Write-Host "Done (verify only)." -ForegroundColor Cyan; exit 0 }

# ── Deploy zip to wwwroot ──────────────────────────────────────────────────────
$wwwDst = Join-Path $wwwroot $zipName
Copy-Item $srcZip $wwwDst -Force
Write-Host "Deployed to wwwroot: $zipName" -ForegroundColor Green

# Remove older versions
Get-ChildItem $wwwroot -Filter 'GDBS-*.zip' |
  Where-Object { $_.Name -ne $zipName } |
  ForEach-Object { Remove-Item $_.FullName -Force; Write-Host "  Removed old: $($_.Name)" }

Write-Host "Site download: /GDBS-$version-win64.zip" -ForegroundColor Cyan
Write-Host "Done." -ForegroundColor Cyan
