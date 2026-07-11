# hb-auto.ps1 — Windows launcher for OFF mode (trusted repos only)
# USE APENAS em tarefas confiáveis e repositórios sob seu controle.
# Requer confirmação explícita: -ConfirmIAcceptRisks

param(
    [switch]$ConfirmIAcceptRisks
)

if (-not $ConfirmIAcceptRisks) {
    Write-Host "⚠️  MODO OFF — SEM APROVAÇÃO — EXECUÇÃO ARBITRÁRIA POSSÍVEL" -ForegroundColor Red
    Write-Host "   Use apenas em repositórios que VOCÊ controla e confia." -ForegroundColor Yellow
    Write-Host "   Para confirmar, rode novamente com:" -ForegroundColor Yellow
    Write-Host "     hb-auto.ps1 -ConfirmIAcceptRisks \"seu comando\"" -ForegroundColor Yellow
    exit 1
}

$env:HB_MODE = "off"
$env:HB_PROFILE = "autonomous-yolo"
& "$PSScriptRoot\hb.ps1" @args