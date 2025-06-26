#!/bin/bash
# Script para actualizar index.html y subirlo a GitHub

REPO_DIR=~/Anclora-web
UPDATED_INDEX_PATH=~/Downloads/index-anclora-final.html

echo "🔁 Reemplazando index.html en $REPO_DIR"

# Verifica que los archivos existan
if [ ! -f "$UPDATED_INDEX_PATH" ]; then
    echo "❌ No se encontró el archivo actualizado en $UPDATED_INDEX_PATH"
    exit 1
fi

if [ ! -d "$REPO_DIR" ]; then
    echo "❌ No se encontró el repositorio en $REPO_DIR"
    exit 1
fi

# Reemplaza el archivo
cp "$UPDATED_INDEX_PATH" "$REPO_DIR/index.html"

# Navega al repositorio
cd "$REPO_DIR"

# Añade y sube cambios
git add index.html
git commit -m "✨ Mejora de legibilidad del eslogan + animación de ancla corregida"
git push origin main

echo "✅ Actualización enviada a GitHub."
