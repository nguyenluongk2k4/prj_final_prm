# Dating App - PRM Final Project

A Flutter dating application implementing Clean Architecture (DDD) with MobX state management.

## Architecture

This project follows **Domain-Driven Design (DDD)** principles with a clean architecture approach:

### Layer Structure

```
lib/
├── core/                     # Core functionality
│   ├── di/                   # Dependency Injection (GetIt + Injectable)
│   ├── errors/               # Error handling (Failures, Exceptions)
│   ├── network/              # Network layer (Dio client)
│   ├── router/               # Navigation (GoRouter)
│   ├── theme/                # App theming and colors
│   └── usecases/             # Base use case
│
├── features/                 # Feature modules
│   └── auth/                 # Authentication feature
│       ├── domain/           # Business logic layer
│       │   ├── entities/     # Domain models
│       │   ├── repositories/ # Repository interfaces
│       │   └── usecases/     # Business use cases
│       ├── data/             # Data layer
│       │   ├── models/       # Data models (DTOs)
│       │   ├── datasources/  # Remote/Local data sources
│       │   └── repositories/ # Repository implementations
│       └── presentation/     # UI layer
│           ├── mobx/         # MobX stores
│           └── pages/        # UI screens
│
└── i18n/                     # Internationalization (Slang)
```

### Tech Stack

- **State Management**: MobX
- **Dependency Injection**: GetIt + Injectable
- **Navigation**: GoRouter
- **Networking**: Dio
- **Functional Programming**: Dartz (Either, Option)
- **Code Generation**: 
  - build_runner
  - mobx_codegen
  - json_serializable
  - freezed
  - slang (i18n)
- **Storage**: SharedPreferences
- **Internationalization**: Slang (EN, VI)

### Design Principles

1. **Clean Architecture**: Separation of concerns with clear boundaries
2. **SOLID Principles**: Single responsibility, dependency inversion
3. **Repository Pattern**: Abstract data sources
4. **Use Case Pattern**: Encapsulate business logic
5. **Dependency Injection**: Loose coupling between modules

### Features

- ✅ Dark/Light theme support
- ✅ Multi-language (EN/VI)
- ✅ Deep linking support
- ✅ Social authentication (Facebook, Google, Apple)
- ✅ Email/Phone authentication

## Getting Started

### Prerequisites

- Flutter SDK (^3.9.2)
- FVM (Flutter Version Management) - recommended

### Installation

1. Install dependencies:
```bash
fvm flutter pub get
```

2. Generate code:
```bash
dart run build_runner build --delete-conflicting-outputs
```

3. Generate translations:
```bash
dart run slang
```

4. Run the app:
```bash
fvm flutter run
```

### Deep Link Testing

Test deep links using ADB:
```bash
adb shell am start -a android.intent.action.VIEW -d "myapp://yourpath" com.example.prj_final_prm
```

## Project Structure Explained

### Domain Layer
- **Entities**: Pure business objects with no dependencies
- **Repositories**: Interfaces defining data contracts
- **Use Cases**: Single-purpose business operations

### Data Layer
- **Models**: Data transfer objects with JSON serialization
- **Data Sources**: Abstract data access (API, local storage)
- **Repository Implementations**: Concrete implementations of domain contracts

### Presentation Layer
- **MobX Stores**: Reactive state management
- **Pages**: UI screens built with Flutter widgets
- **Router**: Declarative navigation with GoRouter

## Code Generation

Run code generation when you:
- Add/modify MobX stores
- Change JSON models
- Update translations

```bash
# Full build
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto-rebuild)
dart run build_runner watch --delete-conflicting-outputs
```

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [MobX for Flutter](https://mobx.netlify.app/)
- [GoRouter](https://pub.dev/packages/go_router)
- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

