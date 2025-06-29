@echo off
REM Script de configuración inicial para GitHub CLI y push del repositorio

echo ===============================
echo   CONFIGURACIÓN DE GITHUB CLI
echo ===============================

REM Autenticación
gh auth login

REM Confirmar estado
gh auth status

REM Confirmar datos de Git
git config --global user.name "TuNombre"
git config --global user.email "tuemail@ejemplo.com"

echo ===============================
echo   LISTO PARA HACER PUSH
echo ===============================
git add .
git commit -m "Primer commit desde script automatizado"
git push origin main

pause
