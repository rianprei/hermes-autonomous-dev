# hb.ps1 — Hermes Autonomous Dev wrapper for Windows (native PowerShell)
# Equivalent to the Unix `hb` script. No WSL required.
# Usage:
#   hb.ps1                 -> smart mode (daily)
#   hb.ps1 -Stack python   -> apply stack rules (first run)
#   hb-auto.ps1 "task"     -> off mode (trusted repos only)
#   hb-prod.ps1 "task"     -> conservative production mode
#   hb.ps1 doctor          -> health check
#   hb.ps1 audit           -> last session summary
#   hb-install.ps1         -> reproduce environment
#
# Requirements: Windows 10/11 with PowerShell 5.1+, `hermes` and `git` on PATH.
[CmdletBinding()]
param(
    [string]$Stack = "",
    [switch]$Doctor,
    [switch]$Audit,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Rest = @()
)

$ErrorActionPreference = "Stop"
$HB_HOME = if ($env:HERMES_HOME) { $env:HERMES_HOME } else { "$HOME\.hermes" }
$BIN = "$HB_HOME\..\..\.local\bin"   # not used on Windows; hermes is on PATH
$MODE = if ($env:HB_MODE) { $env:HB_MODE } else { "smart" }
$PROFILE = if ($env:HB_PROFILE) { $env:HB_PROFILE } else { "autonomous" }

function Test-CommandExists($cmd) {
    return [bool](Get-Command $cmd -ErrorAction SilentlyContinue)
}

# ---- health check -------------------------------------------------------
if ($Doctor) {
    Write-Host "=== hb doctor ===" -ForegroundColor Cyan
    $fail = 0
    if (Test-CommandExists hermes) { Write-Host "[OK] hermes instalado" } else { Write-Host "[FAIL] hermes nao encontrado"; $fail = 1 }
    if (Test-CommandExists git)    { Write-Host "[OK] git disponivel" }    else { Write-Host "[FAIL] git ausente"; $fail = 1 }
    foreach ($p in @("autonomous", "autonomous-yolo", "autonomous-prod")) {
        if (Test-Path "$HB_HOME\profiles\$p\config.yaml") { Write-Host "[OK] profile $p" } else { Write-Host "[WARN] profile $p ausente" }
    }
    if (Select-String -Path "$HB_HOME\profiles\autonomous\config.yaml" -Pattern "default:" -Quiet) { Write-Host "[OK] modelo definido (autonomous)" } else { Write-Host "[WARN] modelo nao definido" }
    $root = git rev-parse --show-toplevel 2>$null
    if ($root) { Write-Host "[OK] dentro de repo git: $root" } else { Write-Host "[WARN] nao esta em repo git (hb exigira)" }
    if (Test-Path "$PWD\.hermes.md") { Write-Host "[OK] .hermes.md presente" } else { Write-Host "[WARN] .hermes.md ausente (hb criara na 1a rodada)" }
    if (Select-String -Path "$HB_HOME\profiles\autonomous\config.yaml" -Pattern "enabled: true" -Quiet) { Write-Host "[OK] checkpoints habilitados" } else { Write-Host "[WARN] checkpoints desligados" }
    if ($fail -eq 0) { Write-Host "=== STATUS: OK ===" } else { Write-Host "=== STATUS: PROBLEMAS ===" }
    exit $fail
}

# ---- audit -------------------------------------------------------------
if ($Audit) {
    Write-Host "=== hb audit ===" -ForegroundColor Cyan
    $db = "$HB_HOME\state.db"
    if (-not (Test-Path $db)) { Write-Host "[FAIL] state.db nao encontrado em $db"; exit 1 }
    # list tables
    $q = "SELECT name FROM sqlite_master WHERE type='table';"
    try { $tables = (sqlite3 $db $q 2>$null) } catch { $tables = $null }
    if ($tables) { Write-Host "Tabelas: $($tables -join ', ')" } else { Write-Host "Tabelas: (sqlite3 nao disponivel ou vazio)" }
    Write-Host "Logs:"; Get-ChildItem "$HB_HOME\logs" -ErrorAction SilentlyContinue | ForEach-Object { Write-Host "  $($_.Name)" }
    Write-Host "Checkpoints:"; Get-ChildItem "$HB_HOME\checkpoints" -Recurse -ErrorAction SilentlyContinue | ForEach-Object { Write-Host "  $($_.Name)" }
    exit 0
}

# ---- require a git repo -------------------------------------------------
$proj = $PWD.Path
try { $gitRoot = (git rev-parse --show-toplevel 2>$null).Trim() } catch { $gitRoot = "" }
if (-not $gitRoot) {
    Write-Host "hb: ERRO — nao esta dentro de um repositorio git. Entre no projeto primeiro." -ForegroundColor Red
    exit 1
}

# ---- copy .hermes.md if missing ---------------------------------------
if (-not (Test-Path "$proj\.hermes.md")) {
    $src = "$HB_HOME\PROJECT_RULES_TEMPLATE.md"
    if ($Stack -and (Test-Path "$HB_HOME\stacks\$Stack.md")) { $src = "$HB_HOME\stacks\$Stack.md" }
    Copy-Item $src "$proj\.hermes.md" -Force
    Write-Host "hb: copiando regras de fronteira ($src) para $proj\.hermes.md"
    Write-Host "hb: revise o .hermes.md e rode hb novamente para comecar."
    exit 0
}

# ---- git stash checkpoint if dirty ------------------------------------
$status = git status --porcelain 2>$null
if ($status) {
    Write-Host "hb: working tree sujo — criando stash de checkpoint..."
    git stash push -u -m "hb-checkpoint-$(Get-Date -UFormat %s)" 2>&1 | Out-Null
    Write-Host "hb: stash criado (recupere com: git stash pop)"
}

# ---- summary -----------------------------------------------------------
Write-Host ""
Write-Host "Hermes Autonomous" -ForegroundColor Cyan
Write-Host ("-" * 50)
Write-Host "Project : $proj"
Write-Host "Mode    : $MODE"
Write-Host "Profile : $PROFILE"
Write-Host "Checkpoint (git stash): ENABLED"
Write-Host "Checkpoint (Hermes)  : ENABLED"
Write-Host "Boundary : .hermes.md"
Write-Host ("-" * 50)

# ---- launch Hermes -----------------------------------------------------
if ($Rest.Count -gt 0) {
    $prompt = $Rest -join " "
    hermes chat --profile $PROFILE --checkpoints -q $prompt
} else {
    hermes chat --profile $PROFILE --checkpoints
}
