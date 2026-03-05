import 'package:prj_final_prm/features/auth/infrastructure/models/user_model.dart';


abstract class DiscoverRepository {
  Future<List<UserModel>> getDiscoverProfiles({
    required int limit,
    required int offset,
  });

  Future<void> submitSwipe({
    required String swipedId,
    required bool isLike,
  });
}
