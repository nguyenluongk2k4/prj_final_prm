<!-- Architecture Quick Reference - Use this when you need quick patterns -->

# PRM Architecture Quick Reference

## When Implementing a Feature

### 1️⃣ Domain Layer (Business Logic)
```dart
// domain/entities/item.dart
@immutable
class Item {
  final String id;
  final String name;
  const Item({required this.id, required this.name});
}

// domain/repositories/item_repository.dart
abstract class ItemRepository {
  Future<Item> getItem(String id);
}
```

### 2️⃣ Infrastructure Layer (Data)
```dart
// infrastructure/datasources/item_datasource.dart
class ItemDatasource {
  Future<AuthResponse<ItemModel>> getItem(String id) async {
    try {
      final data = await _supabase.from('items').select().eq('id', id).single();
      return AuthResponse.success(ItemModel.fromJson(data));
    } catch (e) {
      return AuthResponse.failure(e.toString());
    }
  }
}

// infrastructure/models/item_model.dart
@JsonSerializable()
class ItemModel {
  @JsonKey(name: 'item_id')
  final String id;
  final String name;
  
  factory ItemModel.fromJson(Map<String, dynamic> json) => _$ItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$ItemModelToJson(this);
  ItemModel copyWith({String? id, String? name}) => ItemModel(
    id: id ?? this.id,
    name: name ?? this.name,
  );
}

// infrastructure/repositories/item_repository_impl.dart
class ItemRepositoryImpl implements ItemRepository {
  final ItemDatasource datasource;
  @override
  Future<Item> getItem(String id) async {
    final response = await datasource.getItem(id);
    if (response.success) {
      return Item(id: response.data!.id, name: response.data!.name);
    }
    throw Exception(response.errorMessage);
  }
}
```

### 3️⃣ Presentation Layer (UI + State)
```dart
// presentation/stores/item_store.dart
class ItemStore = _ItemStore with _$ItemStore;

abstract class _ItemStore with Store {
  final ItemDatasource datasource;
  
  @observable
  bool isLoading = false;
  
  @observable
  ItemModel? currentItem;
  
  @observable
  String? errorMessage;
  
  @action
  Future<void> fetchItem(String id) async {
    isLoading = true;
    final response = await datasource.getItem(id);
    if (response.success) {
      currentItem = response.data;
    } else {
      errorMessage = response.errorMessage;
    }
    isLoading = false;
  }
}

// presentation/pages/item_page.dart
class ItemPage extends StatefulWidget {
  const ItemPage({super.key});
  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late final _store = getIt<ItemStore>();
  
  @override
  void initState() {
    super.initState();
    _store.fetchItem('123');
  }
  
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (_store.isLoading) return LoadingWidget();
        if (_store.errorMessage != null) return Text(_store.errorMessage!);
        return Text(_store.currentItem?.name ?? 'No data');
      },
    );
  }
}

// core/di/item_module.dart
@module
abstract class ItemModule {
  @lazySingleton
  ItemDatasource itemDatasource(SupabaseClient client) 
    => ItemDatasource(client: client);
  
  @lazySingleton
  ItemStore itemStore(ItemDatasource datasource)
    => ItemStore(datasource: datasource);
}
```

## Common Patterns

### Getting Current User
```dart
final authStore = getIt<AuthStore>();
final user = authStore.currentUser;  // UserModel
```

### Navigation After Async Action
```dart
void _handleLogin() {
  runAsync(() async {
    await _authStore.login(email, password);
    if (_authStore.currentUser != null && mounted) {
      context.goNamed(AppRoutes.loginName);
    }
  });
}
```

### Error Handling
```dart
@action
Future<void> doSomething() async {
  try {
    final response = await datasource.doSomething();
    if (response.success) {
      // Update state
    } else {
      errorMessage = response.errorMessage;
    }
  } catch (e) {
    errorMessage = e.toString();
  }
}
```

### Adding i18n Keys
1. Edit `lib/i18n/strings.i18n.json` (English)
2. Edit `lib/i18n/strings_vi.i18n.json` (Vietnamese)
3. Run: `flutter pub run build_runner build --delete-conflicting-outputs`
4. Use: `Text(t.feature.key)`

## File Checklist for New Feature

```
lib/features/[feature]/
├── domain/
│   ├── entities/[name].dart
│   ├── repositories/[feature]_repository.dart
│   └── usecases/[action]_usecase.dart
├── infrastructure/
│   ├── datasources/
│   │   ├── datasources.dart (barrel)
│   │   └── [feature]_datasource.dart
│   ├── models/
│   │   ├── models.dart (barrel)
│   │   └── *_model.dart
│   └── repositories/
│       └── [feature]_repository_impl.dart
└── presentation/
    ├── pages/
    │   └── [feature]_page.dart
    ├── stores/
    │   └── [feature]_store.dart
    └── widgets/
        └── [widget]_widget.dart

lib/core/di/
└── [feature]_module.dart
```

## Debugging Quick Fixes

| Error | Fix |
|-------|-----|
| "getter 'X' not defined" | Run `flutter pub run build_runner build --delete-conflicting-outputs` |
| "No provider for X" | Check registration in `lib/core/di/injection.dart` |
| "Circular import" | Check: Presentation→Infrastructure→Domain (never reverse) |
| "Models not serializing" | Use `@JsonKey(name: 'db_field')` for all fields |
| App crashes on login | Add try-catch in datasource, ensure GetIt has Store |

## Before Committing

```bash
dart format lib
flutter analyze
flutter pub run build_runner build --delete-conflicting-outputs
flutter test
```
