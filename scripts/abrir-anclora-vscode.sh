#!/bin/bash
# Script para abrir el proyecto Anclora en VS Code

# Asegura que VS Code esté disponible en PATH como 'code'
if ! command -v code &> /dev/null
then
    echo "VS Code no está disponible en el PATH. Abre manualmente o añade 'code' al PATH."
    exit
fi

# Crea carpeta si no existe
mkdir -p ~/anclora-web
cd ~/anclora-web

# Si los archivos del zip aún no están extraídos, avisa
if [ ! -f "index.html" ]; then
    echo "⚠️ Asegúrate de haber extraído 'anclora-web-final.zip' en ~/anclora-web"
    exit
fi

# Abre en VS Code
code .
