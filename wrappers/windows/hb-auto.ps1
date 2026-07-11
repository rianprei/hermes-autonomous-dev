# hb-auto.ps1 — Windows launcher for OFF mode (trusted repos only)
$env:HB_MODE = "off"
$env:HB_PROFILE = "autonomous-yolo"
& "$PSScriptRoot\hb.ps1" @args
