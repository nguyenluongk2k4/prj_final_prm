# PRM Architecture System - Complete Overview

**Date**: March 17, 2026  
**Status**: 🟢 Complete & Integrated with Copilot  
**Documents**: All .agent files merged + new copilot-instructions

---

## 📊 Architecture Hierarchy

The PRM project uses a **three-layer Clean Architecture** with three source documents defining the system:

```
ARCHITECTURE_RULES.md
    ↓ (defines core principles)
    ├─→ Generic layer rules
    ├─→ Dependency injection rules
    ├─→ Code style standards
    └─→ Assessment criteria

AUTH_ARCHITECTURE.md
    ↓ (shows reference implementation)
    ├─→ Auth folder structure (golden standard)
    ├─→ All patterns implemented correctly
    ├─→ Data flow diagram
    └─→ Copy this for new features

FEATURE_CHECKLIST.md
    ↓ (quick execution guide)
    ├─→ Step-by-step checklist
    ├─→ Common pitfalls
    ├─→ Import patterns
    └─→ Validation scripts
```

---

## 🔄 Three-Layer Flow

```
┌─────────────────────────────────────────────────────────────────┐
│               PRESENTATION LAYER (UI & State)                   │
│  • Pages (StatefulWidget + GetIt injection)                     │
│  • Stores (MobX: @observable state, @action methods)            │
│  • Widgets (reusable UI components)                             │
│  ✅ Observer wrapper for reactivity                             │
│  ❌ NO Supabase calls, NO business logic in build()             │
└─────────────────────────────────────────────────────────────────┘
                              ↑
                   depends on (import from)
                              ↑
┌─────────────────────────────────────────────────────────────────┐
│           INFRASTRUCTURE LAYER (Data Integration)               │
│  • Datasources (Supabase/Firebase/API wrappers)                 │
│    - Try-catch exception handling                               │
│    - Return AuthResponse<T> wrapper                             │
│  • Models (@JsonSerializable with fromJson, toJson, copyWith)   │
│  • Repositories (implement domain interfaces)                   │
│    - Transform model→entity before returning                    │
│  ❌ NO direct UI imports, NO presentation logic                 │
└─────────────────────────────────────────────────────────────────┘
                              ↑
                   depends on (import from)
                              ↑
┌─────────────────────────────────────────────────────────────────┐
│          DOMAIN LAYER (Pure Business Logic)                     │
│  • Entities (pure Dart @immutable classes)                      │
│  • Repositories (abstract interfaces)                           │
│  • Usecases (business operations)                               │
│  ✅ NO external packages (except dartz), NO frameworks          │
│  ❌ NO @JsonSerializable, NO Supabase, NO UIs                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🏗️ Golden Standard: Auth Feature

The **auth feature** in `lib/features/auth/` is the reference implementation. All new features copy this structure:

### Domain Layer
```
domain/
├── entities/
│   ├── user.dart              # @immutable, const, pure data
│   └── user_profile.dart
├── repositories/
│   └── auth_repository.dart   # abstract class with Future<X> methods
└── usecases/
    ├── login_usecase.dart
    ├── logout_usecase.dart
    └── verify_otp_usecase.dart
```

### Infrastructure Layer
```
infrastructure/
├── datasources/
│   ├── datasources.dart       # Barrel export
│   └── auth_datasource.dart   # try-catch + AuthResponse<UserModel>
├── models/
│   ├── models.dart            # Barrel export
│   ├── user_model.dart        # @JsonSerializable
│   ├── auth_response.dart     # Generic wrapper
│   └── user_profile_model.dart
└── repositories/
    └── auth_repository_impl.dart  # Implements abstract, injects datasource
```

### Presentation Layer
```
presentation/
├── pages/
│   ├── login_page.dart        # Inject store, form, validation, navigation
│   ├── signup_page.dart
│   ├── verification_page.dart
│   └── ... (9 pages total)
└── stores/
    └── auth_store.dart        # @observable state, @action methods
```

---

## 🎯 Critical Rules (Non-Negotiable)

### 1. Dependency Injection
```dart
// ✅ CORRECT - GetIt injection
class _LoginPageState extends State<LoginPage> {
  late final _authStore = getIt<AuthStore>();
}

// ❌ WRONG - Direct instantiation
class _LoginPageState extends State<LoginPage> {
  final _authStore = AuthStore(datasource: ...);  // Creates hard dependency!
}
```

**Rule**: Never use `new` keyword. Always inject via GetIt.

### 2. Layer Dependencies
```
Presentation ──depends on──> Infrastructure ──depends on──> Domain
```

**Rule**: ONLY move right (Presentation→Infrastructure→Domain). Never move left!

```dart
// ✅ OK in Presentation
import '../stores/auth_store.dart';           // Same layer
import '../../domain/repositories/...';       // Depends on domain

// ❌ NEVER in Presentation
import '../../infrastructure/datasources/...';  // Skip infrastructure on import? No!
```

### 3. Observable State Requirements
```dart
class MyStore with Store {
  @observable
  bool isLoading = false;           // ✅ CORRECT
  bool isValid = false;             // ❌ WRONG - missing @observable

  @computed
  bool get hasError => error != null;  // ✅ Computed from observables
}
```

**Rule**: Mark ALL state properties with `@observable` or `@computed`.

### 4. Error Handling Pattern
```dart
// Datasource Level (catch & wrap)
Future<AuthResponse<UserModel>> login(...) async {
  try {
    final result = await _client.auth.signInWithPassword(...);
    return AuthResponse.success(UserModel.fromJson(...));
  } on AuthException catch (e) {
    return AuthResponse.failure('Auth: ${e.message}');
  } catch (e) {
    return AuthResponse.failure('Error: $e');
  }
}

// Store Level (handle response)
@action
Future<void> login(...) async {
  isLoading = true;
  final response = await datasource.login(...);
  if (response.success) {
    currentUser = response.data;
  } else {
    errorMessage = response.errorMessage;
  }
  isLoading = false;
}

// Page Level (display to user)
@override
Widget build(BuildContext context) {
  return Observer(
    builder: (_) {
      if (_store.errorMessage != null) {
        return ErrorBanner(_store.errorMessage!);
      }
      // ...
    },
  );
}
```

### 5. Build Runner After Changes
```bash
# ALWAYS run after modifying:
# - Store files (add/remove @observable/@action)
# - Model files (change @JsonSerializable structure)
# - Any .g.dart dependencies
flutter pub run build_runner build --delete-conflicting-outputs

# For active development
flutter pub run build_runner watch --delete-conflicting-outputs
```

---

## 📋 Feature Implementation Checklist

When creating a new feature `[feature_name]`:

### Phase 1: Domain Layer
- [ ] Create `lib/features/[feature_name]/domain/entities/` folder
- [ ] Create entity classes (@immutable, const constructors)
- [ ] Create `lib/features/[feature_name]/domain/repositories/` folder
- [ ] Define abstract repository interface(s)
- [ ] Create `lib/features/[feature_name]/domain/usecases/` folder
- [ ] Create use case classes wrapping repository calls

### Phase 2: Infrastructure Layer
- [ ] Create `lib/features/[feature_name]/infrastructure/datasources/` folder
- [ ] Create datasource class wrapping external service
- [ ] Add `datasources.dart` barrel export
- [ ] Create `lib/features/[feature_name]/infrastructure/models/` folder
- [ ] Add @JsonSerializable models with fromJson, toJson, copyWith, toDomain()
- [ ] Add `models.dart` barrel export
- [ ] Create `lib/features/[feature_name]/infrastructure/repositories/` folder
- [ ] Implement abstract repository (inject datasource, transform model→entity)

### Phase 3: Presentation Layer
- [ ] Create `lib/features/[feature_name]/presentation/stores/` folder
- [ ] Create MobX store (@observable properties, @action methods)
- [ ] Create `lib/features/[feature_name]/presentation/pages/` folder
- [ ] Create page widgets with Observer wrapper
- [ ] Add form validation to TextFormField
- [ ] Create `lib/features/[feature_name]/presentation/widgets/` folder (optional)
- [ ] Create reusable UI components

### Phase 4: Dependency Injection
- [ ] Add module in `lib/core/di/[feature_name]_module.dart`
- [ ] Register datasources (@lazySingleton)
- [ ] Register repositories (@lazySingleton)
- [ ] Register stores (@lazySingleton)
- [ ] Import module in `lib/core/di/injection.dart`

### Phase 5: Routing
- [ ] Add route to `lib/core/router/app_routes.dart`
- [ ] Define route name constant
- [ ] Add route builder in `lib/core/router/app_router.dart`

### Phase 6: Internationalization
- [ ] Add English keys to `lib/i18n/strings.i18n.json`
- [ ] Add Vietnamese keys to `lib/i18n/strings_vi.i18n.json`

### Phase 7: Code Generation & Verification
- [ ] Run `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Run `flutter analyze` (verify no errors)
- [ ] Run `flutter test` (if tests exist)
- [ ] Format code: `dart format lib`
- [ ] Manual testing on device/emulator

---

## 🔍 Validation Commands

```bash
# 1. Check for Supabase calls outside infrastructure layer
find lib/features -name "*.dart" -path "*/presentation/*" -exec grep -l "supabase\|.from(" {} \;
# Should return NO matches

# 2. Check for datasource files only in infrastructure
find lib/features -name "*datasource*.dart" | grep -v "infrastructure/datasources"
# Should return NO matches

# 3. Verify build runner was run
ls lib/**/*.g.dart | wc -l
# Should have multiple .g.dart files

# 4. Check GetIt usage
grep -r "= AuthStore(" lib/features
# Should return NO matches (all should use getIt<AuthStore>())
```

---

## 🚀 Build & Deploy Commands

### Development
```bash
flutter run                    # Run on connected device
flutter run -d chrome          # Run on web
flutter run --verbose          # Debug mode with logs
```

### Code Quality
```bash
flutter analyze                # Check lint violations
dart format lib                # Auto-format code
flutter test                   # Run unit tests
```

### Code Generation
```bash
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Clean & Fresh
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📚 External Services Architecture

| Service | Layer/Location | Pattern | Purpose |
|---------|---|---|---|
| **Supabase** | Infrastructure/datasources | AuthResponse<T> wrapper | Database, auth, realtime |
| **Firebase** | Infrastructure/repositories | Phone OTP integration | Phone authentication |
| **GoRouter** | Core/router | context.goNamed() | Navigation |
| **MobX** | Presentation/stores | @observable/@action/Observer | State management |
| **GetIt** | Core/di | @module/@lazySingleton | Dependency injection |
| **Slang** | i18n/ | t.feature.key | Internationalization (EN/VI) |
| **Mapbox** | [feature]/infrastructure | API wrapper | Mapping & location |
| **Tencent** | [feature]/infrastructure | SDK integration | Chat/messaging |
| **Agora** | [feature]/infrastructure | SDK integration | Video calling |

---

## ⚠️ Common Issues & Fixes

| Issue | Root Cause | Fix |
|-------|-----------|-----|
| "getter 'X' not defined" | Generated .g.dart files out of sync | Run `flutter pub run build_runner build` |
| "No provider for AuthStore" | Store not registered in GetIt | Check `lib/core/di/injection.dart` |
| "Circular import" | Infrastructure imports Presentation | Verify dependency direction: P→I→D |
| App crashes on Supabase call | Call from page instead of datasource | Move logic to datasource, wrap in AuthResponse |
| "Multiple stores" | Feature has 2+ stores | Keep ONE store per feature, use @computed for derived state |
| Race condition on navigation | Navigating before async completes | Use `runAsync()` to wait for store action |
| Models won't serialize | @JsonKey names don't match DB | Use `@JsonKey(name: 'db_column')` on all fields |

---

## 📖 Document Cross-Reference

| Question | Reference |
|----------|-----------|
| "How do I structure a new feature?" | FEATURE_CHECKLIST.md |
| "What are the layer rules?" | ARCHITECTURE_RULES.md |
| "Show me a complete example" | AUTH_ARCHITECTURE.md |
| "What's the MobX pattern?" | FEATURE_CHECKLIST.md + ARCHITECTURE_RULES.md |
| "How do I use dependency injection?" | ARCHITECTURE_RULES.md (Core Principles section) |
| "Where does error handling happen?" | ARCHITECTURE_RULES.md (Error Handling section) |
| "What are the naming conventions?" | copilot-instructions.md |

---

## 🎓 Learning Path

1. **Start here**: Read ARCHITECTURE_RULES.md (understand core principles)
2. **See example**: Study AUTH_ARCHITECTURE.md (auth feature is the template)
3. **Apply**: Follow FEATURE_CHECKLIST.md (create your new feature)
4. **Copy auth pattern**: Use auth as a template for structure
5. **Validate**: Run the validation commands above
6. **Ask Copilot**: Reference any section from copilot-instructions.md

---

## ✅ Integration Status

All architecture documents are now:
- ✅ Integrated into `.github/copilot-instructions.md` (Copilot context)
- ✅ Available in `.agent/` folder (reference)
- ✅ Unified in repository memory
- ✅ Accessible for new AI sessions

**Next steps**:
1. Use FEATURE_CHECKLIST.md for next feature
2. Reference AUTH_ARCHITECTURE.md as template
3. Follow ARCHITECTURE_RULES.md for layer compliance
4. Ask Copilot to implement following these patterns

---

**Last Reviewed**: March 17, 2026  
**Architecture Status**: 🟢 Complete & Documented  
**Enforcement**: Code review - all PRs must follow these rules
