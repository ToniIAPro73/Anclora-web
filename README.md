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
