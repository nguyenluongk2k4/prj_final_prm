# DDD Architecture Guide

## Cấu trúc dự án

```
lib/
├── core/                           # Shared code across features
│   ├── constants/                  # App-wide constants
│   ├── errors/                     # Error handling
│   ├── network/                    # Network configuration
│   ├── usecases/                   # Base UseCase
│   └── di/                         # Dependency Injection
│
├── features/                       # Feature modules
│   └── [feature_name]/
│       ├── domain/                 # Business Logic Layer
│       │   ├── entities/           # Business objects
│       │   ├── repositories/       # Abstract repositories
│       │   └── usecases/           # Business use cases
│       │
│       ├── data/                   # Data Layer
│       │   ├── models/             # Data models (extends entities)
│       │   ├── datasources/        # Remote & Local data sources
│       │   └── repositories/       # Repository implementations
│       │
│       └── presentation/           # Presentation Layer
│           ├── mobx/               # MobX stores
│           ├── pages/              # UI screens
│           └── widgets/            # Reusable widgets
│
└── main.dart                       # App entry point
```

## Dependency Flow

```
Presentation → Domain ← Data
     ↓            ↓        ↓
   MobX      UseCase   Repository
   Store       ↓            ↓
     ↓      Entity    DataSource
   Widget              (API/DB)
```

## Các bước phát triển tính năng mới

### 1. Domain Layer (Business Logic)
- Tạo **Entity** trong `domain/entities/`
- Định nghĩa **Repository interface** trong `domain/repositories/`
- Tạo **UseCase** trong `domain/usecases/`

### 2. Data Layer (Implementation)
- Tạo **Model** (extends Entity) trong `data/models/`
- Implement **DataSource** trong `data/datasources/`
- Implement **Repository** trong `data/repositories/`

### 3. Presentation Layer (UI)
- Tạo **MobX Store** trong `presentation/mobx/`
- Tạo **Page** trong `presentation/pages/`
- Tạo **Widget** trong `presentation/widgets/`

## Chạy Code Generation

```bash
# Generate một lần
dart run build_runner build --delete-conflicting-outputs

# Watch mode (tự động generate khi save)
dart run build_runner watch --delete-conflicting-outputs
```

## Injectable Annotations

- `@injectable` - Đăng ký class với DI
- `@lazySingleton` - Singleton, khởi tạo khi cần
- `@singleton` - Singleton, khởi tạo ngay

## MobX Annotations

- `@observable` - Biến có thể observe
- `@action` - Method thay đổi state
- `@computed` - Giá trị tính toán từ observables

## Example: Tạo feature mới (Product)

```dart
// 1. Entity
class Product extends Equatable {
  final String id;
  final String name;
  // ...
}

// 2. Repository Interface
abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
}

// 3. UseCase
class GetProductsUseCase implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;
  // ...
}

// 4. Model
class ProductModel extends Product {
  factory ProductModel.fromJson(Map<String, dynamic> json) => ...;
}

// 5. DataSource
class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts() async => ...;
}

// 6. Repository Implementation
class ProductRepositoryImpl implements ProductRepository {
  // ...
}

// 7. MobX Store
class ProductStore = _ProductStore with _$ProductStore;

// 8. UI Page
class ProductListPage extends StatelessWidget {
  // ...
}
```

## Notes

- Domain layer **KHÔNG** phụ thuộc vào framework
- Data layer implement các interface từ domain
- Presentation layer chỉ gọi UseCase, không trực tiếp gọi Repository
- MobX Store quản lý state và business logic của UI
- Repository pattern đảm bảo single source of truth
