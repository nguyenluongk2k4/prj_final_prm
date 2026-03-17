# Copilot AI Instructions - PRM (Profile Matching App)

**Project**: PRM - Dating & Matching Application  
**Tech Stack**: Flutter + Dart + Supabase + MobX  
**Architecture**: Clean Architecture (DDD) with three-layer separation  
**Last Updated**: March 17, 2026

---

## Quick Start for AI Assistant

### Essential Commands
```bash
# Development
flutter run                                    # Run app on connected device
flutter run -d chrome                          # Run on web
flutter run --verbose                          # Debug mode

# Code Generation (ALWAYS run after model/store changes)
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run build_runner watch --delete-conflicting-outputs

# Analysis & Formatting
flutter analyze                                # Check lint errors
dart format lib                                # Auto-format all code
flutter test                                   # Run tests

# Dependencies
flutter pub get                                # Install dependencies
flutter pub upgrade                            # Check for updates
```

### Environment Setup
1. Copy `.env.example` → `.env` (contains SUPABASE_URL, SUPABASE_ANON_KEY, MAPBOX_ACCESS_TOKEN, etc.)
2. Run `flutter pub get`
3. Run `flutter pub run build_runner build --delete-conflicting-outputs`
4. Run `flutter run`

---

## Architecture Overview

### Three-Layer Clean Architecture
```
Presentation Layer (Pages, Stores, Widgets)
        ↑
        └─── depends on ───→ Infrastructure Layer (Datasources, Models, Repositories impl)
                                    ↑
                                    └─── depends on ───→ Domain Layer (Entities, Abstract Repositories, UseCases)
```

**Dependency Rule**: Presentation → Infrastructure → Domain (never reverse)

### Layer Responsibilities

#### **Domain Layer** (`lib/features/[feature]/domain/`)
- ✅ Pure business logic (no Framework, no external services)
- ✅ Abstract classes only (repositories, use cases, entities)
- ✅ Immutable data structures (@immutable)
- ❌ NO database/API calls
- ❌ NO external package dependencies (except dartz)
- ❌ NO framework-specific code

**Example**:
```dart
@immutable
class User {
  final String id;
  final String email;
  
  const User({required this.id, required this.email});
}

abstract class UserRepository {
  Future<User> getUserById(String id);
}
```

#### **Infrastructure Layer** (`lib/features/[feature]/infrastructure/`)
- ✅ Implements abstract domain repositories
- ✅ All external service logic (Supabase, Firebase, APIs)
- ✅ @JsonSerializable models with fromJson, toJson, copyWith
- ✅ Wrap all responses in AuthResponse<T> or custom Response
- ✅ Error handling with try-catch in datasources
- ✅ Return domain entities (not models) from repositories
- ❌ NO direct UI imports
- ❌ NO presentation logic

**Datasource Pattern**:
```dart
class AuthDatasource {
  Future<AuthResponse<UserModel>> login({required String email, required String password}) async {
    try {
      final result = await _client.auth.signInWithPassword(email: email, password: password);
      return AuthResponse.success(UserModel.fromJson(...));
    } catch (e) {
      return AuthResponse.failure('Login failed: ${e.toString()}');
    }
  }
}
```

**Model Pattern** (@JsonSerializable):
```dart
@JsonSerializable()
class UserModel {
  @JsonKey(name: 'user_id')
  final String id;
  
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  UserModel copyWith({String? id, String? email}) => UserModel(
    id: id ?? this.id,
    email: email ?? this.email,
  );
  
  User toDomain() => User(id: id, email: email);
}
```

#### **Presentation Layer** (`lib/features/[feature]/presentation/`)
- ✅ Inject Store via GetIt (not create new instances)
- ✅ Use Observer wrapper for reactive changes
- ✅ Keep business logic in Store, not in State
- ✅ Form validation in TextFormField
- ✅ All async calls in Store methods with isLoading state
- ✅ Navigate using context.goNamed()
- ❌ NO direct repository/datasource imports
- ❌ NO database calls from pages
- ❌ NO business logic in build() method

**Store Pattern (MobX)**:
```dart
class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final AuthDatasource datasource;
  
  @observable
  bool isLoading = false;
  
  @observable
  String? errorMessage;
  
  @observable
  UserModel? currentUser;
  
  @action
  Future<void> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    
    final response = await datasource.login(email: email, password: password);
    
    if (response.success) {
      currentUser = response.data;
    } else {
      errorMessage = response.errorMessage;
    }
    
    isLoading = false;
  }
  
  @action
  void clearMessages() {
    errorMessage = null;
  }
}
```

**Page Pattern**:
```dart
class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final _authStore = getIt<AuthStore>();
  
  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      runAsync(() async {
        await _authStore.login(_emailCtrl.text, _passwordCtrl.text);
        
        if (_authStore.currentUser != null && mounted) {
          context.goNamed(AppRoutes.mainName);
        }
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) => _authStore.isLoading
            ? const LoadingWidget()
            : _buildForm(),
      ),
    );
  }
}
```

---

## Dependency Injection (GetIt)

**CRITICAL RULE**: ***Never use `new` keyword for services. Always inject via GetIt.***

### Registration Pattern
```dart
// lib/core/di/auth_module.dart
@module
abstract class AuthModule {
  @lazySingleton
  AuthDatasource authDatasource(SupabaseClient client) 
    => AuthDatasource(supabaseClient: client);

  @lazySingleton
  AuthStore authStore(AuthDatasource datasource) 
    => AuthStore(authDatasource: datasource);
}
```

### Usage in Pages
```dart
// ✅ CORRECT
class _LoginPageState extends State<LoginPage> {
  late final _authStore = getIt<AuthStore>();
}

// ❌ WRONG - Creates hard dependency
class _LoginPageState extends State<LoginPage> {
  final _authStore = AuthStore(
    datasource: AuthDatasource(client: Supabase.instance.client)
  );
}
```

---

## State Management (MobX)

### Observable Pattern
```dart
@observable
bool isLoading = false;

@observable
String? errorMessage;

@computed
bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
```

### Action Methods
```dart
// ✅ CORRECT - async/await pattern
@action
Future<void> fetchData() async {
  isLoading = true;
  try {
    final response = await datasource.getData();
    if (response.success) {
      data = response.data;
    } else {
      errorMessage = response.errorMessage;
    }
  } catch (e) {
    errorMessage = e.toString();
  }
  isLoading = false;
}

// ❌ WRONG - using .then() chains
@action
Future<void> fetchData() {
  return datasource.getData().then((response) { ... });
}
```

### UI Reactivity
```dart
@override
Widget build(BuildContext context) {
  return Observer(
    builder: (_) {
      if (_store.isLoading) return LoadingWidget();
      if (_store.hasError) return ErrorWidget(message: _store.errorMessage!);
      return SuccessWidget();
    },
  );
}
```

### Post-Async Navigation
```dart
// ✅ CORRECT - Use runAsync for navigation after store action
void _handleLogin() {
  runAsync(() async {
    await _authStore.login(email, password);
    if (_authStore.currentUser != null && mounted) {
      context.goNamed(AppRoutes.mainName);
    }
  });
}

// ❌ WRONG - Race condition
void _handleLogin() {
  _authStore.login(email, password);
  context.goNamed(AppRoutes.mainName);  // Navigates before login!
}
```

---

## Naming Conventions

| Element | Pattern | Example |
|---------|---------|---------|
| Class | PascalCase | `UserModel`, `AuthStore`, `LoginPage` |
| File | snake_case | `user_model.dart`, `auth_store.dart` |
| Variable | camelCase | `isLoading`, `currentUser`, `emailController` |
| Constant | camelCase | `kMaxRetries = 3` |
| Enum | PascalCase (enum), camelCase (values) | `enum Status { active, inactive }` |

### Import Order
```dart
// 1. Dart imports
import 'dart:async';

// 2. Flutter imports
import 'package:flutter/material.dart';

// 3. Package imports
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// 4. Internal imports (full path)
import 'package:prj_final_prm/core/di/injection.dart';

// 5. Relative imports
import '../stores/auth_store.dart';

// 6. Generated files
part 'auth_store.g.dart';
```

---

## Error Handling Strategy

### Datasource Level - Always wrap external calls
```dart
Future<AuthResponse<UserModel>> login({...}) async {
  try {
    final result = await _client.auth.signInWithPassword(...);
    return AuthResponse.success(UserModel.fromJson(...));
  } on AuthException catch (e) {
    return AuthResponse.failure('Auth: ${e.message}');
  } on SocketException {
    return AuthResponse.failure('Network error');
  } catch (e) {
    return AuthResponse.failure('Unknown: $e');
  }
}
```

### Store Level - Handle response and set state
```dart
@action
Future<void> login(String email, String password) async {
  isLoading = true;
  final response = await datasource.login(email: email, password: password);
  
  if (response.success) {
    currentUser = response.data;
    isAuthenticated = true;
  } else {
    errorMessage = response.errorMessage ?? 'Unknown error';
    isAuthenticated = false;
  }
  
  isLoading = false;
}
```

### Page Level - Display to user
```dart
@override
Widget build(BuildContext context) {
  return Observer(
    builder: (_) => Column(
      children: [
        if (_authStore.hasError)
          ErrorBanner(message: _authStore.errorMessage!),
        // ... rest of UI
      ],
    ),
  );
}
```

---

## Code Generation

### CRITICAL: Always regenerate after model/store changes
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### What Triggers Regeneration
- ✅ Add `@JsonSerializable()` or `@observable` annotations
- ✅ Modify store fields/methods
- ✅ Change model structure
- ✅ Add freezed classes
- ✅ Update i18n JSON files

### Generated Files (DO NOT EDIT manually)
- `*.g.dart` (JSON serialization)
- `*.g.dart` (MobX observables)
- Generated `.config.dart` files

---

## Internationalization (i18n)

### Usage in Code
```dart
import 'package:prj_final_prm/i18n/strings.g.dart';

// In build:
final t = Translations.of(context);
Text(t.auth.login_button)

// In Store (no context):
final t = Translations.of(context);
```

### Adding New Strings
1. Edit `lib/i18n/strings.i18n.json` (English)
2. Edit `lib/i18n/strings_vi.i18n.json` (Vietnamese)
3. Run build_runner:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Use in code: `t.your.new.key`

---

## Feature Structure Template

When creating a new feature, follow this exact structure:

```
lib/features/[feature]/
├── [feature].dart                          # Barrel export (optional)
├── domain/
│   ├── entities/
│   │   └── *.dart                          # Pure data classes
│   ├── repositories/
│   │   └── [feature]_repository.dart       # Abstract interface
│   └── usecases/
│       └── *.dart                          # Business operations
├── infrastructure/
│   ├── datasources/
│   │   ├── datasources.dart                # Barrel export
│   │   └── [feature]_datasource.dart       # Supabase/API wrapper
│   ├── models/
│   │   ├── models.dart                     # Barrel export
│   │   └── *_model.dart                    # @JsonSerializable models
│   └── repositories/
│       └── [feature]_repository_impl.dart  # Implementation
└── presentation/
    ├── stores/
    │   └── [feature]_store.dart            # MobX store
    ├── pages/
    │   └── *.dart                          # UI screens
    └── widgets/
        └── *.dart                          # Reusable components
```

---

## Project Structure Overview

```
lib/
├── main.dart                               # App entry point
├── core/
│   ├── di/                                 # Dependency Injection modules
│   │   ├── injection.dart                  # GetIt setup
│   │   ├── auth_module.dart
│   │   └── *.dart
│   ├── errors/                             # Failures, Exceptions
│   ├── network/                            # Dio client configuration
│   ├── router/                             # GoRouter setup
│   │   ├── app_router.dart
│   │   └── app_routes.dart
│   ├── theme/                              # Colors, TextStyles
│   └── usecases/                           # Base UseCase class
├── features/
│   ├── auth/                               # Authentication feature
│   ├── match/                              # Matching feature
│   ├── chat/                               # Chat feature
│   └── *.dart                              # Other features
├── gen/                                    # Generated assets (not manual)
└── i18n/                                   # i18n generated strings
    ├── strings.g.dart                      # Generated
    └── strings.i18n.json                   # Source (edit this)
```

---

## Debugging Checklist

### "Expression evaluates to a not supported value"
- Caused by: Public fields in Store without @observable
- Fix: Add `@observable` to all state in Store

### "The getter 'X' isn't defined for type 'AuthStore'"
- Caused by: Generated .g.dart files out of sync
- Fix: Run `flutter pub run build_runner build --delete-conflicting-outputs`

### "Circular import between layers"
- Caused by: Infrastructure importing Presentation or Domain importing Infrastructure
- Rule: Always depend upward (Presentation → Infrastructure → Domain)

### "Models not serializing correctly"
- Caused by: @JsonKey names don't match database fields
- Fix: Use `@JsonKey(name: 'db_column_name')` on each field

### App crashes with "No provider for AuthStore"
- Caused by: Store not registered in GetIt
- Fix: Verify module is registered in `lib/core/di/injection.dart`

### "Cannot run build_runner on Windows"
- Solution: Use WSL or run from terminal with admin privileges

---

## Development Workflow

### Before Starting Work
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter analyze
```

### During Development
Keep watch mode running in separate terminal:
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Before Committing
```bash
# 1. Format code
dart format lib

# 2. Analyze
flutter analyze

# 3. Run tests (if exist)
flutter test

# 4. Build once to verify
flutter pub run build_runner build --delete-conflicting-outputs

# 5. Final check
git diff                                     # Review changes
git status
```

### Commit Message Format
```
feat: add [feature_name]
  - Add domain layer (entities, repositories)
  - Add infrastructure layer (datasources, models)
  - Add presentation layer (stores, pages)
  - Add DI module

Closes #[issue]
```

---

## Key Principles & Anti-Patterns

### ✅ DO
- ✅ Inject dependencies via GetIt, not with `new` keyword
- ✅ Keep all async operations in Store methods only
- ✅ Use @observable for all state in MobX Store
- ✅ Wrap external service calls in try-catch with AuthResponse<T>
- ✅ Return domain entities from repositories, not models
- ✅ Use Observer wrapper for reactive UI updates
- ✅ Run build_runner after every model/store change
- ✅ Use context.goNamed() for navigation
- ✅ Validate user input before store method calls
- ✅ Pass isLoading state to Show/Hide UI elements

### ❌ DON'T
- ❌ Call Supabase directly from pages or stores
- ❌ Import infrastructure directly in presentation
- ❌ Create multiple stores per feature
- ❌ Hardcode strings (use i18n)
- ❌ Ignore build_runner .g.dart changes
- ❌ Return models to UIlayer (convert to entities)
- ❌ Make external service calls from build() method
- ❌ Modify Store state directly (always use @action)
- ❌ Skip error handling in datasources
- ❌ Store sensitive data in public Store properties

---

## External Services Integration

### Supabase Usage
- Initialize in: `lib/core/network/supabase_client.dart`
- Wrap in: `infrastructure/datasources/[feature]_datasource.dart`
- Return: `AuthResponse<Model>` from all methods
- Do NOT call directly from pages

### Firebase Auth (Phone OTP)
- Configured via `flutterfire configure`
- Used in: `infrastructure/repositories/auth_repository_impl.dart`
- Request tokens via store: `await _authStore.sendOTP(phone)`
- Verify tokens via store: `await _authStore.verifyOTP(otp)`

### GoRouter Navigation
```dart
// Define route
GoRoute(
  name: AppRoutes.loginName,
  path: '/login',
  builder: (context, state) => const LoginPage(),
)

// Navigate
context.goNamed(AppRoutes.mainName);
context.push('/path');
```

### i18n with Slang
- Source files: `lib/i18n/*.i18n.json`
- Usage: `t.feature.key` (auto-generated)
- Pluralization supported: `t.item.count(n: 5)`

---

## Performance Tips

1. **Use `@computed` in Store** - Caches calculation results
   ```dart
   @computed
   bool get isValid => email.isNotEmpty && password.length >= 8;
   ```

2. **Lazy-load dependencies** - Use `@lazySingleton` in di/modules
   ```dart
   @lazySingleton
   AuthStore authStore(AuthDatasource ds) => AuthStore(authDatasource: ds);
   ```

3. **Dispose resources** - Clean up controllers
   ```dart
   @override
   void dispose() {
     _emailController.dispose();
     super.dispose();
   }
   ```

4. **Use `const` widgets** - Prevents rebuilds
   ```dart
   const SizedBox(height: 16)  // ✅ const
   SizedBox(height: 16)        // ❌ rebuilds every time
   ```

---

## Common Questions

**Q: Where should I validate user input?**  
A: In TextFormField validators for UI validation, in Store for business logic validation.

**Q: How do I share data between features?**  
A: Via domain entities passed through navigation or shared Store (if critical app state).

**Q: Can I call multiple Store methods in sequence?**  
A: Yes, but use `runAsync()` to avoid race conditions:
```dart
runAsync(() async {
  await store.method1();
  await store.method2();
  if (mounted) navigate();
});
```

**Q: How do I mock Store in tests?**  
A: Use MockMobX or create MockStore class implementing the interface.

**Q: Should I use Provider instead of MobX?**  
A: No, this project uses MobX exclusively for consistency.

---

## References & Documentation

- **Flutter**: https://flutter.dev/docs
- **MobX**: https://mobx.pub
- **GoRouter**: https://pub.dev/packages/go_router
- **GetIt**: https://pub.dev/packages/get_it  
- **Supabase**: https://supabase.com/docs/guides/getting-started/quickstarts/flutter
- **Firebase**: https://firebase.flutter.dev
- **Slang i18n**: https://pub.dev/packages/slang

---

## For AI Assistants

When implementing features:

1. **Always check the attached architecture rules** - Reference ARCHITECTURE_RULES.md, AUTH_ARCHITECTURE.md, FEATURE_CHECKLIST.md
2. **Follow the exact layer structure** - Never deviate from Domain → Infrastructure → Presentation
3. **Use existing patterns** - Copy from auth feature and adapt (it's the golden standard)
4. **Run build_runner** - After every model/store change: `flutter pub run build_runner build --delete-conflicting-outputs`
5. **Test injection** - Verify GetIt registration in `lib/core/di/injection.dart`
6. **Use Observer wrapper** - All pages reading observable state must wrap in Observer
7. **Handle errors** - No raw exceptions should reach UI layer
8. **Clean code** - Run `dart format lib` and `flutter analyze` before completion

---

**Maintainers**: Development Team  
**Last Updated**: March 17, 2026  
**Version**: 1.0 - Initial Bootstrap
