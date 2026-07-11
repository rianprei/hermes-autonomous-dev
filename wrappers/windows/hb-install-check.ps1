# hb-install-check.ps1 — Windows health check for Hermes Autonomous Dev
# Usage: hb-install-check.ps1
# Exits 0 if OK, non-zero if issues found

$ErrorActionPreference = "Stop"
$HB_HOME = if ($env:HERMES_HOME) { $env:HERMES_HOME } else { "$HOME\.hermes" }
$BIN = "$HOME\.local\bin"

Write-Host "=== hb-install-check (Windows) ===" -ForegroundColor Cyan

$fail = 0

# 1. Hermes installed?
if (Get-Command hermes -ErrorAction SilentlyContinue) {
    Write-Host "[OK] hermes instalado: $(hermes --version 2>$null | Select-Object -First 1)"
} else {
    Write-Host "[FAIL] hermes nao encontrado no PATH" -ForegroundColor Red
    $fail = 1
}

# 2. Git available?
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "[OK] git disponivel: $(git --version)"
} else {
    Write-Host "[FAIL] git ausente" -ForegroundColor Red
    $fail = 1
}

# 3. PowerShell version (need 5.1+)
$psv = $PSVersionTable.PSVersion.Major
if ($psv -ge 5) {
    Write-Host "[OK] PowerShell $($PSVersionTable.PSVersion) (>= 5.1)"
} else {
    Write-Host "[WARN] PowerShell $psv — pode precisar 5.1+ para alguns recursos" -ForegroundColor Yellow
}

# 4. Profiles
foreach ($p in @("autonomous", "autonomous-yolo", "autonomous-prod")) {
    $cfg = "$HB_HOME\profiles\$p\config.yaml"
    if (Test-Path $cfg) { Write-Host "[OK] profile $p" } else { Write-Host "[WARN] profile $p ausente: $cfg" -ForegroundColor Yellow }
}

# 5. Model defined in autonomous profile
$autonomousCfg = "$HB_HOME\profiles\autonomous\config.yaml"
if (Test-Path $autonomousCfg) {
    if (Select-String -Path $autonomousCfg -Pattern "default:" -Quiet) {
        Write-Host "[OK] modelo definido (autonomous)"
    } else {
        Write-Host "[WARN] modelo nao definido no profile autonomous" -ForegroundColor Yellow
    }
}

# 5b. Check approvals.mode in profiles
foreach ($p in @("autonomous", "autonomous-yolo", "autonomous-prod")) {
    $cfg = "$HB_HOME\profiles\$p\config.yaml"
    if (Test-Path $cfg) {
        $mode = Select-String -Path $cfg -Pattern "approvals\.mode\s*:\s*(\w+)" | ForEach-Object { $_.Matches.Groups[1].Value }
        if ($mode) { Write-Host "[OK] $p: approvals.mode = $mode" } else { Write-Host "[WARN] $p: approvals.mode nao encontrado" -ForegroundColor Yellow }
    }
}

# 6. Inside git repo?
try { $gitRoot = (git rev-parse --show-toplevel 2>$null).Trim() }
catch { $gitRoot = "" }
if ($gitRoot) {
    Write-Host "[OK] dentro de repo git: $gitRoot"
} else {
    Write-Host "[WARN] nao esta em repo git (hb exigira)" -ForegroundColor Yellow
}

# 7. .hermes.md present?
if (Test-Path "$PWD\.hermes.md") { Write-Host "[OK] .hermes.md presente" } else { Write-Host "[WARN] .hermes.md ausente (hb criara na 1a rodada)" -ForegroundColor Yellow }

# 8. Checkpoints enabled?
if (Select-String -Path "$HB_HOME\profiles\autonomous\config.yaml" -Pattern "enabled:\s*true" -Quiet) {
    Write-Host "[OK] checkpoints habilitados"
} else {
    Write-Host "[WARN] checkpoints desligados no profile autonomous" -ForegroundColor Yellow
}

# 9. Windows wrappers in PATH?
$wrappers = @("hb.ps1", "hb-auto.ps1", "hb-prod.ps1", "hb-audit.ps1", "hb-install.ps1", "hb.bat")
foreach ($w in $wrappers) {
    if (Get-Command $w -ErrorAction SilentlyContinue) {
        Write-Host "[OK] wrapper $w no PATH"
    } else {
        Write-Host "[WARN] wrapper $w NAO no PATH (adicione $BIN ao PATH)" -ForegroundColor Yellow
    }
}

# 10. tar available (Win10 1809+)
if (Get-Command tar -ErrorAction SilentlyContinue) {
    Write-Host "[OK] tar disponivel: $(tar --version 2>$null | Select-Object -First 1)"
} else {
    Write-Host "[WARN] tar nao encontrado (necessario para hb-install --bundle/--from)" -ForegroundColor Yellow
}

# Summary
Write-Host ""
if ($fail -eq 0) {
    Write-Host "=== STATUS: OK — environment ready ===" -ForegroundColor Green
} else {
    Write-Host "=== STATUS: PROBLEMAS ENCONTRADOS ===" -ForegroundColor Red
}
exit $fail