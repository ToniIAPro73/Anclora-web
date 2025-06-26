#!/bin/bash

# Asegúrate de exportar previamente GITHUB_TOKEN o sustituirlo directamente aquí
TOKEN=${GITHUB_TOKEN:-"<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>"}
REPO_NAME="Anclora-web"
DESCRIPTION="App para organizar tareas con animación de ancla"
USERNAME="ToniIAPro73"

# Crear repositorio
curl -s -o response.json -w "%{http_code}" \
  -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/user/repos \
  -d "{\"name\":\"$REPO_NAME\",\"description\":\"$DESCRIPTION\",\"private\":false}" > status.txt

STATUS=$(cat status.txt)

if [[ "$STATUS" == "201" ]]; then
  echo "✅ Repositorio '$REPO_NAME' creado correctamente."

  # Inicializar git y subir archivos
  git init
  git remote add origin https://github.com/$USERNAME/$REPO_NAME.git
  git add .
  git commit -m "Versión inicial del proyecto $REPO_NAME"
  git branch -M main
  git push -u origin main
else
  echo "❌ Error al crear el repositorio. Código: $STATUS"
  cat response.json
fi

# Limpieza
rm -f status.txt response.json
