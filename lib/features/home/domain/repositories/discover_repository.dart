import 'package:prj_final_prm/features/auth/infrastructure/models/user_model.dart';
import '../entities/swipe_type.dart' as domain;
import '../entities/discover_filter.dart';

abstract class DiscoverRepository {
  Future<List<UserModel>> getDiscoverProfiles({
    required int limit,
    required int offset,
    DiscoverFilter? filter,
  });

  Future<void> submitSwipe({
    required String swipedId,
    required domain.SwipeType swipeType,
  });

  Future<void> undoSwipe({
    required String swipedId,
  });
}
