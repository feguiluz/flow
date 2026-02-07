# 🔄 Plan de Refactorización - Nueva Arquitectura de Privilegios

**Fecha:** 7 de Febrero 2026  
**Estado:** 📋 Planificado  
**Razón:** Cambio fundamental en la lógica de metas basada en privilegios de usuario

---

## 🎯 Cambio de Paradigma

### Arquitectura Anterior (Incorrecta)
- ❌ Cualquier usuario puede establecer cualquier meta en cualquier mes
- ❌ No hay concepto de "privilegio permanente"
- ❌ Publicadores pueden registrar horas sin restricción

### Nueva Arquitectura (Correcta)
- ✅ El privilegio del usuario determina automáticamente sus metas
- ✅ Publicadores solo pueden registrar participación (checkbox) a menos que tengan meta auxiliar
- ✅ Precursores tienen metas fijas automáticas
- ✅ Onboarding obligatorio en primer uso

---

## 📊 Tipos de Usuario y Comportamiento

| Tipo | Meta Mensual | Puede Registrar Horas | Puede Editar Meta | Notas |
|------|--------------|----------------------|-------------------|-------|
| **Publicador (sin meta)** | Ninguna | ❌ NO | ✅ Puede establecer auxiliar | Solo checkbox "Participé" |
| **Publicador (con auxiliar)** | 15h o 30h (temporal) | ✅ SÍ | ✅ Cambiar 15h↔30h | No puede eliminar meta ese mes |
| **Precursor Regular** | 50h (fija) | ✅ SÍ | ❌ NO | Meta automática siempre |
| **Precursor Especial/Misionero** | 90-100h (fija) | ✅ SÍ | ❌ NO | Según género/edad |

---

## 🗄️ Cambios en Base de Datos

### Nueva Tabla: `participations`

```sql
CREATE TABLE participations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  year INTEGER NOT NULL,
  month INTEGER NOT NULL,
  participated INTEGER NOT NULL DEFAULT 0, -- 0 = false, 1 = true
  created_at TEXT NOT NULL,
  UNIQUE(year, month)
);
```

**Propósito:** Guardar checkbox mensual de participación para publicadores sin meta.

### Tabla Existente: `goals`

**Cambio conceptual:** 
- Ahora solo guarda metas **temporales** (precursor auxiliar)
- Precursores Regular/Especial NO usan esta tabla (meta automática)

---

## 📁 Nuevos Archivos a Crear

### Core/Database
```
lib/core/database/daos/
  ├── participation_dao.dart          # CRUD para participations
```

### Core/Services
```
lib/core/services/
  ├── user_profile_service.dart       # EXPANDIR (ya existe)
      ├── publisherType: PublisherType
      ├── gender: Gender
      ├── birthDate: DateTime
      ├── getMonthlyGoalHours() -> double?
```

### Features/Onboarding
```
lib/features/onboarding/
  ├── presentation/
  │   ├── screens/
  │   │   └── onboarding_screen.dart  # Pantalla de primer uso
  │   └── widgets/
  │       ├── name_step.dart          # Paso 1: Nombre
  │       ├── privilege_step.dart     # Paso 2: Privilegio
  │       ├── gender_step.dart        # Paso 3: Género
  │       └── birthdate_step.dart     # Paso 4: Fecha nacimiento
```

### Features/Home (Modificaciones)
```
lib/features/home/presentation/widgets/
  ├── month_summary_card.dart         # MODIFICAR
      └── Mostrar diferente según publisherType
  ├── goal_selector_dialog.dart       # MODIFICAR
      └── Solo para publicadores + solo opciones auxiliares
  ├── participation_checkbox.dart     # NUEVO
      └── Checkbox "Participé este mes" para publicadores
  └── register_activity_sheet.dart    # MODIFICAR
      └── Validar acceso según privilegio
```

### Shared/Models
```
lib/shared/models/
  ├── participation.dart              # NUEVO
  │   └── @freezed class Participation
  ├── publisher_type.dart             # NUEVO
  │   └── enum PublisherType
  └── gender.dart                     # NUEVO
      └── enum Gender
```

---

## 🔧 Modificaciones a Archivos Existentes

### 1. `lib/core/services/user_profile_service.dart`

**Agregar campos:**
```dart
// Nuevos campos
PublisherType? _publisherType;
Gender? _gender;
DateTime? _birthDate;

// Nuevos getters
PublisherType? get publisherType => _publisherType;
Gender? get gender => _gender;
DateTime? get birthDate => _birthDate;
int? get age => _birthDate != null 
    ? DateTime.now().year - _birthDate!.year 
    : null;

// Nuevo método clave
double? getMonthlyGoalHours() {
  switch (_publisherType) {
    case PublisherType.publisher:
      return null; // No tiene meta fija
    case PublisherType.regularPioneer:
      return 50.0;
    case PublisherType.specialPioneer:
      if (_gender == Gender.male) return 100.0;
      if (_age != null && _age! >= 40) return 90.0;
      return 100.0;
    default:
      return null;
  }
}

// Verificar si necesita onboarding
bool needsOnboarding() {
  return _publisherType == null || 
         _gender == null || 
         _birthDate == null;
}
```

### 2. `lib/features/home/data/providers/month_summary_provider.dart`

**Modificar lógica:**
```dart
@riverpod
Future<MonthSummary> monthSummary(
  MonthSummaryRef ref,
  int year,
  int month,
) async {
  final userProfile = UserProfileService.instance;
  
  // Obtener meta según privilegio
  Goal? goal;
  double? targetHours;
  
  if (userProfile.publisherType == PublisherType.publisher) {
    // Publicador: Buscar si tiene meta auxiliar ese mes
    goal = await ref.watch(goalNotifierProvider(year, month).future);
    targetHours = goal != null 
        ? userProfile.getTargetHoursForGoal(goal.goalType)
        : null;
  } else {
    // Precursor Regular/Especial: Meta automática
    targetHours = userProfile.getMonthlyGoalHours();
    // Crear Goal sintético para display
    if (targetHours != null) {
      goal = Goal(
        year: year,
        month: month,
        goalType: _getGoalTypeFromPrivilege(userProfile.publisherType!),
        targetHours: targetHours,
        createdAt: DateTime.now(),
      );
    }
  }
  
  // ... resto del código
}
```

### 3. `lib/features/home/presentation/widgets/month_summary_card.dart`

**Agregar lógica condicional:**
```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final userProfile = UserProfileService.instance;
  final publisherType = userProfile.publisherType;
  
  // Publicador sin meta: Mostrar checkbox de participación
  if (publisherType == PublisherType.publisher && summary.goal == null) {
    return _buildParticipationCard(context, ref, summary);
  }
  
  // Precursor o Publicador con meta auxiliar: Mostrar card con progreso
  return _buildProgressCard(
    context, 
    ref, 
    summary,
    canEditGoal: publisherType == PublisherType.publisher,
  );
}

Widget _buildProgressCard(..., bool canEditGoal) {
  // ...
  if (canEditGoal) {
    // Mostrar botón de editar
    IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () => _showGoalSelector(context, ref, summary),
    );
  }
  // ...
}

Widget _buildParticipationCard(BuildContext context, WidgetRef ref, MonthSummary summary) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text('${monthName} ${summary.year}'),
          const SizedBox(height: 16),
          ParticipationCheckbox(
            year: summary.year,
            month: summary.month,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _showGoalSelector(context, ref, summary),
            icon: const Icon(Icons.add),
            label: const Text('Ser precursor auxiliar este mes'),
          ),
        ],
      ),
    ),
  );
}
```

### 4. `lib/features/home/presentation/widgets/goal_selector_dialog.dart`

**Simplificar opciones:**
```dart
// Solo mostrar si es publicador
if (userProfile.publisherType != PublisherType.publisher) {
  throw StateError('Goal selector only for publishers');
}

// Solo opciones de precursor auxiliar
Column(
  children: [
    if (_isSpecialMonth) ...[
      _buildGoalOption(GoalType.auxiliaryPioneer15, '15 horas', 'Mes especial'),
      _buildGoalOption(GoalType.auxiliaryPioneer30, '30 horas', 'Estándar'),
    ] else ...[
      _buildGoalOption(GoalType.auxiliaryPioneer30, '30 horas', 'Estándar'),
      if (_selectedGoalType == GoalType.auxiliaryPioneer30)
        CheckboxListTile(
          title: const Text('Mes con visita del superintendente'),
          subtitle: const Text('Permite meta de 15 horas'),
          value: _enable15Hours,
          onChanged: (value) {
            setState(() {
              _enable15Hours = value ?? false;
              if (_enable15Hours) {
                _selectedGoalType = GoalType.auxiliaryPioneer15;
              }
            });
          },
        ),
    ],
    
    // ELIMINAR botones de: Publicador, Regular Pioneer, Special Pioneer
  ],
)

// ELIMINAR botón "Eliminar meta"
// Una vez establecida, no se puede eliminar (regla de negocio)
```

### 5. `lib/features/home/presentation/widgets/register_activity_sheet.dart`

**Validar acceso:**
```dart
// Al inicio del widget
@override
void initState() {
  super.initState();
  
  final userProfile = UserProfileService.instance;
  
  // Validar que puede registrar horas
  if (userProfile.publisherType == PublisherType.publisher) {
    // Verificar si tiene meta auxiliar este mes
    final now = DateTime.now();
    // Si no tiene meta, no puede abrir este sheet
    // (debería usar ParticipationCheckbox en su lugar)
  }
}
```

### 6. `lib/main.dart`

**Verificar onboarding:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDateFormatting('es_ES', null);
  Intl.defaultLocale = 'es_ES';
  
  // Initialize sqflite
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  
  // Initialize UserProfileService
  await UserProfileService.instance.init();
  
  runApp(
    ProviderScope(
      child: FlowApp(),
    ),
  );
}
```

### 7. `lib/app.dart`

**Router con onboarding check:**
```dart
final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final userProfile = UserProfileService.instance;
    
    // Si necesita onboarding y no está en esa ruta, redirigir
    if (userProfile.needsOnboarding() && 
        state.matchedLocation != '/onboarding') {
      return '/onboarding';
    }
    
    // Si ya completó onboarding y está en esa ruta, ir a home
    if (!userProfile.needsOnboarding() && 
        state.matchedLocation == '/onboarding') {
      return '/';
    }
    
    return null;
  },
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // ... rutas existentes
      ],
    ),
  ],
);
```

---

## 📋 Nuevos Modelos

### 1. `lib/shared/models/publisher_type.dart`

```dart
enum PublisherType {
  publisher,        // Publicador
  regularPioneer,   // Precursor Regular
  specialPioneer,   // Precursor Especial / Misionero
}

extension PublisherTypeExtension on PublisherType {
  String get displayName {
    switch (this) {
      case PublisherType.publisher:
        return 'Publicador';
      case PublisherType.regularPioneer:
        return 'Precursor Regular';
      case PublisherType.specialPioneer:
        return 'Precursor Especial';
    }
  }
  
  String get description {
    switch (this) {
      case PublisherType.publisher:
        return 'Participo en la predicación regularmente';
      case PublisherType.regularPioneer:
        return '50 horas por mes, 600 horas al año';
      case PublisherType.specialPioneer:
        return '90-100 horas por mes según edad y género';
    }
  }
}
```

### 2. `lib/shared/models/gender.dart`

```dart
enum Gender {
  male,
  female,
}

extension GenderExtension on Gender {
  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Hombre';
      case Gender.female:
        return 'Mujer';
    }
  }
}
```

### 3. `lib/shared/models/participation.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'participation.freezed.dart';
part 'participation.g.dart';

@freezed
class Participation with _$Participation {
  const factory Participation({
    int? id,
    required int year,
    required int month,
    required bool participated,
    required DateTime createdAt,
  }) = _Participation;

  factory Participation.fromJson(Map<String, dynamic> json) =>
      _$ParticipationFromJson(json);
}
```

---

## 🎯 Plan de Implementación (Sprints 4-5 Revisados)

### Sprint 4A: Onboarding & User Profile (4-5h)

**Prioridad 1 - Infraestructura:**
1. Crear `PublisherType`, `Gender` enums
2. Crear modelo `Participation` con Freezed
3. Crear `ParticipationDao`
4. Migración de DB: Agregar tabla `participations`
5. Expandir `UserProfileService` con nuevos campos
6. Generar código: `dart run build_runner build`

**Prioridad 2 - Onboarding UI:**
7. Crear `OnboardingScreen` (pantalla completa con 4 pasos)
8. Crear steps: `NameStep`, `PrivilegeStep`, `GenderStep`, `BirthdateStep`
9. Actualizar `main.dart` y `app.dart` para verificar onboarding
10. Guardar perfil al completar onboarding

**Prioridad 3 - Settings UI:**
11. Crear `ProfileEditScreen`
12. Actualizar `SettingsScreen` para mostrar perfil
13. Implementar diálogo de confirmación al cambiar privilegio

### Sprint 4B: Refactorizar Home con Privilegios (3-4h)

**Prioridad 1 - Modificar Providers:**
1. Actualizar `month_summary_provider.dart` (lógica de meta según privilegio)
2. Crear `participation_notifier.dart` para CRUD de participaciones

**Prioridad 2 - Modificar Widgets:**
3. Refactorizar `MonthSummaryCard`:
   - Publicador sin meta → `ParticipationCheckbox`
   - Publicador con meta → Card con botón editar
   - Precursor → Card SIN botón editar
4. Simplificar `GoalSelectorDialog`:
   - Solo opciones auxiliares (15h/30h)
   - Eliminar botón "Eliminar meta"
5. Crear `ParticipationCheckbox` widget
6. Actualizar `RegisterActivitySheet` con validaciones

**Prioridad 3 - Testing:**
7. Probar onboarding flow completo
8. Probar cambio de privilegio
9. Probar cada tipo de usuario (Publicador, Regular, Especial)

### Sprint 5: Statistics, Export & Polish (4-5h)

**Sin cambios mayores, pero considerar:**
- Gráficas deben manejar meses sin datos (publicadores sin meta)
- Export debe incluir tipo de privilegio en reporte
- Validaciones en todos lados según privilegio

---

## ⚠️ Breaking Changes

| Área | Cambio | Impacto |
|------|--------|---------|
| **Database** | Nueva tabla `participations` | Migración v4 → v5 |
| **UserProfile** | Nuevos campos requeridos | Onboarding obligatorio |
| **Goals** | Solo para metas auxiliares | Precursores no usan tabla goals |
| **Home UI** | Publicadores ven checkbox | UI completamente diferente |
| **Navigation** | Router con redirect a onboarding | Primera ejecución bloqueada |

---

## ✅ Testing Checklist

### Onboarding
- [ ] Aparece en primer uso
- [ ] No se puede omitir
- [ ] Guarda datos correctamente
- [ ] Redirecciona a Home después

### Publicador (sin meta)
- [ ] Ve checkbox "Participé"
- [ ] NO puede registrar horas
- [ ] Puede establecer meta auxiliar
- [ ] Botón "Ser precursor auxiliar"

### Publicador (con meta auxiliar)
- [ ] Ve barra de progreso
- [ ] Puede registrar horas
- [ ] Puede cambiar entre 15h y 30h
- [ ] NO puede eliminar meta

### Precursor Regular
- [ ] Ve barra con 50h automáticas
- [ ] Puede registrar horas
- [ ] NO ve botón editar meta
- [ ] Meta aparece en todos los meses

### Precursor Especial
- [ ] Ve barra con 90h o 100h (según género/edad)
- [ ] Puede registrar horas
- [ ] NO ve botón editar meta
- [ ] Cálculo correcto: Hombre 100h, Mujer <40: 100h, Mujer ≥40: 90h

### Cambio de Privilegio
- [ ] Muestra diálogo de confirmación
- [ ] Solo afecta mes actual en adelante
- [ ] No cambia metas de meses pasados
- [ ] Actualiza UI correctamente

---

## 📝 Notas de Implementación

### Orden de Desarrollo Recomendado

1. **Infraestructura primero** (modelos, DAOs, servicios)
2. **Onboarding** (para poder testear con datos de usuario)
3. **Refactorizar Home** (core de la app)
4. **Settings** (edición de perfil)
5. **Statistics & Export** (último porque depende de todo)

### Decisiones de Diseño

**¿Por qué no eliminar tabla `goals` para precursores?**
- Mantenerla simplifica la lógica
- Los precursores simplemente nunca la usan
- Evita migraciones complejas de datos históricos

**¿Por qué checkbox en lugar de botón para participación?**
- Más rápido y directo
- Se ve y se interactúa como un toggle simple
- Familiar para usuarios de formularios

**¿Por qué validar en UI y no solo en backend?**
- Mejor UX (errores inmediatos)
- Previene estados inconsistentes
- Menos llamadas innecesarias a DB

---

**Versión:** 1.0.0  
**Última Actualización:** 7 Feb 2026  
**Autor:** Claude + Fernando
