# Lista de Pruebas - Navegación por Meses y Año de Servicio

## Configuración Inicial

### Preparar Entorno de Prueba
- [ ] Abrir Chrome en http://localhost:8080
- [ ] Abrir DevTools del navegador (F12)
- [ ] Verificar que no hay errores en consola
- [ ] Verificar que la base de datos se inicializa correctamente (mensaje: "✅ Database opened successfully")

---

## 1. Pruebas de Navegación por Meses

### 1.1 Visualización Inicial
- [ ] La app carga en el mes actual (Febrero 2026)
- [ ] Se muestra el badge "Mes actual" debajo del nombre del mes
- [ ] El selector muestra: `< Febrero 2026 >`
- [ ] La flecha izquierda (←) está habilitada
- [ ] La flecha derecha (→) está deshabilitada/gris

### 1.2 Navegación Hacia Atrás
- [ ] Click en flecha izquierda (←)
- [ ] El mes cambia a "Enero 2026" con animación suave
- [ ] El badge "Mes actual" desaparece
- [ ] La flecha derecha (→) ahora está habilitada
- [ ] Click nuevamente en flecha izquierda (←)
- [ ] El mes cambia a "Diciembre 2025"
- [ ] Continuar navegando: Nov 2025, Oct 2025, Sep 2025
- [ ] Verificar que se puede navegar a meses de años anteriores

### 1.3 Navegación Hacia Adelante
- [ ] Desde un mes anterior (ej: Enero 2026), click en flecha derecha (→)
- [ ] El mes cambia a "Febrero 2026" con animación suave
- [ ] El badge "Mes actual" vuelve a aparecer
- [ ] La flecha derecha (→) se deshabilita nuevamente
- [ ] Verificar que NO se puede avanzar más allá del mes actual

### 1.4 Transiciones y Animaciones
- [ ] Las transiciones entre meses son suaves (fade + slide)
- [ ] No hay parpadeos o glitches visuales
- [ ] El contenido de actividades cambia con animación
- [ ] Los totales se actualizan correctamente

---

## 2. Pruebas de Tarjeta de Resumen Mensual

### 2.1 Sin Datos
- [ ] Navegar a un mes sin actividades registradas
- [ ] El total muestra "0h 0m"
- [ ] El ícono de reloj se muestra correctamente
- [ ] El diseño del gradiente se ve bien

### 2.2 Con Datos Existentes
- [ ] Si ya tienes actividades en el mes actual, verifica que:
  - [ ] El total se muestra correctamente (ej: "5h 30m")
  - [ ] El formato es legible y correcto
- [ ] Navegar a otro mes con datos
- [ ] Verificar que el total cambia correctamente

### 2.3 Estados de Carga
- [ ] Al cambiar de mes, se muestra brevemente un indicador de carga
- [ ] El indicador es un círculo giratorio pequeño
- [ ] La transición del estado de carga a los datos es suave

---

## 3. Pruebas de Año de Servicio

### 3.1 Sección Colapsada (Estado Inicial)
- [ ] La sección muestra el botón "Ver año de servicio"
- [ ] Tiene un ícono de flecha hacia abajo (▼)
- [ ] Hay una línea divisoria sutil arriba del botón

### 3.2 Expandir Sección
- [ ] Click en "Ver año de servicio"
- [ ] La sección se expande con animación suave
- [ ] El botón cambia a "Ocultar año de servicio"
- [ ] El ícono cambia a flecha hacia arriba (▲)
- [ ] Se muestra el título "Año de servicio 2025-2026"
- [ ] Se muestra el total acumulado con formato correcto

### 3.3 Colapsar Sección
- [ ] Click en "Ocultar año de servicio"
- [ ] La sección se colapsa con animación suave
- [ ] Vuelve al estado inicial

### 3.4 Cálculo de Año de Servicio Correcto

**Para meses Sep-Dic 2025:**
- [ ] Navegar a Septiembre 2025
- [ ] Expandir año de servicio
- [ ] Debe mostrar: "Año de servicio 2025-2026"
- [ ] Navegar a Octubre, Noviembre, Diciembre 2025
- [ ] Todos deben mostrar "Año de servicio 2025-2026"

**Para meses Ene-Ago 2026:**
- [ ] Navegar a Enero 2026
- [ ] Expandir año de servicio
- [ ] Debe mostrar: "Año de servicio 2025-2026"
- [ ] Navegar a Febrero 2026 (mes actual)
- [ ] Debe mostrar: "Año de servicio 2025-2026"

**Transición de año de servicio:**
- [ ] Navegar a Agosto 2026 (si es posible)
- [ ] Debe mostrar: "Año de servicio 2025-2026"
- [ ] Navegar a Septiembre 2026 (si es posible)
- [ ] Debe mostrar: "Año de servicio 2026-2027" ⚠️ CRÍTICO

### 3.5 Total Acumulado

**Sin datos:**
- [ ] Navegar a Septiembre 2025, expandir
- [ ] Si no hay datos, debe mostrar "0h 0m"

**Con datos futuros (después de registrar actividades):**
- [ ] El total debe sumar desde Sep del año de servicio hasta el mes seleccionado
- [ ] Ejemplo: Si estás en Enero 2026, suma Sep+Oct+Nov+Dic 2025 + Ene 2026

---

## 4. Pruebas de Registro de Actividades

### 4.1 Registrar en Mes Actual
- [ ] Click en botón FAB "Registrar"
- [ ] Se abre el bottom sheet
- [ ] Registrar una actividad:
  - Fecha: hoy
  - Tipo: Predicación
  - Tiempo: 2 horas 30 minutos (usando TimePicker)
- [ ] Click en "Guardar"
- [ ] El bottom sheet se cierra
- [ ] La actividad aparece en la lista
- [ ] El total mensual se actualiza: suma anterior + 2h 30m
- [ ] El total del año de servicio se actualiza (si está expandido)

### 4.2 Registrar en Mes Pasado
- [ ] Navegar a Enero 2026 (mes anterior)
- [ ] Click en botón FAB "Registrar"
- [ ] Registrar una actividad con fecha de Enero
- [ ] Verificar que la actividad aparece en la lista de Enero
- [ ] Verificar que el total de Enero se actualiza
- [ ] Navegar a Febrero (mes actual)
- [ ] Verificar que Febrero NO incluye la actividad de Enero
- [ ] Navegar de vuelta a Enero
- [ ] Verificar que la actividad de Enero sigue ahí

### 4.3 Validación de 24h Máximo
- [ ] Intentar registrar más de 24h en un mismo día
- [ ] El sistema debe mostrar error si el total del día excede 24h
- [ ] Ejemplo:
  - Registrar actividad 1: 15h (OK)
  - Intentar registrar actividad 2: 10h en la misma fecha
  - Debe mostrar error: "El total de horas para este día no puede superar 24 horas"

---

## 5. Pruebas de Edición de Actividades

### 5.1 Editar Actividad
- [ ] Click en el ícono de edición (✏️) de una actividad
- [ ] Se abre el bottom sheet con los datos cargados
- [ ] Modificar el tiempo (ej: de 2h 30m a 3h 0m)
- [ ] Guardar cambios
- [ ] Verificar que la actividad se actualiza en la lista
- [ ] Verificar que el total mensual se recalcula correctamente
- [ ] Verificar que el total del año de servicio se recalcula (si está expandido)

### 5.2 Editar Fecha de Actividad
- [ ] Editar una actividad y cambiar su fecha a otro mes
- [ ] Guardar cambios
- [ ] Verificar que la actividad desaparece del mes actual
- [ ] Navegar al mes de la nueva fecha
- [ ] Verificar que la actividad aparece en el nuevo mes
- [ ] Verificar que los totales de ambos meses se recalculan

---

## 6. Pruebas de Eliminación de Actividades

### 6.1 Eliminar con Confirmación
- [ ] Click en el ícono de eliminar (🗑️) de una actividad
- [ ] Se muestra un diálogo de confirmación
- [ ] Click en "Cancelar"
- [ ] La actividad NO se elimina
- [ ] Click nuevamente en eliminar
- [ ] Click en "Eliminar"
- [ ] La actividad desaparece de la lista
- [ ] El total mensual se recalcula restando las horas eliminadas
- [ ] El total del año de servicio se recalcula

---

## 7. Pruebas de Lista de Actividades

### 7.1 Estado Vacío
- [ ] Navegar a un mes sin actividades
- [ ] Se muestra el mensaje: "No hay actividades registradas este mes"
- [ ] Se muestra un ícono ilustrativo
- [ ] El mensaje invita a registrar la primera actividad

### 7.2 Lista con Datos
- [ ] Navegar a un mes con actividades
- [ ] Las actividades se muestran ordenadas por fecha (más reciente primero)
- [ ] Cada tarjeta muestra:
  - Fecha formateada (ej: "Lun, 3 de febrero")
  - Tipo de actividad con ícono
  - Tiempo en formato "2h 30m"
  - Notas (si existen)
  - Botones de editar y eliminar

### 7.3 Scroll y Performance
- [ ] Si hay muchas actividades (10+), verificar que:
  - [ ] El scroll es fluido
  - [ ] No hay lag al cambiar de mes
  - [ ] Las transiciones siguen siendo suaves

---

## 8. Pruebas de Persistencia de Datos

### 8.1 Reload de Navegador
- [ ] Registrar 2-3 actividades en diferentes meses
- [ ] Anotar los totales de cada mes
- [ ] Recargar la página (F5)
- [ ] Verificar que la app carga en el mes actual
- [ ] Navegar a los meses donde registraste actividades
- [ ] Verificar que todas las actividades siguen ahí
- [ ] Verificar que los totales son correctos

### 8.2 Cerrar y Abrir Navegador
- [ ] Cerrar completamente Chrome
- [ ] Abrir Chrome nuevamente
- [ ] Ir a http://localhost:8080
- [ ] Verificar que todos los datos persisten
- [ ] ⚠️ **IMPORTANTE:** Solo funciona si usas `--web-port=8080` consistente

---

## 9. Pruebas de Responsive Design

### 9.1 Diferentes Tamaños de Ventana
- [ ] Ventana maximizada: todo se ve bien
- [ ] Ventana en modo móvil (DevTools → Toggle Device Toolbar):
  - [ ] iPhone 12/13: 390x844
  - [ ] Galaxy S20: 360x800
  - [ ] iPad: 768x1024
- [ ] Verificar que:
  - [ ] El selector de mes se adapta
  - [ ] Las tarjetas no se rompen
  - [ ] Los botones son fáciles de tocar
  - [ ] No hay overflow horizontal

---

## 10. Pruebas de Casos Edge

### 10.1 Cambio de Año
- [ ] Navegar a Diciembre 2025
- [ ] Registrar una actividad
- [ ] Navegar a Enero 2026
- [ ] Registrar una actividad
- [ ] Verificar que cada actividad está en su mes correcto
- [ ] Verificar que ambos meses están en el mismo año de servicio (2025-2026)

### 10.2 Límite de Septiembre (Cambio de Año de Servicio)
- [ ] Si es posible navegar a Agosto 2026:
  - [ ] Expandir año de servicio
  - [ ] Verificar: "Año de servicio 2025-2026"
  - [ ] Navegar a Septiembre 2026
  - [ ] Expandir año de servicio
  - [ ] Verificar: "Año de servicio 2026-2027" ⚠️ CRÍTICO

### 10.3 Múltiples Actividades el Mismo Día
- [ ] Registrar 3 actividades en la misma fecha
- [ ] Verificar que todas aparecen en la lista
- [ ] Verificar que el total las suma correctamente
- [ ] Editar una de ellas
- [ ] Verificar que el total se recalcula bien

### 10.4 Actividades con 0 Minutos
- [ ] Intentar registrar una actividad con 0h 0m
- [ ] El sistema debe mostrar error o no permitirlo
- [ ] Verificar validación mínima

### 10.5 Notas Largas
- [ ] Registrar una actividad con una nota larga (100+ caracteres)
- [ ] Verificar que la nota se muestra correctamente truncada
- [ ] Verificar que no rompe el diseño de la tarjeta

---

## 11. Pruebas de Consola y Errores

### 11.1 Consola del Navegador
- [ ] Abrir DevTools → Console
- [ ] Realizar todas las operaciones anteriores
- [ ] Verificar que NO hay:
  - [ ] Errores (rojo)
  - [ ] Warnings críticos (amarillo) relacionados con el código
  - [ ] Excepciones no manejadas
- [ ] Los únicos mensajes deberían ser:
  - [ ] "📦 Opening database for web: flow_app.db"
  - [ ] "✅ Database opened successfully"

### 11.2 Flutter DevTools
- [ ] Abrir el enlace de Flutter DevTools que aparece en la terminal
- [ ] Tab "Performance": verificar que no hay frames lentos
- [ ] Tab "Memory": verificar que no hay leaks obvios al navegar entre meses

---

## 12. Pruebas de Integración Completa

### Escenario Real: Mes de Actividades Completo

1. **Setup:**
   - [ ] Navegar a Enero 2026
   - [ ] Asegurarse de que esté vacío o limpiar datos

2. **Registrar actividades variadas:**
   - [ ] Lunes 5 Ene: Predicación, 2h 30m, nota: "Zona residencial"
   - [ ] Martes 6 Ene: Curso Bíblico, 1h 0m, nota: "Estudio con María"
   - [ ] Sábado 10 Ene: Predicación, 3h 15m
   - [ ] Domingo 11 Ene: Predicación, 2h 0m
   - [ ] Lunes 12 Ene: Curso Bíblico, 1h 30m, nota: "Estudio con Juan"
   - [ ] Jueves 15 Ene: Revisita, 0h 30m
   - [ ] Sábado 17 Ene: Predicación, 4h 0m, nota: "Testificación pública"

3. **Verificar totales:**
   - [ ] Total mensual debe ser: 14h 45m
   - [ ] Expandir año de servicio
   - [ ] El total acumulado debe incluir estas 14h 45m

4. **Editar actividad:**
   - [ ] Editar la del 10 Ene: cambiar de 3h 15m a 4h 0m
   - [ ] Total mensual nuevo: 15h 30m

5. **Eliminar actividad:**
   - [ ] Eliminar la del 15 Ene (0h 30m)
   - [ ] Total mensual nuevo: 15h 0m

6. **Navegar a otro mes:**
   - [ ] Ir a Febrero 2026
   - [ ] Verificar que Febrero está vacío o muestra solo actividades de Febrero
   - [ ] Total de Febrero es independiente

7. **Volver a Enero:**
   - [ ] Navegar de vuelta a Enero 2026
   - [ ] Verificar que las 6 actividades restantes siguen ahí
   - [ ] Verificar que el total sigue siendo 15h 0m

8. **Persistencia:**
   - [ ] Recargar página
   - [ ] Navegar a Enero 2026
   - [ ] Verificar que los datos persisten

---

## 13. Checklist de Regresión

### Funcionalidades Previas (NO deben romperse)

- [ ] **TimePicker:** Sigue funcionando al registrar/editar actividades
- [ ] **Validación de 24h:** Sigue funcionando correctamente
- [ ] **Formato de tiempo:** Sigue mostrándose como "Xh Ym" (no decimal)
- [ ] **Tipos de actividad:** Todos los tipos se muestran con sus íconos
- [ ] **Tema claro/oscuro:** Si está implementado, sigue funcionando
- [ ] **Bottom sheet:** Se abre y cierra correctamente
- [ ] **AppBar:** Se muestra correctamente con el título "Flow"

---

## Resultados Esperados

### ✅ Todo Correcto Si:
- Todas las casillas anteriores están marcadas
- No hay errores en la consola
- Las animaciones son fluidas
- Los datos persisten correctamente
- Los cálculos de totales son precisos
- La navegación es intuitiva y sin bugs

### ⚠️ Problemas Comunes a Revisar:

1. **Total no se actualiza:** Verificar que los providers se están watching correctamente
2. **Datos no persisten:** Verificar que estás usando `--web-port=8080`
3. **Animaciones lentas:** Verificar performance en DevTools
4. **Año de servicio incorrecto:** Revisar lógica en `getServiceYearForDate()`
5. **Flecha derecha habilitada en mes actual:** Revisar `_isCurrentMonth()`

---

## Pasos Después de las Pruebas

### Si TODO funciona:
```bash
# Opcional: Push a remote
git push origin develop
```

### Si encuentras bugs:
1. Anotar el bug con detalle (pasos para reproducir)
2. Crear un issue o nota con el problema
3. Priorizar fix antes de continuar con Sprint 2

---

**Fecha de pruebas:** _________  
**Probado por:** _________  
**Resultado:** ☐ PASS  ☐ FAIL (detallar problemas)  
**Notas adicionales:**

---
