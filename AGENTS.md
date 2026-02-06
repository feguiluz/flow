# Flow - Agent Guidelines

## Project Overview

**Flow** is a mobile application designed for Jehovah's Witnesses to track and manage their ministry activity efficiently. The app provides an offline-first experience for recording daily hours, managing interested persons, setting service goals, and generating monthly reports.

### Purpose
- Track daily ministry hours and Bible study activity
- Manage interested persons and return visits
- Set and monitor service goals (auxiliary, regular, special pioneer)
- Generate statistics and export monthly reports
- Work completely offline with local database storage

### Tech Stack
- **Flutter 3.35+** with Dart 3.9+
- **Riverpod 2.0** for state management
- **GoRouter 13.2+** for navigation
- **sqflite 2.3+** for local database
- **fl_chart** for statistics visualization
- **pdf** and **share_plus** for report export
- **freezed** and **json_serializable** for models
- **Material 3** design system

### Target Platforms
Android and iOS (Web/Desktop can be added later)

---

## Domain Concepts

Understanding the terminology and requirements of Jehovah's Witnesses ministry is essential for working on this project.

### Types of Publishers

#### 1. **Publicador (Publisher)**
- Regular congregation member who participates in ministry
- **Reports:** Only participation checkbox (Yes/No) - does NOT report hours
- Can become auxiliary pioneer for specific months

#### 2. **Precursor Auxiliar (Auxiliary Pioneer)**
- Publisher who commits to specific hours for one month
- **Default:** 30 hours/month
- **Special months (15 hours option available):**
  - March (always)
  - April (always)
  - Month with Circuit Overseer visit
- User manually specifies if month is "normal" (30h) or "special" (15h) when setting goal
- **Reports:** Hours + Bible studies

#### 3. **Precursor Regular (Regular Pioneer)**
- Ongoing commitment to pioneer service
- **Requirement:** 50 hours/month, 600 hours/year
- **Reports:** Hours + Bible studies

#### 4. **Precursor Especial / Misionero (Special Pioneer / Missionary)**
- Full-time ministry with higher hour requirements
- **Requirements:**
  - Men: 100 hours/month
  - Women under 40: 100 hours/month
  - Women 40 or older: 90 hours/month
- **Reports:** Hours + Bible studies
- Note: Special pioneers and missionaries have identical requirements

### Key Terms

**Curso Bíblico (Bible Study)**
- Regular Bible study conducted with a person
- **Counting rule:** 1 course = 1 unique person studied per month
  - Example: Study with 4 different people = 4 courses
  - Example: Study with 1 person 5 times = 1 course
- A person becomes an "active course" when they transition from being just a return visit to regular Bible study

**Persona Interesada (Interested Person)**
- Contact made during ministry who shows interest
- May receive return visits
- Can become a Bible study

**Revisita (Return Visit)**
- Visiting an interested person again after initial contact
- Return visits are tracked personally but NOT counted in the official report
- Only the transition to Bible study is reported

### Monthly Report Structure

The official monthly report varies by publisher type:

**Publisher (no pioneer goal):**
- Participation: Yes/No checkbox only

**Any Pioneer (Auxiliary/Regular/Special/Missionary):**
- Hours: Total for the month
- Bible Studies: Count of unique people studied

**What is NOT reported:**
- Number of publications placed
- Number of videos shown
- Number of return visits made
- Types of ministry (door-to-door, phone, informal, etc.)

These can be tracked personally in the app but are not part of the official report.

---

## Build/Test/Lint Commands

### Setup
```bash
# Install dependencies
flutter pub get

# Generate code (freezed, riverpod, json_serializable)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for development
dart run build_runner watch --delete-conflicting-outputs
```

### Run Application
```bash
# Run on default device
flutter run

# Run on specific device
flutter devices                 # List available devices
flutter run -d <device-id>      # Run on specific device
flutter run -d chrome           # Run on web
flutter run -d macos            # Run on macOS

# Run with specific flavor (future)
flutter run --flavor dev
flutter run --flavor prod
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/home/home_screen_test.dart

# Run tests matching a pattern
flutter test --name "ActivityCard"

# Run tests in a directory
flutter test test/features/home/

# Run with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Lint & Format
```bash
# Analyze code for issues
flutter analyze

# Format all Dart files
dart format .

# Format specific directory
dart format lib/

# Check formatting without making changes
dart format --output=none --set-exit-if-changed .

# Preview available fixes
dart fix --dry-run

# Apply available fixes
dart fix --apply
```

### Build
```bash
# Android
flutter build apk                    # APK for distribution
flutter build appbundle              # App Bundle for Play Store
flutter build apk --split-per-abi    # Separate APKs per architecture

# iOS
flutter build ios                    # iOS build
flutter build ipa                    # IPA for App Store

# Build with flavor
flutter build apk --flavor prod
flutter build appbundle --flavor prod
```

---

## Project Structure

Flow uses a **feature-based architecture** for scalability and maintainability.

```
flow/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── app.dart                     # Root widget with ProviderScope
│   │
│   ├── core/                        # Core infrastructure
│   │   ├── theme/
│   │   │   └── app_theme.dart       # Centralized Material 3 theme
│   │   ├── database/
│   │   │   ├── database.dart        # sqflite setup and schema
│   │   │   ├── migrations.dart      # Database migrations
│   │   │   └── daos/                # Data Access Objects
│   │   ├── routing/
│   │   │   └── router.dart          # GoRouter configuration
│   │   └── utils/
│   │       ├── constants.dart       # App-wide constants
│   │       ├── extensions.dart      # Dart extensions
│   │       └── formatters.dart      # Date/number formatters
│   │
│   ├── features/                    # Feature modules
│   │   ├── home/                    # Tab 1: Monthly summary & activity
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   ├── providers/
│   │   │   │   └── repositories/
│   │   │   ├── domain/
│   │   │   │   └── entities/
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       └── widgets/
│   │   │
│   │   ├── people/                  # Tab 2: Interested persons & courses
│   │   ├── statistics/              # Tab 3: Charts & analytics
│   │   └── settings/                # Tab 4: Profile & configuration
│   │
│   └── shared/                      # Shared across features
│       ├── widgets/                 # Reusable UI components
│       ├── models/                  # Shared data models
│       └── providers/               # Shared Riverpod providers
│
├── test/                            # Tests mirror lib/ structure
│   ├── features/
│   ├── shared/
│   └── core/
│
├── CLAUDE.md                        # Flutter Expert guidelines
├── AGENTS.md                        # This file
├── README.md                        # Project documentation
├── pubspec.yaml                     # Dependencies
└── analysis_options.yaml            # Linting rules
```

### Where to Put New Code

- **New feature?** → Create folder in `lib/features/`
- **Reusable widget?** → `lib/shared/widgets/`
- **Data model used across features?** → `lib/shared/models/`
- **Theme changes?** → `lib/core/theme/app_theme.dart`
- **New route?** → Update `lib/core/routing/router.dart`
- **Database changes?** → Update `lib/core/database/database.dart` and create migration
- **Utility function?** → `lib/core/utils/`

---

## Code Style Guidelines

### Import Organization

Group imports with blank lines between sections:

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:convert';

// 2. Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. External packages (alphabetically)
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 4. Internal packages (absolute imports)
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/shared/widgets/custom_button.dart';

// 5. Relative imports (only within same feature)
import '../models/activity.dart';
import 'widgets/activity_card.dart';
```

### Formatting

- Use `dart format` for consistent formatting
- Line length: 80 characters (default), max 120 acceptable for readability
- **Always use trailing commas** for better formatting and diffs

```dart
// Good - trailing commas
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        Text('Hello'),
        Text('World'),
      ],
    ),
  );
}
```

### Types & Null Safety

- Use **explicit types** for public APIs and class members
- Type inference is OK for local variables
- **Avoid `dynamic`** - use generics or specific types
- Use `late` sparingly - prefer nullable types with `?`
- Never use `!` without checking null first

```dart
// Good
final List<Activity> activities = [];
final String? userName = user?.name;

// Bad
final activities = []; // Type unclear
final userName = user!.name; // Unsafe null assertion
```

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Classes, Enums | PascalCase | `ActivityCard`, `GoalType` |
| Files | snake_case | `activity_card.dart`, `home_screen.dart` |
| Variables, Functions | camelCase | `activityList`, `getTotalHours()` |
| Private members | _leadingUnderscore | `_updateState`, `_database` |
| Constants | lowerCamelCase | `const double defaultPadding = 16.0` |

### Widgets

**Always use `const` constructors when possible:**

```dart
// Good
const Text('Hello')
const SizedBox(height: 16)
const Icon(Icons.home)

// Bad (when const is possible)
Text('Hello')
SizedBox(height: 16)
```

**Provide `key` parameter for widgets in lists:**

```dart
ListView.builder(
  itemBuilder: (context, index) {
    return ActivityCard(
      key: ValueKey(activities[index].id),
      activity: activities[index],
    );
  },
)
```

**Extract widgets appropriately:**

```dart
// Good - separate class for reusable widget
class ActivityCard extends ConsumerWidget {
  const ActivityCard({super.key, required this.activity});
  
  final Activity activity;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(...);
  }
}

// Bad - building widgets in methods (can't use const)
Widget _buildCard() {
  return Card(...);
}

// OK - private widget method when needs parameters from build context
Widget _buildHeader(BuildContext context) {
  final theme = Theme.of(context);
  return Text('Header', style: theme.textTheme.headlineMedium);
}
```

### State Management (Riverpod)

**Use ConsumerWidget instead of StatefulWidget:**

```dart
// Good
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(activityListProvider);
    return Scaffold(...);
  }
}

// Avoid (unless you specifically need StatefulWidget for animations, controllers, etc.)
class HomeScreen extends StatefulWidget {
  // ...
}
```

**Use riverpod_annotation for code generation:**

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_provider.g.dart';

@riverpod
class ActivityNotifier extends _$ActivityNotifier {
  @override
  Future<List<Activity>> build() async {
    return _loadActivities();
  }
  
  Future<void> addActivity(Activity activity) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _saveActivity(activity);
      return _loadActivities();
    });
  }
}
```

**Handle AsyncValue properly in UI:**

```dart
final activitiesAsync = ref.watch(activityNotifierProvider);

return activitiesAsync.when(
  data: (activities) => ListView.builder(...),
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (error, stack) => ErrorView(error: error),
);

// Or use pattern matching
return switch (activitiesAsync) {
  AsyncData(:final value) => ListView(...),
  AsyncError(:final error) => ErrorView(error: error),
  _ => const CircularProgressIndicator(),
};
```

### Error Handling

**Use AsyncValue for async operations:**

```dart
Future<void> saveActivity() async {
  state = const AsyncValue.loading();
  state = await AsyncValue.guard(() async {
    // AsyncValue.guard automatically catches errors
    return await repository.save(activity);
  });
}
```

**Try-catch for synchronous operations:**

```dart
try {
  final result = parseData(input);
  return result;
} catch (e, stackTrace) {
  logger.error('Failed to parse data', error: e, stackTrace: stackTrace);
  rethrow;
}
```

**Show proper error states in UI:**

```dart
if (state.hasError) {
  return ErrorView(
    error: state.error!,
    onRetry: () => ref.refresh(activityNotifierProvider),
  );
}
```

### Database (sqflite)

**All operations must be async:**

```dart
Future<List<Activity>> getActivities(int year, int month) async {
  final db = await database;
  final maps = await db.query(
    'activities',
    where: 'date LIKE ?',
    whereArgs: ['$year-${month.toString().padLeft(2, '0')}%'],
    orderBy: 'date DESC',
  );
  return maps.map((map) => Activity.fromJson(map)).toList();
}
```

**Use transactions for multiple writes:**

```dart
Future<void> updateGoalAndActivities(Goal goal, List<Activity> activities) async {
  final db = await database;
  await db.transaction((txn) async {
    await txn.insert('goals', goal.toJson());
    for (final activity in activities) {
      await txn.insert('activities', activity.toJson());
    }
  });
}
```

**Use DAOs for data access patterns:**

```dart
// lib/core/database/daos/activity_dao.dart
class ActivityDao {
  const ActivityDao(this.database);
  
  final Database database;
  
  Future<int> insert(Activity activity) async {
    return database.insert('activities', activity.toJson());
  }
  
  Future<List<Activity>> getByMonth(int year, int month) async {
    // ...
  }
}
```

### Comments & Documentation

**Use `///` for public API documentation:**

```dart
/// Calculates the total hours for the given month.
///
/// Returns 0 if no activities found.
double getTotalHours(int year, int month) {
  // Implementation
}
```

**Use `//` for implementation notes:**

```dart
// We need to convert to UTC to avoid timezone issues
final utcDate = date.toUtc();
```

**Avoid obvious comments:**

```dart
// Bad - obvious
// Increment counter
counter++;

// Good - explains WHY
// Reset counter after 10 to prevent overflow in the backend
if (counter >= 10) counter = 0;
```

---

## Flutter Best Practices

### Material 3

- Always set `useMaterial3: true` in ThemeData
- Use ColorScheme.fromSeed() for consistent color palettes
- Define TextTheme for typography hierarchy
- Configure component themes (CardTheme, AppBarTheme, etc.)
- Never hardcode colors - always use theme colors

```dart
// In widget
final theme = Theme.of(context);
final colorScheme = theme.colorScheme;

Container(
  color: colorScheme.primaryContainer,
  child: Text(
    'Hello',
    style: theme.textTheme.titleLarge,
  ),
)
```

### Theme Centralization

**Single source of truth:** `lib/core/theme/app_theme.dart`

- All theme configuration in one file
- Support both light and dark modes
- Use semantic color names from ColorScheme
- Access via `Theme.of(context)` in widgets
- Never hardcode colors, spacing, or text styles

### Navigation with GoRouter

- Declarative routing configuration
- Type-safe navigation with named routes
- Bottom navigation with StatefulShellRoute
- Deep linking support
- Navigation from widgets: `context.go('/path')` or `context.push('/path')`

### Offline-First Architecture

- **sqflite** for local database storage
- All data operations happen locally
- No network dependency for core functionality
- Optional cloud backup/sync (future feature)
- Handle database migrations properly

### Performance Optimization

**Use const constructors:**
```dart
const Text('Static text')
const Padding(padding: EdgeInsets.all(16))
```

**Use keys for list items:**
```dart
ListView.builder(
  itemBuilder: (context, index) {
    return Widget(key: ValueKey(items[index].id));
  },
)
```

**Use builders for long lists:**
```dart
// Good - only builds visible items
ListView.builder(itemCount: 1000, itemBuilder: ...)

// Bad - builds all items upfront
ListView(children: List.generate(1000, ...))
```

**Avoid unnecessary rebuilds with Riverpod select:**
```dart
// Only rebuild when name changes, not entire user object
final name = ref.watch(userProvider.select((user) => user.name));
```

**Profile with DevTools:**
```bash
flutter run --profile
# Then open DevTools to check performance
```

---

## UI/UX Structure

### Bottom Navigation (4 Tabs)

1. **🏠 Inicio (Home)**
   - Monthly summary card with goal progress
   - Quick action to register hours
   - Recent activity entries
   - Current month selector

2. **👥 Personas (People)**
   - List of Bible studies (with badge count)
   - List of interested persons
   - Search functionality
   - Add new person FAB
   - Person detail with visit history

3. **📊 Estadísticas (Statistics)**
   - Bar chart showing hours per month
   - Annual totals and averages
   - Goal achievement tracking
   - Participation history

4. **⚙️ Ajustes (Settings)**
   - User profile (name, default goal type)
   - Special pioneer age/gender (if applicable)
   - Export options (PDF, WhatsApp)
   - Theme selection (light/dark/system)
   - About & version

### Key User Flows

**Register Daily Hours (for pioneers):**
1. Tap "Registrar horas" button on Home
2. Bottom sheet appears with date, hours input, notes field
3. Save → Updates monthly total automatically

**Mark Participation (for publishers):**
1. Simple checkbox on Home: "Participé este mes"
2. Tap to toggle → Saves immediately

**Add Interested Person:**
1. Tap FAB on People tab
2. Form: name (required), phone, address, notes
3. Toggle: "Es curso bíblico"
4. Save → Appears in appropriate list

**Register Return Visit:**
1. Tap person from People list
2. Person detail screen shows history
3. Tap "Registrar visita"
4. Bottom sheet: date, notes, "Contar como curso este mes" toggle
5. Save → Adds to visit history

**Set Monthly Goal:**
1. Tap summary card on Home
2. Modal with goal options:
   - Sin meta (publicador)
   - Precursor Auxiliar (with 15h/30h selection)
   - Precursor Regular
   - Precursor Especial
3. Apply → Updates progress bar

**Export Report:**
1. Settings → "Compartir por WhatsApp"
2. Generates formatted text with month, hours, studies
3. Opens system share sheet

### Design Principles

- **Clean & Minimal:** Material 3 with generous whitespace
- **Consistent Spacing:** 8dp grid system (8, 16, 24, 32)
- **Visual Hierarchy:** Clear typography scale, color contrast
- **Subtle Animations:** Smooth transitions, no jarring motion
- **Accessible:** Proper semantics, sufficient contrast ratios
- **Responsive:** Adapts to different screen sizes

---

## Testing Guidelines

### Widget Tests

```dart
testWidgets('ActivityCard displays hours correctly', (tester) async {
  final activity = Activity(
    id: 1,
    date: DateTime(2026, 2, 6),
    hours: 2.5,
    notes: 'Test',
    createdAt: DateTime.now(),
  );
  
  await tester.pumpWidget(
    MaterialApp(
      home: ActivityCard(activity: activity),
    ),
  );
  
  expect(find.text('2.5'), findsOneWidget);
});
```

### Mock Providers

```dart
testWidgets('HomeScreen shows loading state', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        activityNotifierProvider.overrideWith(
          () => MockActivityNotifier(),
        ),
      ],
      child: const MaterialApp(home: HomeScreen()),
    ),
  );
  
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

---

## Commit Message Convention

Follow conventional commits:

```
type(scope): subject

body (optional)
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(home): add monthly summary card
fix(database): correct date query for activities
docs: update README with setup instructions
chore(deps): update riverpod to 2.5.1
```

---

**Version:** 1.0.0  
**Last Updated:** Feb 6, 2026
