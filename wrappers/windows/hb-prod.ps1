# hb-prod.ps1 — Windows launcher for conservative production mode
$env:HB_MODE = "smart"
$env:HB_PROFILE = "autonomous-prod"
& "$PSScriptRoot\hb.ps1" -Stack production @args
