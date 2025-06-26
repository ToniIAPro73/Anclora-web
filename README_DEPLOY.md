# 🚀 Guía de Despliegue Rápido – ANCLORA

Este paquete contiene todo lo necesario para crear y subir automáticamente tu proyecto **ANCLORA** a GitHub.

---

## 📁 Archivos incluidos

- `github_upload_anclora.sh`: Script que crea el repositorio y sube tu código.
- `.env`: Donde debes colocar tu token personal de GitHub.
- `.gitignore`: Para evitar subir archivos sensibles como `.env`.

---

## 🔧 Pasos para desplegar

### 1. Extrae el ZIP
Coloca los archivos en la raíz del proyecto ANCLORA (donde está `index.html`).

### 2. Abre terminal en esa carpeta

### 3. Da permisos de ejecución al script

```bash
chmod +x github_upload_anclora.sh
```

### 4. Abre el archivo `.env` y pega tu token personal

```env
GITHUB_TOKEN=ghp_tuTokenAquí
```

> Puedes crear un token en: https://github.com/settings/tokens

### 5. Ejecuta el script

```bash
./github_upload_anclora.sh
```

---

## ✅ Resultado

- Se crea el repositorio `Ancloraapp` en tu cuenta GitHub.
- Se suben todos los archivos al branch `main`.
- Quedas listo para continuar el desarrollo y compartir.

---

**Importante:**  
No compartas tu token. Borra el `.env` antes de hacer público el repositorio si no lo has ignorado.

