# 📋 PLAN DE IMPLEMENTACIÓN - FLOW

> **Última actualización**: 6 de Febrero de 2026  
> **Estado**: Sprint 1 - Pendiente  
> **Progreso General**: 0% (0/4 sprints completados)

---

## 📊 Resumen Ejecutivo

**Flow** es una aplicación móvil para Testigos de Jehová que permite registrar y gestionar la actividad de predicación de forma offline-first.

### Tiempo Estimado Total
**30-40 horas** de desarrollo distribuidas en 4 sprints principales + fase de pulido final.

### Tech Stack
- Flutter 3.35+ / Dart 3.9+
- Riverpod 2.0 (state management)
- GoRouter 13.2 (navigation)
- sqflite 2.3 (local database)
- fl_chart 0.66 (charts)
- pdf 3.10 + share_plus 7.2 (export)
- freezed + json_serializable (models)

---

## ✅ Ya Implementado (Setup Inicial)

- [x] Proyecto Flutter creado
- [x] Estructura de directorios feature-based
- [x] Documentación completa (README, AGENTS, CLAUDE)
- [x] Theme Material 3 con paleta azul sereno
- [x] Database schema v1 (4 tablas)
- [x] GoRouter con 4 tabs configurado
- [x] Modelos base con freezed (Activity, Person, Visit, Goal)
- [x] Pantallas placeholder
- [x] Repositorio en GitHub (github.com/feguiluz/flow)
- [x] GitFlow configurado (main + develop)

---

## 🎯 Decisiones de Diseño Clave

### 1. Persistencia
- **Perfil de usuario**: SharedPreferences
- **Datos de app**: sqflite (offline-first)

### 2. Validaciones
- **Publicador sin meta**: Bloquear registro de horas (mostrar diálogo para establecer meta)
- **Una meta por mes**: Sí, validado en Goal table con UNIQUE(year, month)

### 3. Conteo de Cursos Bíblicos
- **Automático**: Contar personas con `isBibleStudy=true` que tuvieron ≥1 visita ese mes
- Método: `VisitDao.countBibleStudiesInMonth(year, month)`

### 4. Edición de Datos
Permitir editar/eliminar TODO con confirmación:
- [x] Actividades (horas)
- [x] Personas interesadas
- [x] Visitas
- [x] Metas (eliminar si ya existe)

### 5. Formato de Fecha
- **Display**: dd/MM/yyyy (06/02/2026)
- **Database**: yyyy-MM-dd (ISO 8601)

### 6. Meses Especiales (Auxiliar 15h)
- **Marzo y Abril**: Mostrar directamente 15h y 30h como opciones
- **Otros meses**: 30h por defecto + checkbox "Habilitar 15h" (para visita SC)

### 7. Testing
- **Cobertura completa**: DAOs + Providers + Widgets críticos
- Tests unitarios para toda la lógica de negocio
- Widget tests para componentes principales

### 8. Orden de Implementación
✅ Sprints 1→2→3→4 como propuesto

---

## 🏃 SPRINT 1: Fundamentos de Datos y Home Básico

**Objetivo**: Capa de datos funcional + Registro de horas operativo  
**Duración**: 8-10 horas  
**Estado**: ⏳ Pendiente  
**Progreso**: 0% (0/5 tareas completadas)

### Resultado Esperado
Usuario puede registrar horas diarias y verlas en una lista, con validación de meta activa.

### 1.1. Core Infrastructure (2h) ⏳

**Archivos a crear:**

#### `lib/core/utils/constants.dart`
- Definir constantes de horas por tipo de meta
- Meses especiales (marzo, abril)
- Formatos de fecha
- Keys de SharedPreferences

#### `lib/core/utils/date_formatter.dart`
```dart
class DateFormatter {
  static String formatForDisplay(DateTime date);
  static String formatForDb(DateTime date);
  static DateTime parseFromDb(String dateStr);
  static String getMonthName(int month);
  static String getMonthYear(int year, int month);
}
```

#### `lib/core/utils/validators.dart`
```dart
class Validators {
  static String? validateHours(String? value);
  static String? validatePersonName(String? value);
  static bool isDateInFuture(DateTime date);
  static bool canRegisterHours(GoalType? currentGoal);
}
```

#### `lib/core/services/user_profile_service.dart`
```dart
class UserProfileService {
  // SharedPreferences wrapper
  Future<void> init();
  
  // Getters/Setters para: name, defaultGoalType, gender, age, themeMode
  double getTargetHoursForGoal(GoalType goalType);
}
```

**Tests:**
- `test/core/utils/validators_test.dart` (10 casos)
- `test/core/services/user_profile_service_test.dart` (15 casos)

---

### 1.2. Database Layer - DAOs (3h) ⏳

**Archivos a crear:**

#### `lib/core/database/daos/activity_dao.dart`
```dart
class ActivityDao {
  // CRUD
  Future<int> insert(Activity activity);
  Future<void> update(Activity activity);
  Future<void> delete(int id);
  Future<Activity?> getById(int id);
  
  // Queries
  Future<List<Activity>> getByMonth(int year, int month);
  Future<List<Activity>> getRecent({int limit = 10});
  Future<double> getTotalHoursByMonth(int year, int month);
  Future<Map<int, double>> getHoursByMonthForYear(int year);
}
```

#### `lib/core/database/daos/person_dao.dart`
```dart
class PersonDao {
  // CRUD básico
  // Queries: getAll, getBibleStudies, getInterestedPersons, search
}
```

#### `lib/core/database/daos/visit_dao.dart`
```dart
class VisitDao {
  // CRUD básico
  // Queries: getByPerson, getByMonth, countBibleStudiesInMonth
}
```

#### `lib/core/database/daos/goal_dao.dart`
```dart
class GoalDao {
  // UPSERT basado en year+month
  // Queries: getByMonth, getByYear
}
```

#### `lib/shared/providers/database_provider.dart`
```dart
@riverpod
Future<Database> database(DatabaseRef ref);

@riverpod
ActivityDao activityDao(ActivityDaoRef ref);
// ... providers para cada DAO
```

**Tests (CRÍTICOS):**
- `test/core/database/daos/activity_dao_test.dart` (20+ casos)
- `test/core/database/daos/person_dao_test.dart` (15+ casos)
- `test/core/database/daos/visit_dao_test.dart` (18+ casos)
- `test/core/database/daos/goal_dao_test.dart` (12+ casos)

---

### 1.3. Shared Providers (1h) ⏳

#### `lib/shared/providers/user_profile_provider.dart`
```dart
@riverpod
class UserProfile extends _$UserProfile {
  // Wrapper sobre UserProfileService
  // Métodos: updateName, updateDefaultGoalType, etc.
}

@freezed
class UserProfileData with _$UserProfileData {
  const factory UserProfileData({
    String? name,
    GoalType? defaultGoalType,
    String? gender,
    int? age,
  }) = _UserProfileData;
}
```

#### `lib/shared/providers/theme_provider.dart`
```dart
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  // Gestionar ThemeMode (light/dark/system)
}
```

---

### 1.4. Home - Activity Registration (3-4h) ⏳

#### `lib/features/home/data/providers/activity_notifier.dart`
```dart
@riverpod
class ActivityNotifier extends _$ActivityNotifier {
  // State: Future<List<Activity>>
  // Métodos: addActivity, updateActivity, deleteActivity
}

@riverpod
Future<List<Activity>> currentMonthActivities(CurrentMonthActivitiesRef ref);
```

#### Widgets a crear:
- `register_activity_sheet.dart` - Bottom sheet para registrar/editar horas
- `activity_list.dart` - Lista de actividades con estados (loading, error, empty)
- `activity_item.dart` - Card individual con fecha, horas, notas, botones edit/delete

#### Actualizar `home_screen.dart`:
- Añadir ActivityList en el body
- FAB "Registrar horas" con validación de meta
- Mostrar diálogo de error si no hay meta activa

**Tests:**
- `test/features/home/data/providers/activity_notifier_test.dart` (15 casos)
- `test/features/home/presentation/widgets/activity_item_test.dart` (widget test)

---

### 1.5. Shared Widgets (1h) ⏳

Crear widgets reutilizables:
- `loading_indicator.dart`
- `error_view.dart`
- `empty_state.dart`
- `confirmation_dialog.dart`

**Tests:**
- `test/shared/widgets/confirmation_dialog_test.dart` (widget test)

---

### ✅ Criterios de Completitud Sprint 1

- [ ] Todos los DAOs creados y testeados (>60 tests passing)
- [ ] UserProfileService funcional con SharedPreferences
- [ ] Registro de horas operativo con validación
- [ ] Lista de actividades recientes visible
- [ ] Editar/Eliminar actividades con confirmación
- [ ] Bloqueo de registro sin meta + diálogo informativo
- [ ] Commit: `feat(home): implement activity registration and management`
- [ ] Merge a `develop`

---

## 🏃 SPRINT 2: Gestión de Personas y Visitas

**Objetivo**: CRUD completo de personas interesadas y cursos bíblicos  
**Duración**: 8-10 horas  
**Estado**: 📅 Planificado  
**Progreso**: 0% (0/3 tareas completadas)

### Resultado Esperado
Usuario puede gestionar personas, registrar visitas, ver historial completo, y marcar cursos activos.

### 2.1. People - Data Layer (2h) 📅

#### `lib/features/people/data/providers/person_notifier.dart`
```dart
@riverpod
class PersonNotifier extends _$PersonNotifier {
  // State: Future<List<Person>>
  // Métodos: addPerson, updatePerson, deletePerson, toggleBibleStudy
}

@riverpod
Future<List<Person>> bibleStudies(BibleStudiesRef ref);

@riverpod
Future<List<Person>> interestedPersons(InterestedPersonsRef ref);
```

#### `lib/features/people/data/providers/visit_notifier.dart`
```dart
@riverpod
class VisitNotifier extends _$VisitNotifier {
  // State: Map<int, List<Visit>> (personId -> visits)
  // Métodos: loadVisitsForPerson, addVisit, updateVisit, deleteVisit
}

@riverpod
Future<int> bibleStudiesCountCurrentMonth(BibleStudiesCountCurrentMonthRef ref);
```

**Tests:**
- `test/features/people/data/providers/person_notifier_test.dart` (15 casos)
- `test/features/people/data/providers/visit_notifier_test.dart` (12 casos)

---

### 2.2. People - UI Components (3h) 📅

#### Widgets a crear:
- `person_card.dart` - Card con avatar, nombre, info, badge de curso
- `person_list.dart` - Lista con empty state
- `person_form_sheet.dart` - Bottom sheet para crear/editar persona

#### Actualizar `people_screen.dart`:
- Buscador en AppBar
- Dos secciones: Cursos Bíblicos (con badge) + Personas Interesadas
- FAB para añadir persona
- Filtrado por búsqueda

**Tests:**
- `test/features/people/presentation/widgets/person_card_test.dart` (widget test)

---

### 2.3. Person Detail & Visits (3-4h) 📅

#### `lib/features/people/presentation/screens/person_detail_screen.dart`
```dart
class PersonDetailScreen extends ConsumerStatefulWidget {
  // Mostrar info completa de persona
  // Historial de visitas
  // Botón registrar visita
  // Toggle curso bíblico
  // Edit/Delete persona
}
```

#### Widgets a crear:
- `visit_list.dart` - Lista de visitas ordenadas por fecha
- `visit_item.dart` - Card de visita con fecha, notas, badge si countedAsStudy
- `register_visit_sheet.dart` - Bottom sheet para registrar/editar visita

**Tests:**
- Widget tests para componentes principales

---

### ✅ Criterios de Completitud Sprint 2

- [ ] CRUD de personas completamente funcional
- [ ] Lista separada de cursos vs interesados
- [ ] Buscador operativo
- [ ] Detalle de persona con toda la info
- [ ] Historial de visitas visible y editable
- [ ] Toggle curso bíblico funcionando
- [ ] Todas las eliminaciones con confirmación
- [ ] Commit: `feat(people): implement person and visit management`
- [ ] Merge a `develop`

---

## 🏃 SPRINT 3: Metas y Resumen Mensual

**Objetivo**: Sistema de metas + Card de resumen en Home  
**Duración**: 6-8 horas  
**Estado**: 📅 Planificado  
**Progreso**: 0% (0/2 tareas completadas)

### Resultado Esperado
Usuario puede establecer metas mensuales y ver progreso visual con barra de progreso.

### 3.1. Goal Management (2h) 📅

#### `lib/features/home/data/providers/goal_notifier.dart`
```dart
@riverpod
class GoalNotifier extends _$GoalNotifier {
  // State: Future<Goal?> para (year, month)
  // Métodos: setGoal, deleteGoal
}

@riverpod
Future<Goal?> currentMonthGoal(CurrentMonthGoalRef ref);
```

#### `lib/features/home/data/providers/month_summary_provider.dart`
```dart
@freezed
class MonthSummary with _$MonthSummary {
  const factory MonthSummary({
    required int year,
    required int month,
    required double totalHours,
    required int bibleStudiesCount,
    Goal? goal,
    required double progressPercentage,
    required bool isGoalMet,
  }) = _MonthSummary;
}

@riverpod
Future<MonthSummary> monthSummary(MonthSummaryRef ref, int year, int month);

@riverpod
Future<MonthSummary> currentMonthSummary(CurrentMonthSummaryRef ref);
```

**Tests:**
- `test/features/home/data/providers/goal_notifier_test.dart` (10 casos)
- `test/features/home/data/providers/month_summary_provider_test.dart` (12 casos)

---

### 3.2. Month Summary UI (2-3h) 📅

#### `lib/features/home/presentation/widgets/month_summary_card.dart`
```dart
class MonthSummaryCard extends ConsumerWidget {
  // Card destacado con:
  // - Mes y año (con botón edit meta)
  // - Tipo de meta y horas objetivo
  // - Barra de progreso (color según %)
  // - Horas actuales vs objetivo
  // - Mensaje de estado (cumplida / faltan X horas)
  // - Cursos bíblicos activos
}
```

#### `lib/features/home/presentation/widgets/goal_selector_dialog.dart`
```dart
class GoalSelectorDialog extends ConsumerStatefulWidget {
  // Dialog con RadioListTiles para cada tipo de meta
  // Lógica especial para marzo/abril (mostrar 15h y 30h)
  // Otros meses: 30h default + checkbox "Habilitar 15h"
  // Mostrar horas objetivo según tipo seleccionado
  // Botones: Eliminar Meta (si existe), Cancelar, Guardar
}
```

#### Actualizar `home_screen.dart`:
- Añadir MonthSummaryCard en la parte superior
- Divider entre summary y lista de actividades

**Tests:**
- `test/features/home/presentation/widgets/month_summary_card_test.dart` (widget test)
- `test/features/home/presentation/widgets/goal_selector_dialog_test.dart` (widget test)

---

### ✅ Criterios de Completitud Sprint 3

- [ ] Sistema de metas completamente funcional
- [ ] Card de resumen mensual visible y actualizado
- [ ] Barra de progreso con colores (verde/amarillo/rojo)
- [ ] Selector de meta con validación de meses especiales
- [ ] Opción de 15h disponible correctamente (marzo/abril + checkbox otros meses)
- [ ] Conteo automático de cursos funcionando
- [ ] Eliminar meta existente funcional
- [ ] Commit: `feat(home): implement goals and monthly summary`
- [ ] Merge a `develop`

---

## 🏃 SPRINT 4: Estadísticas y Exportación

**Objetivo**: Gráficas con fl_chart + Exportar informes  
**Duración**: 8-10 horas  
**Estado**: 📅 Planificado  
**Progreso**: 0% (0/3 tareas completadas)

### Resultado Esperado
Visualización completa de estadísticas anuales con gráficas, y capacidad de exportar informes en texto y PDF.

### 4.1. Statistics Screen (4-5h) 📅

#### `lib/features/statistics/data/providers/statistics_provider.dart`
```dart
@freezed
class AnnualStatistics with _$AnnualStatistics {
  const factory AnnualStatistics({
    required int year,
    required Map<int, double> hoursByMonth,
    required double totalHours,
    required double averageHours,
    required int totalBibleStudies,
    required Map<int, Goal?> goalsByMonth,
    required int goalsMetCount,
    required int totalMonthsActive,
  }) = _AnnualStatistics;
}

@riverpod
Future<AnnualStatistics> annualStatistics(AnnualStatisticsRef ref, int year);
```

#### `lib/features/statistics/presentation/widgets/hours_chart.dart`
```dart
class HoursChart extends StatelessWidget {
  // BarChart con fl_chart mostrando:
  // - 12 barras (una por mes)
  // - Colores según cumplimiento de meta (verde/amarillo/rojo)
  // - Líneas horizontales punteadas para metas
  // - Labels con abreviación de meses
  // - Tooltip al hacer tap
}
```

#### `lib/features/statistics/presentation/widgets/summary_cards.dart`
```dart
class SummaryCards extends StatelessWidget {
  // 4 cards pequeños mostrando:
  // - Total anual de horas
  // - Promedio mensual
  // - Cursos totales
  // - Metas cumplidas
}
```

#### Actualizar `statistics_screen.dart`:
- Selector de año en AppBar (botones prev/next)
- SummaryCards en la parte superior
- HoursChart
- Lista de meses con desglose (mostrar solo meses activos)

**Tests:**
- `test/features/statistics/data/providers/statistics_provider_test.dart` (15 casos)
- `test/features/statistics/presentation/widgets/hours_chart_test.dart` (widget test)

---

### 4.2. Settings & Profile (2h) 📅

#### Widgets a crear:
- `profile_section.dart` - Card con info de perfil + botón editar
- `appearance_section.dart` - Card con selector de tema
- `export_section.dart` - Card con botones de exportación

#### `lib/features/settings/presentation/screens/profile_edit_screen.dart`
```dart
class ProfileEditScreen extends ConsumerStatefulWidget {
  // Formulario para editar:
  // - Nombre
  // - Tipo de publicador por defecto
  // - Si es Especial/Misionero: género y edad
  // Guardar en SharedPreferences via UserProfileProvider
}
```

#### Actualizar `settings_screen.dart`:
- ProfileSection (nombre, tipo, género/edad si aplica)
- ExportSection (WhatsApp, PDF)
- AppearanceSection (Light/Dark/System)
- ListTile "Acerca de" con showAboutDialog

---

### 4.3. Export & Share (2-3h) 📅

#### `lib/features/settings/data/providers/export_provider.dart`
```dart
@riverpod
class ExportNotifier extends _$ExportNotifier {
  // Métodos:
  Future<String> generateTextReport(int year, int month);
  Future<void> shareTextReport(int year, int month); // share_plus
  Future<void> generatePdfReport(int year, int month); // pdf package
}
```

**Formato texto para WhatsApp:**
```
📊 Informe de Predicación - Febrero 2026

Nombre: Fernando
Tipo: Precursor Auxiliar

⏱️ Horas: 30.5
📚 Cursos Bíblicos: 2

---
Generado con Flow
```

**PDF:** Similar pero con mejor formato usando package `pdf`.

**Tests:**
- `test/features/settings/data/providers/export_provider_test.dart` (8 casos)

---

### ✅ Criterios de Completitud Sprint 4

- [ ] Gráfica de horas mensuales funcional con fl_chart
- [ ] Colores de barras según cumplimiento de meta
- [ ] Líneas horizontales mostrando metas
- [ ] Estadísticas anuales completas y correctas
- [ ] Selector de año con navegación prev/next
- [ ] Perfil de usuario completamente editable
- [ ] Exportar informe a texto (WhatsApp) funcional
- [ ] Exportar informe a PDF funcional
- [ ] Selector de tema aplicando cambios
- [ ] Commit: `feat(statistics,settings): implement charts and export functionality`
- [ ] Merge a `develop`

---

## 🎯 FASE FINAL: Pulido y Deploy

**Duración**: 3-4 horas  
**Estado**: 📅 Planificado

### 5.1. Empty States & Error Handling (1h)
- [ ] Revisar todas las pantallas con estados vacíos
- [ ] Mejorar mensajes de error contextuales
- [ ] Añadir SnackBars de confirmación en operaciones exitosas

### 5.2. Animations (1h)
- [ ] Transiciones sutiles entre pantallas
- [ ] Hero animations para cards principales
- [ ] Fade in/out en listas
- [ ] AnimatedSwitcher en estados de loading

### 5.3. Testing Final (1h)
- [ ] Ejecutar `flutter test` - todos los tests deben pasar
- [ ] Verificar cobertura con `flutter test --coverage`
- [ ] Fix cualquier error encontrado
- [ ] Ejecutar `flutter analyze` - 0 issues

### 5.4. Documentation (30min)
- [ ] Actualizar README.md con screenshots
- [ ] Actualizar AGENTS.md si hubo cambios
- [ ] Crear CHANGELOG.md con v1.0.0

### 5.5. Build & Deploy (30min)
```bash
# Android
flutter build appbundle --release

# iOS (requiere Mac + Xcode)
flutter build ipa --release
```

---

## 📈 Métricas del Proyecto

### Archivos a Crear
- **Core Infrastructure**: 7 archivos
- **DAOs**: 4 archivos + 1 provider
- **Shared Providers**: 2 archivos
- **Shared Widgets**: 4 archivos
- **Home Feature**: 8 archivos
- **People Feature**: 11 archivos
- **Statistics Feature**: 6 archivos
- **Settings Feature**: 7 archivos
- **Tests**: ~25 archivos de test

**Total**: ~75 archivos nuevos

### Tests a Escribir
- Unit tests (DAOs): ~65 casos
- Unit tests (Providers): ~60 casos
- Widget tests: ~15 casos
- **Total**: ~140 test cases

### Commits Esperados
- Sprint 1: 1-2 commits
- Sprint 2: 1 commit
- Sprint 3: 1 commit
- Sprint 4: 2 commits
- Final: 1-2 commits
- **Total**: 6-8 commits principales

---

## 🎓 Conceptos de Dominio - Referencia Rápida

### Tipos de Publicadores

| Tipo | Horas/mes | Particularidades |
|------|-----------|------------------|
| **Publicador** | N/A | Solo marca participación (checkbox) |
| **Precursor Auxiliar 15h** | 15 | Marzo, Abril, o mes con visita SC |
| **Precursor Auxiliar 30h** | 30 | Cualquier mes (default) |
| **Precursor Regular** | 50 | 600 horas/año |
| **Precursor Especial (hombre)** | 100 | Full-time |
| **Precursor Especial (mujer <40)** | 100 | Full-time |
| **Precursor Especial (mujer ≥40)** | 90 | Full-time |
| **Misionero** | 90-100 | Igual que Especial |

### Cursos Bíblicos
- **Definición**: Persona con quien se estudia la Biblia regularmente
- **Conteo**: 1 curso = 1 persona única con `isBibleStudy=true` + ≥1 visita ese mes
- **Ejemplo**: Estudiar con 4 personas = 4 cursos, estudiar 5 veces con 1 persona = 1 curso

### Meses Especiales
- **Marzo**: Siempre opción de 15h disponible (campaña Conmemoración)
- **Abril**: Siempre opción de 15h disponible (campaña Conmemoración)
- **Otros meses**: 30h default, pero usuario puede habilitar 15h si hay visita del Superintendente de Circuito

### Informe Mensual
**Publicador (sin meta)**:
- ✅ Participé este mes (Sí/No)

**Precursores (todos los tipos)**:
- ⏱️ Horas totales
- 📚 Número de cursos bíblicos

**NO se informa**:
- ❌ Publicaciones colocadas
- ❌ Videos mostrados
- ❌ Número de revisitas
- ❌ Tipos de predicación

---

## 🚀 Comandos Útiles

### Desarrollo
```bash
# Ejecutar app
flutter run -d chrome
flutter run -d macos

# Hot reload
r

# Hot restart
R

# Generar código
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch
```

### Testing
```bash
# Todos los tests
flutter test

# Test específico
flutter test test/core/database/daos/activity_dao_test.dart

# Con cobertura
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Lint & Format
```bash
flutter analyze
dart format .
dart fix --dry-run
dart fix --apply
```

### Git (GitFlow)
```bash
# Crear feature branch
git checkout develop
git checkout -b feature/sprint-1-activity-registration

# Commit con conventional commits
git commit -m "feat(home): implement activity registration"

# Merge a develop
git checkout develop
git merge feature/sprint-1-activity-registration
git push origin develop
```

---

## 📝 Notas de Implementación

### Consideraciones de Performance
- [ ] Usar `const` constructors siempre que sea posible
- [ ] ListView.builder para listas largas (no ListView con children)
- [ ] Keys apropiadas para items de listas
- [ ] Riverpod `.select()` para evitar rebuilds innecesarios
- [ ] IndexedDB en web tiene límite de 50MB (suficiente para años de datos)

### Consideraciones de UX
- [ ] Loading states en todas las operaciones async
- [ ] Error states informativos con opción de retry
- [ ] Empty states con iconos y mensajes amigables
- [ ] Confirmaciones antes de eliminar datos
- [ ] SnackBars para feedback de operaciones exitosas
- [ ] Animaciones sutiles (no distraer)

### Consideraciones de Datos
- [ ] Validar fechas (no futuro para actividades/visitas)
- [ ] Validar horas (> 0, formato decimal correcto)
- [ ] Backup automático sugerido (futuro)
- [ ] Exportación periódica recomendada

---

## ✅ Checklist de Calidad

Antes de considerar cada Sprint completo:

- [ ] Todos los tests del Sprint pasan (0 failures)
- [ ] `flutter analyze` sin errores ni warnings
- [ ] `dart format .` aplicado
- [ ] Código revisado por linting rules
- [ ] Documentación de código (/// comments) en APIs públicas
- [ ] Widget tests para componentes críticos
- [ ] Funcionalidad probada manualmente en Chrome/macOS
- [ ] Commit message siguiendo Conventional Commits
- [ ] Branch mergeado a `develop` sin conflictos

---

## 📞 Soporte y Referencias

### Documentación del Proyecto
- [README.md](README.md) - Descripción general y setup
- [AGENTS.md](AGENTS.md) - Guía técnica completa
- [CLAUDE.md](CLAUDE.md) - Directrices Flutter Expert

### Recursos Externos
- [Flutter Docs](https://docs.flutter.dev/)
- [Riverpod Docs](https://riverpod.dev/)
- [fl_chart Examples](https://github.com/imaNNeo/fl_chart)
- [sqflite Guide](https://pub.dev/packages/sqflite)

### Repositorio
- GitHub: https://github.com/feguiluz/flow
- Issues: https://github.com/feguiluz/flow/issues

---

**Última actualización**: 6 de Febrero de 2026  
**Mantenido por**: Claude Code (AI Assistant)  
**Aprobado por**: Fernando Eguiluz
