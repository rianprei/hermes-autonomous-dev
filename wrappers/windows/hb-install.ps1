# hb-install.ps1 — reproduce the Hermes Autonomous Dev environment (Windows)
# Usage:
#   hb-install.ps1            install from $HB_HOME (or -Source)
#   hb-install.ps1 -Bundle    create portable bundle
#   hb-install.ps1 -From TAR  install from a bundle (.tar.gz)
[CmdletBinding()]
param(
    [switch]$Bundle,
    [string]$From = "",
    [string]$Source = ""
)

$ErrorActionPreference = "Stop"
$HB_HOME = if ($env:HERMES_HOME) { $env:HERMES_HOME } else { "$HOME\.hermes" }
$BIN = "$HOME\.local\bin"
if (-not $Source) { $Source = $HB_HOME }

New-Item -ItemType Directory -Force -Path "$HB_HOME\profiles", "$HB_HOME\stacks", $BIN | Out-Null

if ($Bundle) {
    Write-Host "hb-install: gerando bundle em $HB_HOME\hb-bundle.tar.gz"
    # use tar (available on Win10+)
    tar -czf "$HB_HOME\hb-bundle.tar.gz" -C $HB_HOME `
        profiles/autonomous/config.yaml `
        profiles/autonomous-yolo/config.yaml `
        profiles/autonomous-prod/config.yaml `
        stacks `
        PROJECT_RULES_TEMPLATE.md `
        HERMES_WORKFLOW.md 2>$null
    tar -czf "$HB_HOME\hb-bundle-bin.tar.gz" -C $BIN hb.ps1 hb-auto.ps1 hb-prod.ps1 hb-audit.ps1 hb-install.ps1 2>$null
    Write-Host "hb-install: bundle pronto: $HB_HOME\hb-bundle.tar.gz (+ hb-bundle-bin.tar.gz)"
    exit 0
}

if ($From) {
    Write-Host "hb-install: instalando de $From"
    tar -xzf $From -C $HB_HOME 2>$null
    $bindir = Split-Path $From
    if (Test-Path "$bindir\hb-bundle-bin.tar.gz") { tar -xzf "$bindir\hb-bundle-bin.tar.gz" -C $BIN 2>$null }
    Write-Host "hb-install: concluido a partir do bundle."
    exit 0
}

Write-Host "hb-install: instalando a partir de $Source"
foreach ($p in @("autonomous", "autonomous-yolo", "autonomous-prod")) {
    if (Test-Path "$Source\profiles\$p\config.yaml") {
        New-Item -ItemType Directory -Force -Path "$HB_HOME\profiles\$p" | Out-Null
        Copy-Item "$Source\profiles\$p\config.yaml" "$HB_HOME\profiles\$p\" -Force
        Write-Host "  [OK] profile $p"
    } else { Write-Host "  [WARN] profile $p ausente em $Source" }
}
if (Test-Path "$Source\PROJECT_RULES_TEMPLATE.md") { Copy-Item "$Source\PROJECT_RULES_TEMPLATE.md" $HB_HOME -Force; Write-Host "  [OK] PROJECT_RULES_TEMPLATE.md" }
if (Test-Path "$Source\HERMES_WORKFLOW.md") { Copy-Item "$Source\HERMES_WORKFLOW.md" $HB_HOME -Force; Write-Host "  [OK] HERMES_WORKFLOW.md" }
if (Test-Path "$Source\stacks") { Copy-Item "$Source\stacks\*" "$HB_HOME\stacks\" -Force -Recurse; Write-Host "  [OK] stacks" }
# 10. Windows wrappers — detect source (bundle vs repo)
Write-Host "hb-install: instalando wrappers Windows..."
$wrappersWin = @("hb.ps1", "hb-auto.ps1", "hb-prod.ps1", "hb-audit.ps1", "hb-install.ps1", "hb.bat", "hb-install-check.ps1")
$winSource = ""
if ($From) {
    # installing from bundle: wrappers are at ./wrappers/windows/
    $winSource = Join-Path (Split-Path $From) "wrappers\windows"
} elseif (Test-Path "$Source\..\wrappers\windows") {
    # installing from repo clone
    $winSource = "$Source\..\wrappers\windows"
} elseif (Test-Path "$Source\wrappers\windows") {
    $winSource = "$Source\wrappers\windows"
}

if ($winSource -and (Test-Path $winSource)) {
    foreach ($w in $wrappersWin) {
        $srcPath = Join-Path $winSource $w
        if (Test-Path $srcPath) {
            Copy-Item $srcPath $BIN -Force
            Write-Host "  [OK] wrapper $w"
        } else {
            Write-Host "  [WARN] wrapper $w nao encontrado em $winSource"
        }
    }
} else {
    Write-Host "  [WARN] pasta wrappers/windows nao encontrada (bundle ou repo)"
}
Write-Host "hb-install: concluido. Proximo passo: entre num repo e rode 'hb.ps1 doctor'."
