@echo off
REM Script para actualizar index.html y subir cambios a GitHub en Windows

SET REPO_DIR=%USERPROFILE%\Anclora-web
SET UPDATED_INDEX=%USERPROFILE%\Downloads\index-anclora-final.html

echo Reemplazando index.html en %REPO_DIR%

IF NOT EXIST "%UPDATED_INDEX%" (
    echo ❌ No se encontró el archivo actualizado en %UPDATED_INDEX%
    pause
    exit /b
)

IF NOT EXIST "%REPO_DIR%" (
    echo ❌ No se encontró la carpeta del repositorio en %REPO_DIR%
    pause
    exit /b
)

copy /Y "%UPDATED_INDEX%" "%REPO_DIR%\index.html"
cd /D "%REPO_DIR%"

git add index.html
git commit -m "✨ Mejora de legibilidad del eslogan + animación de ancla corregida"
git push origin main

echo ✅ Actualización enviada a GitHub.
pause
