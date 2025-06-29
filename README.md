# 🌊 Anclora – Tu Ancla para la Productividad

**Anclora** es una aplicación web centrada en ayudarte a visualizar y organizar tu rutina diaria de forma clara, limpia y calmada.  
Este repositorio contiene tanto la **landing page** con logo animado como la **aplicación funcional** en subdirectorio.

---

## 📁 Estructura del Proyecto

```
/ (raíz)
├── index.html              # Landing principal
├── app/
│   └── index.html          # Aplicación web
├── assets/
│   ├── Logo_Anclora_mejorado.mp4
│   └── logo_static.png
├── scripts/
│   ├── setup_gh_push_anclora.bat
│   └── setup_gh_push_anclora.sh
├── docs/
│   ├── docs_local_testing.md
│   ├── docs_local_testing.html
│   └── docs_local_testing.pdf
├── README.md
├── LICENSE
└── .gitignore
```

---

## 🚀 Despliegue en GitHub Pages

- El archivo `index.html` sirve como landing principal.
- La aplicación se encuentra en `app/index.html`.

1. Asegúrate de subir todo el proyecto a la rama `main`.
2. Activa GitHub Pages desde **Settings > Pages > Source: `main`**.
3. Asegúrate de que `index.html` esté en la raíz del repositorio.

---

## 🧪 Pruebas locales (sin servidor local)

1. Instala la extensión **Live Server Web Extension** en Chrome.
2. Abre `index.html` directamente con Chrome.
3. Haz clic derecho → “Open with Live Server Web Extension”.

Más detalles en: `docs/docs_local_testing.md`

---

## 🔧 Automatización con Scripts

Este proyecto incluye dos scripts para facilitar el primer `push` a GitHub desde la línea de comandos:

### 🪟 Windows (`.bat`)
- `scripts/setup_gh_push_anclora.bat`

Ejecuta este archivo haciendo doble clic o desde PowerShell. Asegúrate de editar tu nombre y correo en el script.

### 🐧 Linux/macOS (`.sh`)
- `scripts/setup_gh_push_anclora.sh`

Hazlo ejecutable con:

```bash
chmod +x scripts/setup_gh_push_anclora.sh
./scripts/setup_gh_push_anclora.sh
```

---

© 2025 Anclora · Desarrollado para productividad tranquila.
