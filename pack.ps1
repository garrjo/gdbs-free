# GDBS Free — pack.ps1
# Copies compiled WASM artifacts from wasm/pkg into this directory,
# creates a versioned .zip, and copies it into wwwroot for site hosting.
#
# Usage:
#   ./pack.ps1        — copy artifacts + zip + deploy to wwwroot
#   ./pack.ps1 -skip  — copy artifacts only, no zip

param([switch]$skip)

$ErrorActionPreference = 'Stop'
$root    = Split-Path $PSScriptRoot -Parent
$pkg     = Join-Path $root 'wasm\pkg'
$here    = $PSScriptRoot
$wwwroot = Join-Path $root 'core\GdbsWeb.Api\wwwroot'

$artifacts = @(
  'gdbs_web_client.js',
  'gdbs_web_client.d.ts',
  'gdbs_web_client_bg.wasm',
  'gdbs_web_client_bg.wasm.d.ts'
)

# ── 1. Copy WASM artifacts into gdbs-free/ ──────────────────────────────────
Write-Host "Copying WASM artifacts from wasm/pkg..." -ForegroundColor Cyan
foreach ($f in $artifacts) {
  $src = Join-Path $pkg $f
  $dst = Join-Path $here $f
  if (-not (Test-Path $src)) { Write-Error "Missing: $src"; exit 1 }
  Copy-Item $src $dst -Force
  $size = (Get-Item $dst).Length
  Write-Host "  $f  ($([math]::Round($size/1024, 1)) KB)" -ForegroundColor Green
}

if ($skip) { Write-Host "`nDone (artifacts only)." -ForegroundColor Cyan; exit 0 }

# ── 2. Build the zip ─────────────────────────────────────────────────────────
$version = (Get-Content (Join-Path $here 'package.json') | ConvertFrom-Json).version
$zipName = "gdbs-free-v$version.zip"
$zipPath = Join-Path $root $zipName

$include = $artifacts + @('package.json', 'README.md', 'LICENSE') +
           (Get-ChildItem (Join-Path $here 'examples') -Filter '*.mjs' |
            ForEach-Object { "examples\$($_.Name)" })

if (Test-Path $zipPath) { Remove-Item $zipPath }
$toZip = $include | ForEach-Object { Join-Path $here $_ } | Where-Object { Test-Path $_ }
Compress-Archive -Path $toZip -DestinationPath $zipPath
$zipSize = [math]::Round((Get-Item $zipPath).Length / 1024, 1)
Write-Host "`nCreated $zipName ($zipSize KB)" -ForegroundColor Yellow

# ── 3. Copy zip into wwwroot so it's served at /gdbs-free-v{ver}.zip ─────────
$wwwDst = Join-Path $wwwroot $zipName
Copy-Item $zipPath $wwwDst -Force
Write-Host "Deployed to wwwroot: $zipName" -ForegroundColor Green

# Keep only the current version in wwwroot — remove any older zips
Get-ChildItem $wwwroot -Filter 'gdbs-free-v*.zip' |
  Where-Object { $_.Name -ne $zipName } |
  ForEach-Object { Remove-Item $_.FullName -Force; Write-Host "  Removed old: $($_.Name)" }

Write-Host "`nSite download: /gdbs-free-v$version.zip" -ForegroundColor Cyan
Write-Host "Done." -ForegroundColor Cyan
