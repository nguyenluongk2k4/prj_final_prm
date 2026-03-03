# Quick Reference - Architecture Checklist

## When Creating a New Feature

### 1. Domain Layer Setup
- [ ] Create `lib/features/[feature]/domain/entities/` folder
- [ ] Create entity classes (pure Dart, no json_annotation)
- [ ] Create `lib/features/[feature]/domain/repositories/` folder
- [ ] Define abstract repository interface
- [ ] Create `lib/features/[feature]/domain/usecases/` folder
- [ ] Create use case classes (wrap repository calls)

### 2. Infrastructure Layer Setup
- [ ] Create `lib/features/[feature]/infrastructure/datasources/` folder
- [ ] Create datasource class wrapping external service (Supabase, API, Firebase)
- [ ] Add `datasources.dart` barrel export
- [ ] Create `lib/features/[feature]/infrastructure/models/` folder
- [ ] Add @JsonSerializable models (implement fromJson, toJson, copyWith)
- [ ] Add `models.dart` barrel export
- [ ] Create `lib/features/[feature]/infrastructure/repositories/` folder
- [ ] Implement abstract repository (inject datasource)

### 3. Presentation Layer Setup
- [ ] Create `lib/features/[feature]/presentation/stores/` folder
- [ ] Create MobX store class (extends with Store mixin)
- [ ] Define @observable properties (loading, errors, data)
- [ ] Add @action methods (modify state)
- [ ] Create `lib/features/[feature]/presentation/pages/` folder
- [ ] Create page widgets using Observer wrapper
- [ ] Add form validation and error handling
- [ ] Implement navigation on success/failure

### 4. Dependency Injection
- [ ] Add module in `lib/core/di/[feature]_module.dart`
- [ ] Register datasources (@lazySingleton)
- [ ] Register stores (@lazySingleton)
- [ ] Import module in `lib/core/di/injection.dart`
- [ ] Test GetIt injection: `final store = getIt<[Feature]Store>();`

### 5. Routing
- [ ] Add routes to `lib/core/router/app_routes.dart`
- [ ] Update router in `lib/core/router/app_router.dart`
- [ ] Add route names constant
- [ ] Test navigation: `context.goNamed(routeName)`

### 6. Internationalization (i18n)
- [ ] Add English keys to `lib/i18n/strings.i18n.json`
- [ ] Add Vietnamese keys to `lib/i18n/strings_vi.i18n.json`
- [ ] Run `flutter pub run build_runner build`
- [ ] Use in pages: `final t = Translations.of(context);`

### 7. Build & Test
- [ ] Run `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Check for compilation errors: `flutter analyze`
- [ ] Test manually on device/emulator
- [ ] Verify all screens are accessible

---

## Import Pattern Reference

### In Presentation Pages
```dart
// ✅ DO - Import from domain repositories
import 'package:prj_final_prm/features/auth/domain/repositories/auth_repository.dart';

// ✅ DO - Import store
import '../stores/auth_store.dart';

// ❌ DON'T - Direct import from infrastructure
import 'package:prj_final_prm/features/auth/infrastructure/datasources/auth_datasource.dart';
```

### In Stores
```dart
// ✅ DO - Inject datasource/repository
class AuthStore {
  final AuthDatasource authDatasource;
  AuthStore({required this.authDatasource});
}

// ❌ DON'T - Create Supabase client directly
class AuthStore {
  final _supabase = Supabase.instance.client;
}
```

### In Datasources
```dart
// ✅ DO - Wrap external calls
class AuthDatasource {
  Future<AuthResponse<UserModel>> login({...}) async {
    try {
      final result = await _supabaseClient.auth.signInWithPassword(...);
      return AuthResponse.success(UserModel.fromJson(...));
    } catch (e) {
      return AuthResponse.failure(e.toString());
    }
  }
}

// ❌ DON'T - Let exceptions propagate
class AuthDatasource {
  Future<UserModel> login({...}) async {
    return UserModel.fromJson(await _supabaseClient.auth.signInWithPassword(...));
  }
}
```

---

## State Management Pattern

### MobX Store Template
```dart
import 'package:mobx/mobx.dart';

part 'feature_store.g.dart';

class FeatureStore = _FeatureStore with _$FeatureStore;

abstract class _FeatureStore with Store {
  final FeatureDatasource datasource;

  _FeatureStore({required this.datasource});

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  String? successMessage;

  @computed
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  @action
  Future<void> fetchData() async {
    isLoading = true;
    errorMessage = null;
    
    try {
      final response = await datasource.getData();
      if (response.success) {
        successMessage = 'Success';
      } else {
        errorMessage = response.errorMessage;
      }
    } catch (e) {
      errorMessage = e.toString();
    }
    
    isLoading = false;
  }

  void clearMessages() {
    errorMessage = null;
    successMessage = null;
  }
}
```

### UI Observable Pattern
```dart
@override
Widget build(BuildContext context) {
  return Observer(
    builder: (_) {
      if (store.isLoading) return LoadingWidget();
      if (store.hasError) return ErrorWidget(message: store.errorMessage!);
      
      return SuccessWidget();
    },
  );
}
```

---

## Datasource Generic Response

**All datasource methods should return `AuthResponse<T>`**

```dart
class AuthResponse<T> {
  final bool success;
  final T? data;
  final String? errorMessage;

  AuthResponse({
    required this.success,
    this.data,
    this.errorMessage,
  });

  factory AuthResponse.success(T data) {
    return AuthResponse(success: true, data: data);
  }

  factory AuthResponse.failure(String message) {
    return AuthResponse(success: false, errorMessage: message);
  }
}
```

**Usage**:
```dart
// Success
AuthResponse.success(UserModel(...))

// Failure
AuthResponse.failure('Email already exists')

// In store
if (response.success) {
  currentUser = response.data;
} else {
  errorMessage = response.errorMessage;
}
```

---

## File Structure Validation

```bash
# Run this to verify clean architecture
find lib/features -name "*.dart" | grep -E "(datasource|service)" | head -20
# Should only show files in infrastructure/datasources/

find lib -name "*.dart" -exec grep -l "SupabaseClient\|http.Client" {} \;
# Should only show datasource files in infrastructure/

find lib/features -name "*.dart" -path "*/presentation/*" -exec grep -l "database\|firebase\|supabase" {} \;
# Should return NO matches - presentation should not import external services
```

---

## Version Control Checklist

### Before Commit
- [ ] Run `flutter pub run build_runner build`
- [ ] Run `flutter analyze` (no errors)
- [ ] Run `flutter test` (if tests exist)
- [ ] Check git diff for unnecessary changes

### New Feature Commit Message
```
feat: add [feature_name]

- Add domain layer (entities, repositories, usecases)
- Add infrastructure layer (datasources, models, repository impl)
- Add presentation layer (pages, stores)
- Add DI module for [feature_name]
- Add routes for [feature_name] pages

Closes #[issue_number]
```

---

## Common Pitfalls & Solutions

| Pitfall | Why It's Bad | Solution |
|---------|------------|----------|
| Calling Supabase from pages | Violates separation of concerns | Move logic to datasource |
| Multiple stores per feature | Hard to manage state | One store per feature |
| Hardcoded strings | Not internationalized | Use i18n keys |
| No error handling in datasource | App crashes on network error | Wrap in try-catch, return failure |
| Circular imports | Can't compile | Check dependency direction: presentation → infra → domain |
| Storing sensitive data in Store | User data exposed | Use secure storage for auth tokens |
| Not running build_runner | Generated files out of sync | Always run after model/store changes |
| Skipping validation | Invalid data sent to server | Validate in pages before store call |

---

**Maintainers**: Architecture Team  
**Last Updated**: March 3, 2026  
**Questions?**: Refer to AUTH_ARCHITECTURE.md for detailed explanations
