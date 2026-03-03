# Architecture Rules & Standards

**Project**: PRM (Profile Match)  
**Stack**: Flutter + Dart + Supabase + MobX  
**Last Updated**: March 3, 2026

---

## Core Architecture Principles

### 1. Three-Layer Clean Architecture
Every feature must implement exactly 3 layers:

```
Domain Layer (Business Logic)
    ↑
    ├─── Infrastructure Layer (Data & Services)
    │
Presentation Layer (UI & State)
```

**Dependency Rule**: Presentation → Infrastructure → Domain (never reverse)

### 2. Single Responsibility Principle
Each file handles ONE responsibility:

| File Type | Responsibility |
|-----------|-----------------|
| Entity | Define data structure (no logic) |
| Repository (abstract) | Define contract (no implementation) |
| UseCase | Single business operation |
| Datasource | External service integration |
| Model | Map/transform data with @JsonSerializable |
| Repository (impl) | Orchestrate datasource → domain transformation |
| Store | State management and reactions |
| Page | UI layout and form handling |
| Widget | Reusable UI component |

### 3. Dependency Injection Rule
**NEVER instantiate classes with `new` keyword. Always inject via GetIt.**

```dart
// ❌ WRONG - Creates hard dependency
class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final store = AuthStore(
    datasource: AuthDatasource(
      client: Supabase.instance.client
    )
  );
}

// ✅ CORRECT - Injected via GetIt
class _MyPageState extends State<MyPage> {
  late final store = getIt<AuthStore>();
}
```

**Register in**: `lib/core/di/[feature]_module.dart`

---

## Layer-Specific Rules

### Domain Layer

**Location**: `lib/features/[feature]/domain/`

**Rules**:
1. ✅ Abstract classes only (repositories, use cases, entities)
2. ✅ Pure Dart code (no external packages)
3. ✅ Immutable data structures (@immutable)
4. ✅ Functional programming patterns where possible
5. ✅ Fail loudly with exceptions (not Optional/null)
6. ✅ No imports from infrastructure or presentation
7. ❌ No @JsonSerializable annotations
8. ❌ No external package dependencies (except dartz for Either)
9. ❌ No database/API calls
10. ❌ No framework-specific code

**Example - Correct**:
```dart
// domain/entities/user.dart
@immutable
class User {
  final String id;
  final String email;
  
  const User({required this.id, required this.email});
}

// domain/repositories/user_repository.dart
abstract class UserRepository {
  Future<User> getUserById(String id);
}
```

### Infrastructure Layer

**Location**: `lib/features/[feature]/infrastructure/`

**Rules**:
1. ✅ Implement abstract domain repositories
2. ✅ Contain all external service logic (Supabase, Firebase, APIs)
3. ✅ Use @JsonSerializable for Models
4. ✅ Include fromJson, toJson, copyWith on models
5. ✅ Return domain entities (not models) from repositories
6. ✅ Wrap all responses in AuthResponse<T> (or custom Response)
7. ✅ Error handling with try-catch in datasources
8. ✅ Use model.toDomain() to convert to entities
9. ❌ No direct UI imports
10. ❌ No presentation logic
11. ❌ Raw Supabase exceptions should not propagate to UI

**Datasource Rules**:
```dart
// infrastructure/datasources/auth_datasource.dart
class AuthDatasource {
  final SupabaseClient _client;
  
  // ✅ All methods return AuthResponse<T>
  Future<AuthResponse<UserModel>> login({...}) async {
    try {
      // Supabase call
      final result = await _client.auth.signInWithPassword(...);
      // Transform to model
      final user = UserModel.fromJson(result.user!.userMetadata!);
      return AuthResponse.success(user);
    } catch (e) {
      // Wrap error
      return AuthResponse.failure('Login failed: ${e.toString()}');
    }
  }
}

// ❌ DON'T - Raw exceptions, no wrapper
class AuthDatasource {
  Future<UserModel> login({...}) async {
    final result = await _client.auth.signInWithPassword(...);
    return UserModel.fromJson(result.user!.userMetadata!);
  }
}
```

**Model Rules**:
```dart
@JsonSerializable()
class UserModel {
  @JsonKey(name: 'user_id') // Map to DB field name
  final String id;
  
  @JsonKey(name: 'email_address')
  final String email;
  
  // ✅ Required methods
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  UserModel copyWith({
    String? id,
    String? email,
  }) => UserModel(
    id: id ?? this.id,
    email: email ?? this.email,
  );
  
  // ✅ Optional: conversion to domain entity
  User toDomain() => User(id: id, email: email);
}
```

**Repository Impl Rules**:
```dart
// infrastructure/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;
  
  AuthRepositoryImpl({required this.datasource});
  
  @override
  Future<User> login(String email, String password) async {
    final response = await datasource.login(email: email, password: password);
    
    if (response.success) {
      // Transform model → domain entity
      return User(
        id: response.data!.id,
        email: response.data!.email,
      );
    } else {
      throw Exception(response.errorMessage);
    }
  }
}
```

### Presentation Layer

**Location**: `lib/features/[feature]/presentation/`

**Rules**:
1. ✅ Inject Store via GetIt (not create new instances)
2. ✅ Use Observer wrapper for any reactive changes
3. ✅ Keep business logic in Store, not in State
4. ✅ Form validation in TextFormField
5. ✅ All async calls in Store methods, handle via isLoading
6. ✅ Listen to Store observables for navigation
7. ✅ Use context.goNamed() for routing
8. ✅ Clear error messages after user interaction
9. ❌ No direct repository/datasource imports
10. ❌ No database calls from pages
11. ❌ No external service calls in build()
12. ❌ Business logic in State (State is for UI state only)

**Store Rules**:
```dart
// ✅ CORRECT MobX Store Pattern
class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final AuthDatasource datasource; // Inject, don't create
  
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

**Page Rules**:
```dart
// ✅ CORRECT Page Pattern
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  
  late final _authStore = getIt<AuthStore>(); // Inject once
  
  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
  
  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      runAsync(() async {
        await _authStore.login(
          _emailCtrl.text.trim(),
          _passwordCtrl.text,
        );
        
        if (_authStore.currentUser != null && mounted) {
          context.goNamed(AppRoutes.mainName);
        }
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.login)),
      body: Observer(
        builder: (_) => _authStore.isLoading
            ? const LoadingWidget()
            : _buildForm(), // Form with _handleLogin button
      ),
    );
  }
  
  Widget _buildForm() => Form(
    key: _formKey,
    child: Column(
      children: [
        TextFormField(
          controller: _emailCtrl,
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        // Error display
        if (_authStore.errorMessage != null)
          Text(_authStore.errorMessage!),
        ElevatedButton(
          onPressed: _authStore.isLoading ? null : _handleLogin,
          child: Text(t.login),
        ),
      ],
    ),
  );
}
```

---

## Code Style Rules

### Naming Conventions

| Element | Pattern | Example |
|---------|---------|---------|
| Classes | PascalCase | `UserModel`, `AuthStore`, `LoginPage` |
| Files | snake_case | `user_model.dart`, `auth_store.dart` |
| Variables | camelCase | `isLoading`, `currentUser`, `emailController` |
| Constants | camelCase | `kMaxRetries = 3`, `kDefaultTimeout` |
| Enums | PascalCase enum, camelCase values | `enum Status { active, inactive }` |
| Imports | Full path + alias if needed | `import 'package:prj_final_prm/...' as prm;` |

### Import Order

```dart
// 1. Dart imports
import 'dart:async';
import 'dart:io';

// 2. Flutter imports
import 'package:flutter/material.dart';

// 3. Package imports (external packages)
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// 4. Internal imports (prj_final_prm)
import 'package:prj_final_prm/core/di/injection.dart';
import 'package:prj_final_prm/features/auth/domain/repositories/auth_repository.dart';

// 5. Relative imports (same package)
import '../stores/auth_store.dart';

// 6. Generated files (if any)
part 'auth_store.g.dart';
```

### Widget Structure

```dart
class MyPage extends StatefulWidget {
  const MyPage({super.key, required this.param});
  
  final String param;
  
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  // 1. Late final injected dependencies
  late final store = getIt<MyStore>();
  
  // 2. Controllers
  final _textController = TextEditingController();
  
  // 3. Form keys
  final _formKey = GlobalKey<FormState>();
  
  // 4. Observable variables
  // (Move to Store, not State!)
  
  @override
  void initState() {
    super.initState();
    // Initialize listeners, fetch data via store
    _initializeData();
  }
  
  @override
  void dispose() {
    // Clean up controllers
    _textController.dispose();
    // Store cleanup happens in Store.dispose()
    super.dispose();
  }
  
  Future<void> _initializeData() async {
    // ...
  }
  
  void _handleAction() {
    // Call store methods, NOT business logic
    store.doSomething();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(...),
      body: Observer(
        builder: (_) => _buildContent(),
      ),
    );
  }
  
  Widget _buildContent() {
    // UI code here
    return const Center(child: Text('Content'));
  }
}
```

---

## Async/Await Rules

### Store Actions

**Never use `.then()` chains. Always use `async/await`.**

```dart
// ✅ CORRECT
@action
Future<void> fetchUser(String id) async {
  isLoading = true;
  try {
    final response = await datasource.getUser(id);
    if (response.success) {
      currentUser = response.data;
    } else {
      errorMessage = response.errorMessage;
    }
  } catch (e) {
    errorMessage = 'Error: $e';
  }
  isLoading = false;
}

// ❌ WRONG - using .then()
@action
Future<void> fetchUser(String id) {
  return datasource.getUser(id).then((response) {
    if (response.success) {
      currentUser = response.data;
    }
  });
}
```

### Page Async Handling

```dart
// ✅ CORRECT - using runAsync for post-async navigation
void _handleLogin() {
  if (_formKey.currentState!.validate()) {
    runAsync(() async {
      await _authStore.login(email, password);
      
      if (_authStore.isAuthenticated && mounted) {
        context.goNamed(AppRoutes.mainName);
      }
    });
  }
}

// ❌ WRONG - race condition with navigation
void _handleLogin() {
  _authStore.login(email, password);
  context.goNamed(AppRoutes.mainName); // Navigates before login completes!
}
```

---

## Error Handling Strategy

### Datasource Level
Catch all exceptions, return failure response:

```dart
Future<AuthResponse<UserModel>> login({...}) async {
  try {
    final result = await _client.auth.signInWithPassword(...);
    return AuthResponse.success(UserModel.fromJson(...));
  } on AuthException catch (e) {
    return AuthResponse.failure('Auth error: ${e.message}');
  } on SocketException {
    return AuthResponse.failure('Network error: No internet');
  } catch (e) {
    return AuthResponse.failure('Unknown error: $e');
  }
}
```

### Store Level
Handle response, set error message observable:

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

### Page Level
Display observable error to user:

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

## Testing Rules

### Unit Test Pattern
```dart
void main() {
  group('AuthDatasource', () {
    late MockSupabaseClient mockClient;
    late AuthDatasource datasource;
    
    setUp(() {
      mockClient = MockSupabaseClient();
      datasource = AuthDatasource(supabaseClient: mockClient);
    });
    
    test('login should return success response on valid credentials', () async {
      // Arrange
      when(mockClient.auth.signInWithPassword(...))
          .thenAnswer((_) => Future.value(mockAuthResponse));
      
      // Act
      final result = await datasource.login(email: 'test@test.com', password: 'pass');
      
      // Assert
      expect(result.success, isTrue);
      expect(result.data, isNotNull);
    });
  });
}
```

---

## Database Schema Rules

### Table Naming
- snake_case: `users`, `auth_tokens`, `user_preferences`
- No plurals for junction tables: `user_preference` (not `user_preferences`) ← But use plural if collection
- Prefix with relation: `user_conversations`, `message_reactions`

### Column Naming
- snake_case: `user_id`, `created_at`, `email_address`
- ID columns: `id` (primary), `[table]_id` (foreign)
- Timestamps: `created_at`, `updated_at`, `deleted_at`
- Booleans: `is_active`, `has_verified`, `can_edit`

### Foreign Key Constraints
- ON DELETE CASCADE for dependent records
- ON UPDATE CASCADE for reference integrity
- Unique constraints on business logic fields

---

## Build & Deployment

### Before Committing

```bash
# 1. Regenerate files
flutter pub run build_runner build --delete-conflicting-outputs

# 2. Format code
dart format lib

# 3. Analyze code
flutter analyze

# 4. Run tests
flutter test

# 5. Check imports
dart run linter lib/
```

### CI/CD Pipeline
(To implement)
- Lint checks
- Test coverage minimum 70%
- Build APK/IPA on main branch
- Deploy to TestFlight/Play Store internal testing

---

## Maintenance Rules

### Deprecated Patterns
- ❌ `Provider` - Use MobX instead
- ❌ `GetX` - Use GoRouter + MobX
- ❌ `Firebase Realtime DB` - Use Supabase PostgreSQL
- ❌ `SharedPreferences for auth tokens` - Use flutter_secure_storage

### Migration Path
When refactoring old code:
1. Create new structure in parallel
2. Migrate feature by feature
3. Add tests for new implementation
4. Deprecate old code (but keep for fallback)
5. Remove old code after 2 releases

---

**Enforcement**: Code review checklist - all PRs must follow these rules.  
**Exceptions**: Document in PR with @[architect] approval.  
**Review Cycle**: Every 6 months or after major framework update.
