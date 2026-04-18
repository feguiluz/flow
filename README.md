# Flow

Aplicación móvil para Testigos de Jehová que permite registrar y gestionar la actividad de predicación de forma sencilla y eficiente.

## ✨ Características

- 📊 **Registro de Actividad**: Registra tus horas diarias y cursos bíblicos
- 👥 **Gestión de Personas**: Mantén un seguimiento de personas interesadas y revisitas
- 🎯 **Metas de Servicio**: Define y monitorea tu progreso como precursor
- 📈 **Estadísticas**: Visualiza tu actividad con gráficas y tendencias
- 📤 **Exportar Informes**: Comparte tu informe mensual por WhatsApp o PDF
- 📱 **Offline**: Funciona completamente sin conexión a internet

## 🛠️ Tecnologías

- **Flutter 3.35+** - Framework multiplataforma
- **Dart 3.9+** - Lenguaje de programación
- **Riverpod 2.0** - Gestión de estado
- **GoRouter** - Navegación
- **sqflite** - Base de datos local
- **fl_chart** - Gráficas y visualizaciones
- **Material 3** - Diseño moderno y accesible

## 🚀 Instalación

### Prerrequisitos
- Flutter 3.19 o superior
- Dart 3.3 o superior

### Pasos

1. Clona el repositorio
```bash
git clone https://github.com/feguiluz/flow.git
cd flow
```

2. Instala las dependencias
```bash
flutter pub get
```

3. Genera código (freezed, riverpod)
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. Ejecuta la app

**Para móvil:**
```bash
flutter run
```

**Para web (con persistencia de datos):**
```bash
flutter run -d chrome --web-port=8080
```
> ⚠️ **Importante**: Usa siempre el mismo puerto (--web-port=8080) para que los datos persistan entre sesiones. Ver [RUN_WEB.md](RUN_WEB.md) para más detalles.

## 📖 Documentación

- [AGENTS.md](AGENTS.md) - Guía técnica completa para desarrolladores
- [CLAUDE.md](CLAUDE.md) - Directrices de Flutter Expert

## 🏗️ Arquitectura

Flow utiliza una arquitectura basada en features con las siguientes capas:

- **Core**: Infraestructura compartida (theme, database, routing)
- **Features**: Módulos independientes (home, people, statistics, settings)
- **Shared**: Componentes reutilizables entre features

## 🧪 Testing

```bash
# Ejecutar todos los tests
flutter test

# Tests con cobertura
flutter test --coverage
```

## 📦 Build

```bash
# Android
flutter build apk
flutter build appbundle

# iOS
flutter build ios
flutter build ipa
```

## 🤝 Contribuir

Las contribuciones son bienvenidas. Por favor:

1. Crea un fork del proyecto
2. Crea una rama feature (`git checkout -b feature/NuevaCaracteristica`)
3. Commit tus cambios siguiendo [Conventional Commits](https://www.conventionalcommits.org/)
4. Push a la rama (`git push origin feature/NuevaCaracteristica`)
5. Abre un Pull Request hacia `develop`

### GitFlow

Este proyecto sigue GitFlow:
- `main` - Rama de producción estable
- `develop` - Rama de desarrollo activo
- `feature/*` - Nuevas funcionalidades
- `release/*` - Preparación de releases
- `hotfix/*` - Fixes urgentes en producción

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

## 👤 Autor

**Fernando Eguiluz** - [@feguiluz](https://github.com/feguiluz)

---

Hecho con ❤️ para la comunidad de Testigos de Jehová
