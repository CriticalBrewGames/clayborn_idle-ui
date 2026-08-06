# Recreate local Godot path mirrors after clone.
# Root `features/`, `singleton/`, `assets/` are the source of truth.
# When mounted under Main (local clone/link: no dev/), only verifies publishable layout.
# Requires: Developer Mode or elevated shell for mklink /J on Windows.

$ErrorActionPreference = "Stop"
$Root = $PSScriptRoot
$Dev = Join-Path $Root "dev"

function New-Junction([string]$Link, [string]$Target) {
    if (-not (Test-Path $Target)) {
        Write-Error "Missing publishable folder: $Target"
    }
    $parent = Split-Path $Link -Parent
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
    if (Test-Path $Link) {
        $item = Get-Item $Link -Force
        if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            cmd /c "rmdir `"$Link`""
        } else {
            Write-Error "Refusing to replace non-link path: $Link"
        }
    }
    cmd /c "mklink /J `"$Link`" `"$Target`""
    if ($LASTEXITCODE -ne 0) {
        Write-Error "mklink failed for $Link. Enable Developer Mode or run as Administrator."
    }
    Write-Host "  $Link -> $Target"
}

foreach ($name in @("features", "singleton", "assets")) {
    if (-not (Test-Path (Join-Path $Root $name))) {
        Write-Error "Missing publishable folder: $(Join-Path $Root $name)"
    }
}

$devProject = Join-Path $Dev "project.godot"
if (-not (Test-Path $devProject)) {
    Write-Host "UI: Main local mount detected (no dev/). Publishable folders OK."
    exit 0
}

New-Junction (Join-Path $Dev "ui\features") (Join-Path $Root "features")
New-Junction (Join-Path $Dev "ui\singleton") (Join-Path $Root "singleton")
New-Junction (Join-Path $Dev "assets") (Join-Path $Root "assets")

Write-Host "UI setup OK."
Write-Host "  Open: $Dev\project.godot"
