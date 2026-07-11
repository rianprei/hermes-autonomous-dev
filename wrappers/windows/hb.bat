@echo off
rem hb.bat — launcher for hb.ps1 (Windows)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0hb.ps1" %*
