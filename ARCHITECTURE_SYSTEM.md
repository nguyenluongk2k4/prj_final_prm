# PRM Architecture System - Document Map

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│                     PRM CLEAN ARCHITECTURE SYSTEM                          │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────────┐
│ .AGENT FOLDER (Reference Standards)                                         │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │ ARCHITECTURE_RULES.md                                               │  │
│  ├──────────────────────────────────────────────────────────────────────┤  │
│  │ • Core Architecture Principles (3-layer)                            │  │
│  │ • Single Responsibility Principle                                   │  │
│  │ • Dependency Injection Rule (CRITICAL)                             │  │
│  │ • Domain Layer Rules (pure logic)                                  │  │
│  │ • Infrastructure Layer Rules (data integration)                    │  │
│  │ • Presentation Layer Rules (UI & state)                           │  │
│  │ • Code Style (naming, imports, widgets)                           │  │
│  │ • Async/Await Rules (no .then() chains)                           │  │
│  │ • Error Handling Strategy (3-level)                               │  │
│  │ • Testing Rules                                                    │  │
│  │ • Database Schema Rules                                            │  │
│  │ • Build & Deployment                                               │  │
│  │ • Maintenance & Migrations                                         │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                              ↓ (Principles)                                  │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │ AUTH_ARCHITECTURE.md                                                │  │
│  ├──────────────────────────────────────────────────────────────────────┤  │
│  │ • GOLDEN STANDARD - Reference Implementation                        │  │
│  │ • Auth Feature Folder Structure (complete example)                 │  │
│  │ • Layer Responsibilities (with code examples)                      │  │
│  │ • Dependency Injection Pattern (auth_module.dart)                 │  │
│  │ • Data Flow Diagram                                                │  │
│  │ • Authentication Flow (step-by-step)                               │  │
│  │ • Key Design Decisions                                             │  │
│  │ • Important Rules for Consistency                                  │  │
│  │ • Extending Pattern to Other Features                              │  │
│  │ • Testing Strategy                                                 │  │
│  │ • File Naming Conventions                                          │  │
│  │ • Common Issues & Solutions                                        │  │
│  │ • Migration Checklist                                              │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                              ↓ (Template)                                    │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │ FEATURE_CHECKLIST.md                                                │  │
│  ├──────────────────────────────────────────────────────────────────────┤  │
│  │ • When Creating a New Feature (7-phase checklist)                  │  │
│  │ • Phase 1: Domain Layer Setup ✓ checklist                         │  │
│  │ • Phase 2: Infrastructure Layer Setup ✓ checklist                 │  │
│  │ • Phase 3: Presentation Layer Setup ✓ checklist                   │  │
│  │ • Phase 4: Dependency Injection ✓ checklist                       │  │
│  │ • Phase 5: Routing ✓ checklist                                    │  │
│  │ • Phase 6: Internationalization ✓ checklist                       │  │
│  │ • Phase 7: Build & Test ✓ checklist                               │  │
│  │ • Import Pattern Reference                                         │  │
│  │ • State Management Pattern (MobX template)                         │  │
│  │ • Datasource Generic Response (AuthResponse<T>)                    │  │
│  │ • File Structure Validation (bash commands)                        │  │
│  │ • Version Control Checklist                                        │  │
│  │ • Common Pitfalls & Solutions (8 issues)                           │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
                                        ↓
                           (Merged & Enhanced)
                                        ↓
┌──────────────────────────────────────────────────────────────────────────────┐
│ .GITHUB FOLDER (AI Context)                                                 │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │ copilot-instructions.md (400+ lines)                                │  │
│  ├──────────────────────────────────────────────────────────────────────┤  │
│  │ • All principles from ARCHITECTURE_RULES.md                        │  │
│  │ • All patterns from AUTH_ARCHITECTURE.md                          │  │
│  │ • All checklists from FEATURE_CHECKLIST.md                        │  │
│  │ • Additional practical examples                                    │  │
│  │ • Common questions & answers                                       │  │
│  │ • References & documentation links                                 │  │
│  │ • Development workflow                                             │  │
│  │ • Performance tips                                                 │  │
│  │ → LOADED INTO COPILOT CONTEXT AUTOMATICALLY                       │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
                                        ↓
┌──────────────────────────────────────────────────────────────────────────────┐
│ PROJECT ROOT (Developer References)                                         │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │ ARCHITECTURE_OVERVIEW.md (this file)                                │  │
│  ├──────────────────────────────────────────────────────────────────────┤  │
│  │ • Complete unified architecture overview                            │  │
│  │ • How the three-layer flow works                                   │  │
│  │ • Golden standard (Auth feature reference)                         │  │
│  │ • Critical non-negotiable rules (5)                                │  │
│  │ • Full feature implementation checklist (7 phases)                 │  │
│  │ • Validation commands (bash scripts)                               │  │
│  │ • Build & deploy commands                                          │  │
│  │ • External services matrix                                         │  │
│  │ • Common issues & fixes                                            │  │
│  │ • Document cross-reference                                         │  │
│  │ • Learning path                                                    │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │ QUICK_REFERENCE.md                                                 │  │
│  ├──────────────────────────────────────────────────────────────────────┤  │
│  │ • Quick copy-paste patterns for each layer                         │  │
│  │ • Feature implementation template                                  │  │
│  │ • Common patterns (navigation, errors, i18n)                       │  │
│  │ • File checklist for new features                                  │  │
│  │ • Debugging quick fixes table                                      │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘


KEY RELATIONSHIPS:
══════════════════════════════════════════════════════════════════════════════

ARCHITECTURE_RULES.md ←─────────── (defines core principles)
         ↓
    Applies to all features

AUTH_ARCHITECTURE.md ←────────── (demonstrates rules via example)
         ↓
    Use as template for new features

FEATURE_CHECKLIST.md ←────────── (step-by-step implementation guide)
         ↓
    Execute each phase in order

         ↓ (All integrated into)

copilot-instructions.md ←──────── (Copilot loads automatically)
         ↓
    Copilot follows patterns for code generation
    Copilot suggests fixes based on these rules
    Copilot validates pull requests


WHEN IMPLEMENTING A NEW FEATURE:
══════════════════════════════════════════════════════════════════════════════

1. READ: ARCHITECTURE_RULES.md
   → Understand layer responsibilities
   → Review dependency injection rules
   → Study code style conventions

2. STUDY: AUTH_ARCHITECTURE.md
   → See full auth folder structure
   → Review domain/infrastructure/presentation patterns
   → Copy the structure as template

3. FOLLOW: FEATURE_CHECKLIST.md
   → Phase 1: Create domain layer
   → Phase 2: Create infrastructure layer
   → Phase 3: Create presentation layer
   → Phase 4: Setup dependency injection
   → Phase 5: Add routes
   → Phase 6: Add i18n keys
   → Phase 7: Run build_runner + tests

4. REFER: QUICK_REFERENCE.md
   → Copy code patterns
   → Use checklist to verify completeness

5. VALIDATE: Run validation commands
   → No Supabase calls in presentation
   → No direct instantiation (all GetIt)
   → No circular imports
   → MobX @observable on all state


FILE STRUCTURE AFTER FEATURE CREATION:
══════════════════════════════════════════════════════════════════════════════

lib/features/[feature]/
├── domain/
│   ├── entities/
│   │   └── *.dart                    # Pure Dart @immutable classes
│   ├── repositories/
│   │   └── [feature]_repository.dart # Abstract interface only
│   └── usecases/
│       └── *.dart                    # Business operations
├── infrastructure/
│   ├── datasources/
│   │   ├── datasources.dart          # Barrel export
│   │   └── [feature]_datasource.dart # try-catch + AuthResponse<T>
│   ├── models/
│   │   ├── models.dart               # Barrel export
│   │   └── *_model.dart              # @JsonSerializable + fromJson + toJson + copyWith
│   └── repositories/
│       └── [feature]_repository_impl.dart  # Implements abstract, injects datasource
└── presentation/
    ├── stores/
    │   └── [feature]_store.dart      # MobX: @observable/@action/Observer
    ├── pages/
    │   └── [feature]_page.dart       # GetIt inject, Observer wrapper
    └── widgets/
        └── [widget]_widget.dart      # Reusable components (optional)

lib/core/di/
├── injection.dart                    # All imports of feature modules
└── [feature]_module.dart             # @module with @lazySingleton registrations

lib/core/router/
├── app_routes.dart                   # Route name constants
└── app_router.dart                   # GoRoute definitions


CRITICAL RULES (MUST MEMORIZE):
══════════════════════════════════════════════════════════════════════════════

1. ❌ NEVER use `new` keyword
   ✅ ALWAYS use `getIt<StoreName>()`

2. ❌ NEVER import infrastructure in presentation
   ✅ ALWAYS import from domain or same layer

3. ❌ NEVER skip @observable on Store properties
   ✅ ALWAYS mark observable state

4. ❌ NEVER let Supabase exceptions reach UI
   ✅ ALWAYS wrap in try-catch + AuthResponse<T>

5. ❌ NEVER skip build_runner after model/store changes
   ✅ ALWAYS run: flutter pub run build_runner build --delete-conflicting-outputs


COPILOT CAPABILITIES:
══════════════════════════════════════════════════════════════════════════════

With these instructions, Copilot can now:

✅ Generate new features following the architecture
✅ Create domain layers with correct principles
✅ Create infrastructure layers with error handling
✅ Create presentation layers with MobX patterns
✅ Setup dependency injection correctly
✅ Suggest fixes for common issues
✅ Review code for architecture compliance
✅ Explain layer responsibilities
✅ Generate checklists for feature implementation
✅ Validate import organization and dependencies


NEXT STEPS:
══════════════════════════════════════════════════════════════════════════════

1. Read through ARCHITECTURE_OVERVIEW.md (this file)
2. Keep QUICK_REFERENCE.md handy for copy-paste patterns
3. Reference AUTH_ARCHITECTURE.md when creating new features
4. Follow FEATURE_CHECKLIST.md for step-by-step execution
5. Ask Copilot to generate features following the patterns
6. Use validation commands to ensure compliance
7. Submit to code review with confidence

Status: ✅ All systems integrated and ready for development
```

---

## Document Summary Table

| Document | Size | Purpose | Audience | When to Use |
|----------|------|---------|-----------|------------|
| **ARCHITECTURE_RULES.md** | ~10KB | Principles & standards | Architects, senior devs | Understanding core rules |
| **AUTH_ARCHITECTURE.md** | ~12KB | Reference implementation | All developers | Creating new features (copy structure) |
| **FEATURE_CHECKLIST.md** | ~15KB | Step-by-step execution | All developers | Implementing new feature |
| **copilot-instructions.md** | ~30KB | AI context | Copilot + developers | Using Copilot, onboarding |
| **QUICK_REFERENCE.md** | ~8KB | Copy-paste patterns | All developers | Quick code patterns |
| **ARCHITECTURE_OVERVIEW.md** | ~20KB | Unified overview | All developers | Understanding system |

---

**Integration Complete**: ✅ All architecture knowledge is now accessible to AI and developers
