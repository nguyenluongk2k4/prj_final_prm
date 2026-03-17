import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Base class cho tất cả UseCase
/// [Type] - kiểu dữ liệu trả về
/// [Params] - tham số đầu vào
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

/// UseCase không cần params
class NoParams {
  const NoParams();
}
