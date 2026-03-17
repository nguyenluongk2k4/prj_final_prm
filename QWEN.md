# PRM393 Final Project - Context Guide

## Project Overview

A **Flutter dating application** ("Heart Link") implementing **Clean Architecture (DDD)** with **MobX** state management. The app features user authentication, profile matching, real-time chat, video calls, location tracking, and social features.

### Tech Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter 3.38.5 (managed via FVM) |
| **State Management** | MobX + flutter_mobx |
| **Dependency Injection** | GetIt + Injectable |
| **Navigation** | GoRouter |
| **Backend** | Supabase (PostgreSQL + Realtime) |
| **Authentication** | Firebase Auth |
| **Networking** | Dio |
| **Maps** | flutter_map (Mapbox alternative) |
| **Chat/Call** | Tencent Cloud Chat SDK, Agora RTC Engine |
| **Functional Programming** | Dartz (Either, Option) |
| **Code Generation** | build_runner, freezed, json_serializable, mobx_codegen |
| **i18n** | Slang (EN/VI) |
| **Local Storage** | SharedPreferences |

## Project Structure

```
lib/
├── core/                     # Shared infrastructure
│   ├── di/                   # Dependency Injection (GetIt)
│   ├── errors/               # Failures & Exceptions
│   ├── network/              # Dio client
│   ├── router/               # GoRouter configuration
│   ├── theme/                # AppTheme, AppColors
│   ├── usecases/             # Base UseCase class
│   ├── services/             # Global services (Firebase, Notifications)
│   └── utils/                # Utility functions
│
├── features/                 # Feature modules (DDD structure)
│   ├── auth/                 # Authentication (Firebase, Supabase)
│   ├── home/                 # Main feed, swipe cards
│   ├── profile/              # User profile management
│   ├── chat/                 # Real-time chat (Tencent)
│   ├── call/                 # Video/Audio calls (Agora)
│   ├── map/                  # Location & Map integration
│   ├── album/                # User photo albums
│   └── onboarding/           # First-time user flow
│
├── i18n/                     # Translation files (Slang)
├── gen/                      # Generated assets
└── main.dart                 # App entry point
```

### Feature Module Structure (DDD)

Each feature follows this pattern:

```
features/[feature_name]/
├── domain/
│   ├── entities/             # Pure business objects (freezed)
│   ├── repositories/         # Abstract interfaces
│   └── usecases/             # Business operations
├── data/
│   ├── models/               # DTOs with JSON serialization
│   ├── datasources/          # Remote/Local data access
│   └── repositories/         # Repository implementations
└── presentation/
    ├── stores/               # MobX stores
    ├── pages/                # Full screens
    └── widgets/              # Reusable components
```

## Build & Development Commands

### Setup

```bash
# Install FVM (if not installed)
dart pub global activate fvm

# Install Flutter version
fvm install

# Install dependencies
fvm flutter pub get

# Generate code (MobX, Freezed, JSON, Injectable)
dart run build_runner build --delete-conflicting-outputs

# Generate translations
dart run slang

# Run the app
fvm flutter run
```

### Development Workflow

```bash
# Watch mode for auto-generation on file save
dart run build_runner watch --delete-conflicting-outputs

# Run tests
flutter test

# Static analysis
flutter analyze

# Format code
dart format .
```

## Environment Configuration

The project requires a `.env` file (git-ignored) with:

```env
# Firebase
FIREBASE_API_KEY=
FIREBASE_APP_ID=
FIREBASE_MESSAGING_SENDER_ID=
FIREBASE_PROJECT_ID=

# Supabase
SUPABASE_URL=
SUPABASE_ANON_KEY=

# Mapbox
MAPBOX_ACCESS_TOKEN=pk....

# Tencent (Chat/Call)
TENCENT_SDK_APP_ID=
TENCENT_SECRET_KEY=

# Agora (Video Call)
AGORA_APP_ID=

# Cloudinary (Image Upload)
CLOUDINARY_CLOUD_NAME=
CLOUDINARY_UPLOAD_PRESET=
```

## Key Architectural Patterns

### 1. Repository Pattern
```dart
// Domain layer defines interface
abstract class IAuthRepository {
  Future<Either<Failure, User>> signInWithEmail(String email, String password);
}

// Data layer implements
class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource remoteDataSource;
  // ...
}
```

### 2. Use Case Pattern
```dart
class SignInUseCase implements UseCase<User, SignInParams> {
  final IAuthRepository repository;
  
  @override
  Future<Either<Failure, User>> call(SignInParams params) async {
    return await repository.signInWithEmail(params.email, params.password);
  }
}
```

### 3. MobX Stores
```dart
class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  @observable User? currentUser;
  @observable bool isLoading = false;
  @observable String? errorMessage;

  @action
  Future<void> signIn(String email, String password) async {
    isLoading = true;
    final result = await _signInUseCase(...);
    result.fold(
      (failure) => errorMessage = failure.message,
      (user) => currentUser = user,
    );
    isLoading = false;
  }
}
```

### 4. Dependency Injection
```dart
@injectable
class AuthStore {
  AuthStore(
    this.signInUseCase,
    this.signUpUseCase,
    // ...
  );
}

// Usage in UI
final store = GetIt.I<AuthStore>();
```

## Development Conventions

### Code Style
- **File naming**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `lowerCamelCase`
- **Use trailing commas** for widget trees and collections
- **Do not edit** generated files (`*.g.dart`, `*.freezed.dart`, `lib/gen/`)

### Testing
- Place tests in `test/` directory
- Name files `*_test.dart`
- Use `flutter_test` package
- Test critical business logic and UI flows

### Git Commits
- Short, lowercase summaries (e.g., "add swipe", "fix auth")
- Descriptive but concise
- No placeholder messages

## Feature Status

| Feature | Status | Notes |
|---------|--------|-------|
| Authentication | ✅ Complete | Firebase + Supabase |
| Profile Management | ✅ Complete | CRUD operations |
| Swipe/Matching | ✅ Complete | Card swiping UI |
| Real-time Chat | ✅ Complete | Tencent SDK |
| Video/Audio Calls | ✅ Complete | Agora SDK |
| Location/Map | ✅ Implemented | flutter_map |
| Photo Albums | ✅ Complete | Cloudinary storage |
| Push Notifications | ✅ Complete | Firebase Messaging |
| i18n (EN/VI) | ✅ Complete | Slang |

## Important Notes

### Code Generation Triggers
Run `build_runner` after:
- Adding/modifying MobX stores (`@observable`, `@action`)
- Changing Freezed entities/models
- Updating JSON serialization classes
- Adding new injectable services

### Common Issues

**Map Not Loading**
1. Check `.env` has valid `MAPBOX_ACCESS_TOKEN`
2. Verify Android/iOS permissions for location

**Code Generation Errors**
```bash
# Clean and regenerate
rm -rf build/ .dart_tool/
dart run build_runner build --delete-conflicting-outputs
```

**Dependency Issues**
```bash
# Clean install
fvm flutter clean
fvm flutter pub get
```

## Resources

- [Architecture Guide](ARCHITECTURE.md)
- [Setup Instructions](README_SETUP.md)
- [Quick Reference](QUICK_REFERENCE.md)
- [Flutter Documentation](https://docs.flutter.dev/)
- [MobX Guide](https://mobx.netlify.app/)
