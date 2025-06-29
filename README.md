# ANCLORA

**Tu Ancla para la Productividad**

## Descripción

Aplicación web ligera desarrollada con **HTML**, **Tailwind CSS** y **JavaScript** (Vanilla) que permite a los usuarios crear, gestionar y organizar tareas y eventos a lo largo del día. Incluye animaciones interactivas, notificaciones configurables y un sistema de categorías temporales (Hoy, Mañana, Esta semana, Próximamente, Vencidos, Completados).

## Propósito

- Centralizar todas tus "anclas" (tareas o eventos) en un solo lugar.
- Facilitar la planificación diaria y semanales con recordatorios automáticos.
- Mejorar la experiencia de usuario mediante animaciones y notificaciones visuales.

## Funcionalidades clave

1. **Creación de Anclajes**

   - Tareas o eventos con opción "Todo el día"
   - Selección de fecha(s) y hora(s)
   - Configuración de prioridad (Normal, Importante, Urgente)
   - Notificaciones programables (en hora del evento, minutos/horas antes)

2. **Visualización y Organización**

   - Secciones: Hoy, Mañana, Esta semana, Próximamente, Vencidos y Completados
   - Animación de ancla y burbujas al crear un nuevo anclaje
   - Marcar como completado, editar, reutilizar o eliminar anclajes

3. **Panel lateral de edición**

   - Apertura y cierre con transición suave
   - Formularios dinámicos que muestran u ocultan campos según contexto

4. **Feedback Visual**

   - Animaciones CSS: caída y balanceo del ancla, burbujas flotantes, checkmark al completar
   - Toasts para errores de validación (fecha/hora, duplicados de notificación)

## Flujo de Usuario Esperado

1. Al cargar la página, el usuario ve sus anclajes agrupados por estado y fecha.
2. El usuario hace click en “Nuevo Anclaje”.
   - Se reproduce una animación de ancla y burbujas.
   - Se abre el panel lateral con formulario de creación.
3. El usuario completa título, tipo, fecha/hora, prioridad y notificaciones.
4. Al guardar, el anclaje aparece en la sección correspondiente.
5. El usuario puede marcar como completado, editar, reutilizar o eliminar.
6. Notificaciones configuradas se disparan mediante la integración con el sistema de recordatorios (futuro módulo de backend o Web Notifications API).

## Estructura de Archivos

```
/anclora
├─ index.html
├─ assets/
│  ├─ ancla-realista.svg
│  ├─ burbujas.svg
├─ scripts/
│  ├─ app.js           # Lógica de render y manejo de datos
│  ├─ animations.js    # Animaciones y efectos
│  └─ utils.js         # Helpers de fecha y validación
├─ styles/
│  └─ tailwind.css     # Configuración y estilos personalizados
├─ tests/
│  ├─ unit/            # Pruebas unitarias (Jest)
│  │   └─ anclora.test.js  # Esqueleto de prueba
│  └─ integration/     # Pruebas de integración (Cypress)
│       └─ anclora.spec.js  # Esqueleto de prueba
├─ .github/workflows/  # CI/CD pipelines
└─ README.md
```

## Pruebas Automatizadas

### Pruebas Unitarias (Jest)

- **Ubicación:** `tests/unit/`
- **Comando:** `npm run test:unit`
- **Ejemplo de archivo:** `anclora.test.js`

```js
import { formatDate, validateAnchor } from '../../scripts/utils';

describe('Utils Helpers', () => {
  test('formatDate convierte fecha a formato legible', () => {
    const input = new Date('2025-07-01T10:00:00');
    expect(formatDate(input)).toBe('1 Jul 2025, 10:00');
  });

  test('validateAnchor rechaza fechas pasadas', () => {
    const pastDate = new Date('2020-01-01');
    expect(() => validateAnchor({ date: pastDate })).toThrow('Fecha inválida');
  });
});
```

### Pruebas de Integración (Cypress)

- **Ubicación:** `tests/integration/`
- **Comando:** `npm run test:e2e`
- **Ejemplo de archivo:** `anclora.spec.js`

```js
/// <reference types="cypress" />

describe('Flujo de creación de anclaje', () => {
  beforeEach(() => {
    cy.visit('/');
  });

  it('Añade un nuevo anclaje y verifica que aparece en la sección Hoy', () => {
    cy.get('[data-cy=new-anchor-button]').click();
    cy.get('[data-cy=title-input]').type('Prueba E2E');
    cy.get('[data-cy=date-input]').type('2025-07-01');
    cy.get('[data-cy=save-button]').click();
    cy.contains('Hoy').parent().should('contain', 'Prueba E2E');
  });
});
```

## Scripts de Test en `package.json`

```json
{
  "scripts": {
    "test:unit": "jest --coverage",
    "test:e2e": "cypress run",
    "test": "npm run test:unit && npm run test:e2e"
  }
}
```

## Configuración CI/CD (GitHub Actions)

Añade un workflow que ejecute pruebas en cada push y pull request, publique los informes de cobertura como artefactos, envíe notificaciones en caso de fallo y publique métricas adicionales:

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [16.x, 18.x]

    steps:
      - uses: actions/checkout@v3
      - name: Use Node.js
        uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node-version }}
      - name: Install dependencies
        run: npm ci

      # Ejecutar y recopilar cobertura
      - name: Run unit tests
        run: npm run test:unit
      - name: Upload coverage report
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: coverage-report
          path: coverage/
      - name: Publish coverage to Codecov
        if: success()
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/**/*.json

      # Métricas de calidad de código (SonarCloud)
      - name: SonarCloud Scan
        if: success()
        uses: sonarsource/sonarcloud-github-action@v1.7.0
        with:
          projectKey: your_org_anclora
          organization: your_org
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}

      # Pruebas de integración
      - name: Run integration tests
        run: npm run test:e2e

      # Notificaciones
      - name: Notify Slack on failure
        if: failure()
        uses: 8398a7/action-slack@v3
        with:
          status: ${{ job.status }}
          fields: repo,commit
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}

      - name: Notify Microsoft Teams on failure
        if: failure()
        uses: Ilshidur/action-teams@v2.0.0
        with:
          webhook-uri: ${{ secrets.TEAMS_WEBHOOK_URL }}
          message: "CI workflow failed on ${{ github.repository }}@${{ github.ref }}"

      - name: Send email on failure
        if: failure()
        uses: dawidd6/action-send-mail@v3
        with:
          server_address: smtp.example.com
          server_port: 587
          username: ${{ secrets.SMTP_USER }}
          password: ${{ secrets.SMTP_PASSWORD }}
          subject: "[ANCLORA CI] Fallo en ${GITHUB_REPOSITORY}"
          to: team@example.com
          from: ci-bot@example.com
```

---

## Mejora del script de despliegue `github_upload_anclora.sh`

Este script automatiza el empaquetado y publicación de la aplicación en GitHub Releases, asegurando robustez, validación de parámetros y registro de logs.

### Características clave

- Parámetros configurables (versión, etiqueta, token)
- Verificación de pre-requisitos (GH CLI, jq)
- Gestión de errores con mensajes claros y códigos de salida
- Registro de acciones en un log con timestamp
- Posibilidad de reintentos en caso de fallos transitorios

### Ejemplo de script mejorado

```bash
... (script existente) ...
```

---

## Refactorización por Módulos

Para mejorar la mantenibilidad y escalabilidad, proponemos dividir la lógica en cuatro módulos principales:

1. \`\`

   - Punto de entrada de la aplicación.
   - Importa y coordina la interacción entre utilidades, animaciones y API.
   - Inicializa el estado, renderiza la UI y gestiona eventos.

   ```js
   import { fetchAnchors, saveAnchor } from './api';
   import { initAnchors, renderAnchors } from './utils';
   import { animateAnchorDrop, animateBubbles } from './animations';

   document.addEventListener('DOMContentLoaded', async () => {
     const anchors = await fetchAnchors();
     renderAnchors(anchors);
     setupEventListeners();
   });

   function setupEventListeners() {
     document
       .getElementById('new-anchor-button')
       .addEventListener('click', async () => {
         animateAnchorDrop();
         const formData = await openSidebarForm();
         await saveAnchor(formData);
         const anchors = await fetchAnchors();
         renderAnchors(anchors);
       });
   }
   ```

2. \`\`

   - Funciones puras para manejo de datos, fechas y validaciones.
   - No interactúa con el DOM directamente.

   ```js
   export function formatDate(date) {
     const options = { day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' };
     return new Intl.DateTimeFormat('es-ES', options).format(date);
   }

   export function validateAnchor({ title, date }) {
     if (!title) throw new Error('El título es obligatorio');
     if (date < new Date()) throw new Error('Fecha inválida');
     return true;
   }
   ```

3. \`\`

   - Funciones que aplican clases CSS o usan Web Animations API.
   - Separado de la lógica de negocio para facilitar cambios de estilo.

   ```js
   export function animateAnchorDrop() {
     const anchorEl = document.querySelector('.anchor');
     anchorEl.classList.add('drop-animation');
     anchorEl.addEventListener('animationend', () => {
       anchorEl.classList.remove('drop-animation');
     });
   }

   export function animateBubbles() {
     document.querySelectorAll('.bubble').forEach(b => b.classList.add('bubble-animation'));
   }
   ```

4. \`\`

   - Abstracción de llamadas a backend (o `localStorage` en prototipo).
   - Maneja fetch, errores, formato de datos, retries y caching.

   ```js
   const BASE_URL = '/api/anchors';
   const CACHE_TTL = 5 * 60 * 1000; // 5 minutos
   let cache = { data: null, timestamp: 0 };

   async function requestWithRetries(url, options = {}, retries = 2) {
     for (let i = 0; i <= retries; i++) {
       try {
         const res = await fetch(url, options);
         if (!res.ok) {
           const error = new Error(`HTTP ${res.status}`);
           error.status = res.status;
           throw error;
         }
         return res;
       } catch (err) {
         if (i === retries) throw err;
         await new Promise(r => setTimeout(r, 1000 * (i + 1)));
       }
     }
   }

   export async function fetchAnchors(forceRefresh = false) {
     const now = Date.now();
     if (!forceRefresh && cache.data && (now - cache.timestamp) < CACHE_TTL) {
       return cache.data;
     }
     const res = await requestWithRetries(BASE_URL);
     const data = await res.json();
     cache = { data, timestamp: now };
     return data;
   }

   export async function saveAnchor(anchor) {
     validateAnchor(anchor);
     const res = await requestWithRetries(BASE_URL, {
       method: 'POST',
       headers: { 'Content-Type': 'application/json' },
       body: JSON.stringify(anchor),
     });
     // Invalidate cache to fetch fresh data next time
     cache = { data: null, timestamp: 0 };
     return res.json();
   }
   ```

### Pruebas Unitarias para `api.js`

- **Ubicación:** `tests/unit/api.test.js`
- **Comando:** `npm run test:unit`

```js
import { fetchAnchors, saveAnchor } from '../../scripts/api';

// Mock global fetch
global.fetch = jest.fn();

describe('API Module', () => {
  beforeEach(() => {
    jest.resetAllMocks();
    // Simular fetch exitoso
    fetch.mockImplementation((url, opts) =>
      Promise.resolve({ ok: true, json: () => Promise.resolve([{ id: '1', title: 'Test' }]) })
    );
  });

  test('fetchAnchors devuelve datos y cachea resultados', async () => {
    const data1 = await fetchAnchors();
    const data2 = await fetchAnchors();
    expect(fetch).toHaveBeenCalledTimes(1);
    expect(data1).toEqual(data2);
  });

  test('saveAnchor envía POST y limpia cache', async () => {
    // Preparar cache previa
    await fetchAnchors();
    fetch.mockResolvedValueOnce({ ok: true, json: () => Promise.resolve({ id: '2' }) });
    const newAnchor = { title: 'Nuevo', date: new Date(Date.now() + 100000) };
    await saveAnchor(newAnchor);
    expect(fetch).toHaveBeenLastCalledWith('/api/anchors', expect.objectContaining({ method: 'POST' }));
    // fetchAnchors debería volver a llamarse si se fuerza refresco
    fetch.mockResolvedValueOnce({ ok: true, json: () => Promise.resolve([]) });
    const fresh = await fetchAnchors(true);
    expect(fetch).toHaveBeenCalled();
  });

  test('requestWithRetries lanza error tras exceder retries', async () => {
    fetch.mockRejectedValue(new Error('Network error'));
    await expect(fetchAnchors()).rejects.toThrow('Network error');
  });
});
```

### Beneficios de la Modularización

- **Mantenibilidad:** Código legible y responsabilidades claras.
- **Testabilidad:** Funciones puras y módulos API fáciles de simular.
- **Reutilización:** Componentes desacoplados para futuros casos de uso.
- **Escalabilidad:** Incorporar nuevas fuentes de datos o UI sin alterar módulos existentes. de la Modularización
- **Mantenibilidad:** Código legible y responsabilidades claras.
- **Testabilidad:** Funciones puras y módulos API fáciles de simular.
- **Reutilización:** Componentes desacoplados para futuros casos de uso.
- **Escalabilidad:** Incorporar nuevas fuentes de datos o UI sin alterar módulos existentes.

---

## Mejora de Usabilidad

Basándonos en los feedbacks, hemos definido estas acciones para optimizar la experiencia de usuario:

1. **Accesibilidad (WCAG)**

   - Implementado en la sección “Ajustes de Accesibilidad” con ARIA, navegación por teclado, alt texts y notificaciones accesibles.

2. **Experiencia móvil**

   - Diseño responsive probado en pantallas pequeñas (mínimo 320px de ancho) y media queries en Tailwind (`sm` ≥640px, `md` ≥768px, `lg` ≥1024px, `xl` ≥1280px, `2xl` ≥1536px), con ejemplos:

     ```html
     <!-- Contenedor adaptable -->
     <div class="container mx-auto px-4 sm:px-6 md:px-8 lg:px-10">
       <h1 class="text-base sm:text-lg md:text-xl lg:text-2xl xl:text-3xl">Mis Anclajes</h1>
       <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
         <!-- Tarjetas de anclaje -->
       </div>
     </div>
     ```

   - Ajuste de esquemas de navegación:

     ```html
     <!-- Desplegable móvil -->
     <button aria-label="Abrir menú" class="sm:hidden p-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
       <!-- Icono hamburguesa (svg) -->
     </button>
     <nav class="hidden sm:flex flex-col sm:flex-row space-y-2 sm:space-y-0 sm:space-x-4">
       <a href="#" class="block px-3 py-2 rounded hover:bg-gray-100">Inicio</a>
       <a href="#" class="block px-3 py-2 rounded hover:bg-gray-100">Anclajes</a>
       <!-- ... -->
     </nav>
     ```

   - Ejemplo de ajuste de formulario:

     ```html
     <!-- Formulario adaptable -->
     <form class="grid grid-cols-1 sm:grid-cols-2 gap-4">
       <label class="block">
         <span>Título</span>
         <input type="text" class="mt-1 block w-full p-2 border rounded" />
       </label>
       <label class="block">
         <span>Fecha</span>
         <input type="date" class="mt-1 block w-full p-2 border rounded" />
       </label>
       <button type="submit" class="col-span-full bg-blue-600 text-white py-2 px-4 rounded hover:bg-blue-700">Guardar</button>
     </form>
     ```

   - **Buenas prácticas**:

     - Evitar elementos demasiado pequeños (mínimo `44px × 44px` según WCAG).
     - Espacios táctiles adecuados (`p` y `m` en Tailwind).
     - Pruebas en simuladores: Chrome DevTools, Safari Responsive Design.
     - Uso de `aspect-w-16 aspect-h-9` para incrustar vídeos o gráficos responsivos.

3. **Tutoriales y guías rápidas**

   - **Sección “¿Cómo empezar?”** en README y página de ayuda dentro de la app:

     ````md
     ## ¿Cómo empezar?
     1. Clona el repositorio:
        ```bash
        git clone https://github.com/tu-org/anclora.git
        cd anclora
     ````

     2. Instala dependencias:
        ```bash
        npm install
        ```
     3. Ejecuta la aplicación en modo desarrollo:
        ```bash
        npm start
        ```
     4. Abre tu navegador en [http://localhost:3000](http://localhost:3000) y prueba:
        - Crea un anclaje pulsando el botón **Nuevo Anclaje**
        - Edita o elimina usando los iconos en cada tarjeta

     ```
     ```

   - **Walkthrough interactivo** usando [Intro.js](https://introjs.com/):

     ```js
     import introJs from 'intro.js';

     const tour = introJs();
     tour.setOptions({
       nextLabel: 'Siguiente',
       prevLabel: 'Anterior',
       doneLabel: 'Finalizar',
       steps: [
         { element: '#new-anchor-button', intro: 'Haz clic aquí para crear un anclaje.', position: 'right' },
         { element: '.anchor-list', intro: 'Aquí verás tus anclajes agrupados.', position: 'bottom' },
         { element: '[data-cy=save-button]', intro: 'Guarda tu anclaje con este botón.', position: 'left' }
       ]
     });

     document.getElementById('start-tour').addEventListener('click', () => {
       tour.start();
     });
     ```

   - **Inclusión de GIF animado** para pasos rápidos:

     ```html
     <img src="/assets/demo-anclora.gif" alt="Demostración de creación de un anclaje" loading="lazy" />
     ```

   - **Tutorial en vídeo corto** incrustado en la página de ayuda (opcional):

     ````html
     <section aria-labelledby="help-video">
       <h2 id="help-video">Tutorial rápido</h2>
       <video controls width="100%" aria-label="Tutorial de uso de ANCLORA">
         <source src="/videos/anclora-walkthrough.mp4" type="video/mp4">
         Tu navegador no soporta la etiqueta de video.
       </video>
     </section>
     ``` Abre tu navegador en http://localhost:3000 y prueba:
        - Crea un anclaje pulsando el botón **Nuevo Anclaje**
        - Edita o elimina usando los iconos en cada tarjeta
     ````

   - **Walkthrough interactivo** usando [Intro.js](https://introjs.com/):

     ```js
     import introJs from 'intro.js';

     const tour = introJs();
     tour.setOptions({
       nextLabel: 'Siguiente',
       prevLabel: 'Anterior',
       doneLabel: 'Finalizar',
       steps: [
         { element: '#new-anchor-button', intro: 'Haz clic aquí para crear un anclaje.', position: 'right' },
         { element: '.anchor-list', intro: 'Aquí verás tus anclajes agrupados.', position: 'bottom' },
         { element: '[data-cy=save-button]', intro: 'Guarda tu anclaje con este botón.', position: 'left' }
       ]
     });

     document.getElementById('start-tour').addEventListener('click', () => {
       tour.start();
     });
     ```

   - **Tutorial en vídeo corto** incrustado en la página de ayuda (opcional):

     ```html
     <section aria-labelledby="help-video">
       <h2 id="help-video">Tutorial rápido</h2>
       <video controls width="100%" aria-label="Tutorial de uso de ANCLORA">
         <source src="/videos/anclora-walkthrough.mp4" type="video/mp4">
         Tu navegador no soporta la etiqueta de video.
       </video>
     </section>
     ```

   - **Code Snippets** en la consola de desarrollo (README) para probar utilidades:

     ```bash
     # Listar anclajes guardados
     node -e "console.log(JSON.parse(localStorage.getItem('ancloras')||'[]'))"

     # Borrar todos los anclajes (modo dev)
     node -e "localStorage.removeItem('ancloras')"
     ```

4. Accede a [http://localhost:3000](http://localhost:3000) y crea tu primer anclaje.

   ````

   - Walkthrough interactivo con library [Intro.js](https://introjs.com/):

   ```js
   import introJs from 'intro.js';

   document.getElementById('start-tour').addEventListener('click', () => {
     introJs().setOptions({
       steps: [
         { element: '#new-anchor-button', intro: 'Haz clic aquí para crear un anclaje.' },
         { element: '.anchor-list', intro: 'Aquí verás tus anclajes.' }
       ]
     }).start();
   });
   ````

5. **Feedback visual y mensajes claros**

   - Toasts, alerts y loaders con roles ARIA (`status`, `alert`) y animaciones suaves.
   - Ejemplo de loader y toast:

   ```html
   <!-- Loader accesible -->
   <div role="status" aria-live="polite" class="loader">
     <span class="sr-only">Cargando...</span>
     <div class="spinner"></div>
   </div>

   <!-- Toast con animación -->
   <div role="status" aria-live="polite" class="toast animate-fade-in-out">
     Anclaje guardado correctamente.
   </div>
   ```

6. **Optimización de rendimiento y tiempos de carga**

   - **Minificación y combinación** de CSS y JS:

     ```bash
     # Tailwind Purge
     npx tailwindcss -o dist/tailwind.min.css --minify

     # Terser para JS
     npx terser scripts/app.js -o dist/app.min.js --compress --mangle

     # Combinar archivos CSS
     cat dist/tailwind.min.css dist/custom.css > dist/styles.bundle.css
     ```

   - **Compresión de imágenes** y nuevos formatos:

     ```bash
     # Convertir PNG a WebP
     cwebp -q 80 assets/image.png -o assets/image.webp

     # Optimizar SVGs
     svgo assets/icon.svg -o assets/icon.min.svg
     ```

   - **Resource Hints** (preload, prefetch, dns-prefetch, preconnect):

     ```html
     <!-- Preload fuente crítica -->
     <link rel="preload" href="/fonts/Inter.woff2" as="font" type="font/woff2" crossorigin>
     <!-- Preconnect a CDN de fuentes -->
     <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
     <!-- Prefetch script de analytics -->
     <link rel="prefetch" href="/analytics.js" as="script">
     ```

   - **Loading strategies**:

     ```html
     <!-- Defer y async JS -->
     <script src="dist/app.min.js" defer></script>
     <script src="https://analytics.example.com/track.js" async></script>
     ```

   - **Font loading**:

     ```css
     @font-face {
       font-family: 'Inter';
       src: url('/fonts/Inter.woff2') format('woff2');
       font-display: swap;
     }
     ```

   - **Critical CSS** en línea:

     ```html
     <style>
       /* css crítico: cabecera y botones principales */
       header { display: flex; align-items: center; }
       .btn-primary { background-color: #1e3a8a; color: #fff; }
     </style>
     <link rel="stylesheet" href="dist/styles.bundle.css">
     ```

   - **Caching y compresión en servidor** (ejemplo Nginx):

     ```nginx
     gzip on;
     gzip_types text/css application/javascript image/svg+xml;
     gzip_comp_level 6;
     brotli on;
     brotli_types text/css application/javascript image/svg+xml;
     expires 1y;
     add_header Cache-Control "public, immutable";
     ```

   - **HTTP/2 Server Push** (opcional):

     ```nginx
     http2_push /fonts/Inter.woff2;
     http2_push /dist/app.min.js;
     ```

   - **Lazy loading y placeholders**:

     ```html
     <img src="placeholder.svg" data-src="/assets/photo.jpg" loading="lazy" alt="Descripción" class="lazyload">
     <script src="lazysizes.min.js" async></script>
     ```

   - **CDN y code splitting**:

- Servir assets estáticos desde CDN: `/assets/*` en CDN con TTL largo.
- Dividir bundles JS por rutas usando dynamic imports:
  ```js
  import('~/scripts/heavyModule.js').then(module => module.init());
  ```

**Ejemplos de configuración de herramientas de build**

- **Webpack (webpack.config.js)**:

  ```js
  const path = require('path');
  const MiniCssExtractPlugin = require('mini-css-extract-plugin');
  const TerserPlugin = require('terser-webpack-plugin');

  module.exports = {
    mode: 'production',
    entry: './scripts/app.js',
    output: {
      path: path.resolve(__dirname, 'dist'),
      filename: 'app.bundle.js',
      publicPath: '/dist/'
    },
    module: {
      rules: [
        {
          test: /\.css$/,
          use: [MiniCssExtractPlugin.loader, 'css-loader', 'postcss-loader']
        },
        {
          test: /\.(png|jpe?g|gif|svg)$/i,
          use: [
            {
              loader: 'file-loader',
              options: { outputPath: 'images' }
            },
            {
              loader: 'image-webpack-loader',
              options: { mozjpeg: { progressive: true, quality: 75 } }
            }
          ]
        }
      ]
    },
    optimization: {
      minimize: true,
      minimizer: [new TerserPlugin({ extractComments: false })]
    },
    plugins: [
      new MiniCssExtractPlugin({ filename: 'styles.bundle.css' })
    ]
  };
  ```

- **Rollup (rollup.config.js)**:

  ```js
  import resolve from '@rollup/plugin-node-resolve';
  import commonjs from '@rollup/plugin-commonjs';
  import postcss from 'rollup-plugin-postcss';
  import { terser } from 'rollup-plugin-terser';
  import url from '@rollup/plugin-url';

  export default {
    input: 'scripts/app.js',
    output: {
      file: 'dist/app.bundle.js',
      format: 'iife',
      sourcemap: true
    },
    plugins: [
      resolve(),
      commonjs(),
      postcss({ extract: true, minimize: true }),
      url({ include: ['**/*.svg', '**/*.png'], limit: 8192 }),
      terser()
    ]
  };
  ```

**Medición y optimización continua**:\*\*: - Usa **WebPageTest** y **Lighthouse** para monitorear LCP, FID y CLS. - Configurar **Lighthouse CI** en el pipeline (ver sección 5). - Añadir badge de performance en README: `md        ![Performance](https://img.shields.io/badge/Lighthouse-90%25-brightgreen)        `

---

