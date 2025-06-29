#!/bin/bash
# Script de configuración inicial para GitHub CLI y push del repositorio

echo "==============================="
echo "  CONFIGURACIÓN DE GITHUB CLI"
echo "==============================="

# Autenticación con GitHub
gh auth login

# Verificar estado
gh auth status

# Configurar datos de Git
git config --global user.name "TuNombre"
git config --global user.email "tuemail@ejemplo.com"

echo "==============================="
echo "  LISTO PARA HACER PUSH"
echo "==============================="

git add .
git commit -m "Primer commit desde script automatizado"
git push origin main
