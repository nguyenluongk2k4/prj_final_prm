# Auth Feature Architecture

## Overview
Clean architecture pattern with Clear Separation of Concerns (SoC) for authentication feature using Supabase.

## Folder Structure

```
lib/features/auth/
├── auth.dart                          # Barrel export (entry point)
├── domain/                            # Business logic (entities, use cases, interfaces)
│   ├── entities/
│   │   ├── user.dart
│   │   └── user_profile.dart
│   ├── repositories/
│   │   └── auth_repository.dart       # Abstract interface
│   └── usecases/
│       ├── check_auth_usecase.dart
│       ├── login_usecase.dart
│       ├── logout_usecase.dart
│       ├── sign_in_phone_usecase.dart
│       └── verify_otp_usecase.dart
├── infrastructure/                    # Data layer (models, datasources, repositories impl)
│   ├── datasources/
│   │   ├── datasources.dart           # Barrel export
│   │   └── auth_datasource.dart       # Supabase client wrapper
│   ├── models/
│   │   ├── models.dart                # Barrel export
│   │   ├── user_model.dart            # @JsonSerializable (id, email, name, phone, etc)
│   │   ├── user_model.g.dart          # Generated JSON serialization (auto)
│   │   ├── auth_response.dart         # Generic AuthResponse<T> wrapper
│   │   └── user_profile_model.dart    # Legacy profile model
│   └── repositories/
│       └── auth_repository_impl.dart  # Implements auth_repository (phone OTP)
└── presentation/                      # UI layer (pages, stores, widgets)
    ├── pages/
    │   ├── login_page.dart            # Email + password login
    │   ├── email_register_page.dart   # Email signup
    │   ├── signup_page.dart           # Signup method selection
    │   ├── phone_signup_page.dart     # Phone signup entry
    │   ├── verification_page.dart     # OTP verification
    │   ├── interests_page.dart        # Select user interests/preferences
    │   ├── gender_selection_page.dart # Gender selection
    │   ├── profile_details_page.dart  # Bio, location details
    │   └── notification_page.dart     # Notification settings
    └── stores/
        └── auth_store.dart            # MobX observable state management

```

## Layer Responsibilities

### 1. Domain Layer
**Purpose**: Pure business logic, independent of external frameworks

**Rules**:
- No imports from `infrastructure/` or `presentation/`
- Only abstract classes (repositories), entities, and use cases
- Framework-agnostic Dart code only
- No external dependencies except `dartz` for Either/Task

**File Example**:
```dart
// domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<Either<Failure, UserProfile>> login(String email, String password);
  Future<Either<Failure, UserProfile>> signUp(SignUpParams params);
  Future<Either<Failure, void>> logout();
}
```

### 2. Infrastructure Layer
**Purpose**: External service integration and data transformation

**Rules**:
- Implements abstract repositories from domain layer
- Contains datasources (Supabase, Firebase, APIs)
- Models with @JsonSerializable for serialization
- No direct access from presentation layer
- All Supabase calls happen here only

**Subdirectories**:

#### `datasources/`
- Wrappers around external services (Supabase client)
- Create AuthDatasource for each backend service type
- Methods must return domain entities or generic responses

**Example**:
```dart
// infrastructure/datasources/auth_datasource.dart
class AuthDatasource {
  final SupabaseClient _supabaseClient;
  
  Future<UserModel?> getCurrentUser() async { ... }
  Future<AuthResponse<UserModel>> login({...}) async { ... }
  Future<AuthResponse<UserModel>> signup({...}) async { ... }
}
```

#### `models/`
- Extend or map to domain entities
- Use @JsonSerializable for automatic serialization
- Must include `fromJson()`, `toJson()`, `copyWith()`
- Store in barrel export file

**Template**:
```dart
@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  // ... other fields
  
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  UserModel copyWith({...}) { ... }
}
```

#### `repositories/`
- Implements abstract domain repositories
- Injects datasources
- Handles data transformation domain ↔ infrastructure

### 3. Presentation Layer
**Purpose**: UI and state management

**Rules**:
- Depends on domain layer (repositories, usecases, entities)
- No direct Supabase calls
- State management via MobX (Store pattern)
- Pages use Observer wrapper for reactivity
- Navigation via GoRouter

**Subdirectories**:

#### `stores/`
- MobX observable stores
- Only one main store per feature (auth_store.dart)
- Manages loading states, errors, success messages
- Subscribes to datasource changes

**Template**:
```dart
class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final AuthDatasource authDatasource;
  
  @observable
  UserModel? currentUser;
  
  @observable
  bool isLoading = false;
  
  @action
  Future<void> login({required String email, required String password}) async {
    isLoading = true;
    final response = await authDatasource.login(email: email, password: password);
    if (response.success) {
      currentUser = response.data;
    }
    isLoading = false;
  }
}
```

#### `pages/`
- Stateful widgets using GetIt for store injection
- Use Observer wrapper for state changes
- Handle navigation on success/failure
- Implement form validation

**Template**:
```dart
class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final _authStore = getIt<AuthStore>();
  
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => _authStore.isLoading
          ? LoadingWidget()
          : _buildLoginForm(),
    );
  }
}
```

## Dependency Injection (DI)

**Location**: `lib/core/di/auth_module.dart`

**Pattern**:
```dart
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

**Usage**: 
```dart
final authStore = getIt<AuthStore>();
```

## Data Flow Diagram

```
UI Layer (Pages)
     ↓
State Management (AuthStore via MobX)
     ↓
Infrastructure (AuthDatasource)
     ↓
Supabase External Service
     ↓
PostgreSQL Database
```

## Authentication Flow

### Email/Password Login
```
LoginPage → _handleLogin() 
  → authStore.login(email, password)
    → authDatasource.login(email, password)
      → supabase.auth.signInWithPassword()
      → fetch user from 'users' table
      → return AuthResponse<UserModel>
    → authStore.currentUser = response.data
    → authStore.isAuthenticated = true
  → Observer detects change → navigate to mainName
```

### Email/Password Signup
```
EmailRegisterPage → _handleRegister()
  → authStore.signup(email, password, name)
    → authDatasource.signup(...)
      → supabase.auth.signUp()
      → insert into 'users' table
      → insert into 'profiles' table
      → link preferences
      → return AuthResponse<UserModel>
    → authStore.currentUser = response.data
    → authStore.isAuthenticated = true
  → Observer detects change → navigate to interestsName
```

## Key Design Decisions

### 1. Generic AuthResponse<T>
- **Why**: Encapsulates success/failure with typed data
- **Benefits**: Type-safe, consistent API across datasources

```dart
class AuthResponse<T> {
  final bool success;
  final T? data;
  final String? errorMessage;
  
  factory AuthResponse.success(T data) => AuthResponse(success: true, data: data);
  factory AuthResponse.failure(String message) => AuthResponse(success: false, errorMessage: message);
}
```

### 2. Datasource Pattern
- **Why**: Isolates external service logic
- **Benefits**: Easy to mock, swap backends, test independently

### 3. MobX Observable Store
- **Why**: Simple reactive state management
- **Benefits**: Auto-tracking, no boilerplate, fine-grained reactivity

### 4. Barrel Exports
- **Why**: Clean import statements
- **Benefits**: `export 'models.dart'` instead of multiple imports

```dart
// infrastructure/models/models.dart
export 'user_model.dart';
export 'auth_response.dart';
export 'user_profile_model.dart';

// Now in pages:
import 'infrastructure/models/models.dart'; // Gets all three
```

## Important Rules for Consistency

### ✅ DO
- ✅ Keep domain layer pure (no framework code)
- ✅ All external calls in datasources only
- ✅ Use AuthResponse<T> for all datasource methods
- ✅ Inject dependencies via GetIt
- ✅ Use Observer wrapper for reactive UI
- ✅ Implement navigation post-auth in pages
- ✅ Add error handling with try-catch in datasources
- ✅ Use @JsonSerializable for models

### ❌ DON'T
- ❌ Import infrastructure directly in pages (use domain layer)
- ❌ Call Supabase from pages or stores
- ❌ Mix business logic in UI code
- ❌ Create multiple stores per feature
- ❌ Hardcode strings (use i18n)
- ❌ Skip validation on user input
- ❌ Return raw Supabase responses (wrap in models)
- ❌ Async operations without try-catch

## Extending This Pattern to Other Features

### For Phone Authentication
Already implemented in `auth_repository_impl.dart` (Firebase OTP pattern).

**Structure**:
```
lib/features/auth/
└── infrastructure/
    └── repositories/
        └── auth_repository_impl.dart  ← Phone OTP logic
```

**To Add New Service**:
1. Create new datasource: `phone_auth_datasource.dart`
2. Inject in `auth_module.dart`
3. Call from store methods
4. Follow same AuthResponse<T> pattern

### For Other Features (e.g., Chat, Match)
Follow the same three-layer structure:

```
lib/features/[feature]/
├── [feature].dart
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── infrastructure/
│   ├── datasources/
│   ├── models/
│   └── repositories/
└── presentation/
    ├── pages/
    └── stores/
```

## Testing Strategy

### Unit Tests
- Domain layer: Test entities, repositories
- Infrastructure: Mock datasources, test transformations
- Presentation: Mock stores, test UI behavior

### Integration Tests
- Database: Test Supabase queries
- End-to-end: Full auth flow signup → home

## File Naming Conventions

| Layer | Pattern | Example |
|-------|---------|---------|
| Domain Entity | `entity_name.dart` | `user.dart` |
| Domain Repository | `[name]_repository.dart` | `auth_repository.dart` |
| Domain UseCase | `[action]_usecase.dart` | `login_usecase.dart` |
| Model | `[name]_model.dart` | `user_model.dart` |
| Datasource | `[name]_datasource.dart` | `auth_datasource.dart` |
| Repository Impl | `[name]_repository_impl.dart` | `auth_repository_impl.dart` |
| Page | `[name]_page.dart` | `login_page.dart` |
| Store | `[name]_store.dart` | `auth_store.dart` |
| Widget | `[name]_widget.dart` | `custom_button_widget.dart` |

## Common Issues & Solutions

### Issue: "The getter 'X' isn't defined for type 'AuthStore'"
**Cause**: Store not refreshed after rebuilding generated files
**Solution**: Run `flutter pub run build_runner build --delete-conflicting-outputs`

### Issue: Multiple AuthResponse imports conflict
**Cause**: Both gotrue and custom AuthResponse<T> imported
**Solution**: Use alias in import or hide one: `import 'package:supabase_flutter/supabase_flutter.dart' hide AuthResponse;`

### Issue: Circular import between layers
**Cause**: Infrastructure imports presentation or vice versa
**Solution**: Always depend upward (presentation → infrastructure → domain), never downward

### Issue: Models not serializing correctly
**Cause**: @JsonSerializable fields don't match JSON keys
**Solution**: Use `@JsonKey(name: 'db_field_name')` above fields

## Migration Checklist

- [x] Delete old `data/` folder (moved to infrastructure)
- [x] Update all imports to use infrastructure models/datasources
- [x] Verify build_runner regenerates .g.dart files
- [x] Test login/signup flow end-to-end
- [ ] Setup protected routes (auth guard in router)
- [ ] Add session persistence (already in auth_store)
- [ ] Deploy SQL schema to Supabase

---

**Last Updated**: March 3, 2026  
**Status**: Active - In use for auth feature  
**Next Iteration**: Protected routes + Social login (Google, Facebook)
