@echo off
REM Script para abrir el proyecto Anclora en VS Code (Windows)

SET "PROYECTO=%USERPROFILE%\anclora-web"

IF NOT EXIST "%PROYECTO%\index.html" (
    echo ⚠️ No se encontró el archivo index.html en %PROYECTO%
    echo Asegúrate de haber extraído 'anclora-web-final.zip' en esa carpeta.
    pause
    exit /b
)

cd /d "%PROYECTO%"
code .
