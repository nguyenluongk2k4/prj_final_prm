import 'package:supabase_flutter/supabase_flutter.dart' hide AuthResponse;
import '../models/models.dart';

class AuthDatasource {
  final SupabaseClient _supabaseClient;

  AuthDatasource({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  SupabaseClient get client => _supabaseClient;

  /// Lấy user hiện tại từ bảng users + profiles
  Future<UserModel?> getCurrentUser({String? userId}) async {
    try {
      final id = userId ?? _supabaseClient.auth.currentUser?.id;
      if (id == null) return null;

      // 1. Fetch user data
      final userResponse = await _supabaseClient
          .from('users')
          .select('id, email, name, phone, avatar_url, created_at, updated_at')
          .eq('id', id)
          .maybeSingle();

      if (userResponse == null) return null;

      // 2. Fetch profile data separately
      final profileResponse = await _supabaseClient
          .from('profiles')
          .select(
            'gender, target_gender, bio, birth_date, latitude, longitude, province_id, is_online, last_active',
          )
          .eq('user_id', id)
          .maybeSingle();

      // 3. Fetch preferences separately
      final preferencesResponse = await _supabaseClient
          .from('user_preferences')
          .select('preference_id')
          .eq('user_id', id);

      final preferences = (preferencesResponse as List)
          .map((p) => p['preference_id'] as String)
          .toList();

      // Merge tất cả data → fromJson (fieldRename.snake tự map snake_case → camelCase)
      final merged = {
        ...userResponse,
        ...(profileResponse ?? {}),
        'preferences': preferences,
      };

      return UserModel.fromJson(merged);
    } catch (e) {
      rethrow;
    }
  }

  /// Đăng nhập với email và password
  Future<AuthResponse<UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return AuthResponse.failure('Không thể đăng nhập');
      }

      final user = await getCurrentUser();
      if (user == null) {
        return AuthResponse.failure('Không tìm thấy thông tin người dùng');
      }

      return AuthResponse.success(user);
    } on AuthException catch (e) {
      return AuthResponse.failure(e.message);
    } catch (e) {
      return AuthResponse.failure('Error: ${e.toString()}');
    }
  }

  /// Đăng ký tài khoản mới
  Future<AuthResponse<UserModel>> signup({
    required String email,
    required String password,
    required String name,
    required String? phone,
    required double? latitude,
    required double? longitude,
    required List<String>? preferences,
  }) async {
    try {
      // 1. Tạo tài khoản auth
      final authResponse = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        return AuthResponse.failure('Không thể tạo tài khoản');
      }

      final userId = authResponse.user!.id;

      // Wait for auth user to be synced to database
      await Future.delayed(const Duration(milliseconds: 1500));

      // 2. Tạo record trong bảng users
      const defaultAvatarUrl =
          'https://res.cloudinary.com/djmftornv/image/upload/v1772683330/wngnvdvo7buy25qzfwet.jpg';
      await _supabaseClient.from('users').insert({
        'id': userId,
        'email': email,
        'name': name,
        'phone': phone,
        'avatar_url': defaultAvatarUrl,
      });

      // 3. Tạo profile
      await _supabaseClient.from('profiles').insert({
        'user_id': userId,
        'display_name': name,
        'avatar_url': defaultAvatarUrl,
        'latitude': latitude,
        'longitude': longitude,
        'is_online': false,
        'last_active': DateTime.now().toIso8601String(),
      });

      // 4. Thêm preferences nếu có
      if (preferences != null && preferences.isNotEmpty) {
        final preferencesData = preferences
            .map((prefId) => {'user_id': userId, 'preference_id': prefId})
            .toList();

        await _supabaseClient.from('user_preferences').insert(preferencesData);
      }

      // 5. Build UserModel từ data đã insert (tránh RLS block khi session chưa set)
      final now = DateTime.now().toIso8601String();
      final user = UserModel.fromJson({
        'id': userId,
        'email': email,
        'name': name,
        'phone': phone,
        'avatar_url': defaultAvatarUrl,
        'gender': null,
        'target_gender': null,
        'bio': null,
        'birth_date': null,
        'latitude': latitude,
        'longitude': longitude,
        'province_id': null,
        'is_online': false,
        'last_active': now,
        'preferences': preferences ?? [],
        'created_at': now,
        'updated_at': now,
      });

      return AuthResponse.success(user);
    } on AuthException catch (e) {
      return AuthResponse.failure(e.message);
    } catch (e) {
      return AuthResponse.failure('Error: ${e.toString()}');
    }
  }

  /// Cập nhật thông tin profile
  Future<AuthResponse<UserModel>> updateProfile({
    required String name,
    required String phone,
    required String bio,
    required DateTime? birthDate,
    required String? gender,
    required String? targetGender,
    required int? provinceId,
  }) async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        return AuthResponse.failure('Chưa đăng nhập');
      }

      final now = DateTime.now().toIso8601String();

      // Update users table
      await _supabaseClient
          .from('users')
          .update({'name': name, 'phone': phone, 'updated_at': now})
          .eq('id', userId);

      // Update profiles table
      await _supabaseClient
          .from('profiles')
          .update({
            'display_name': name,
            'bio': bio,
            'gender': gender,
            'target_gender': targetGender,
            'birth_date': birthDate?.toIso8601String(),
            'province_id': provinceId,
            'updated_at': now,
          })
          .eq('user_id', userId);

      final user = await getCurrentUser(userId: userId);
      if (user == null) {
        return AuthResponse.failure('Lỗi khi lấy thông tin sau khi cập nhật');
      }

      return AuthResponse.success(user);
    } catch (e) {
      return AuthResponse.failure('Error: ${e.toString()}');
    }
  }

  /// Cập nhật Bio và Province ở bước Onboarding cuối
  Future<AuthResponse<UserModel>> updateBioAndProvince({
    required String bio,
    required int provinceId,
  }) async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        return AuthResponse.failure('Chưa đăng nhập');
      }

      await _supabaseClient
          .from('profiles')
          .update({
            'bio': bio,
            'province_id': provinceId,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId);

      final user = await getCurrentUser(userId: userId);
      if (user == null) {
        return AuthResponse.failure('Lỗi khi lấy thông tin sau khi cập nhật');
      }

      return AuthResponse.success(user);
    } catch (e) {
      return AuthResponse.failure('Error: ${e.toString()}');
    }
  }

  /// Cập nhật ảnh đại diện
  Future<AuthResponse<UserModel>> updateAvatar(String avatarUrl) async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        return AuthResponse.failure('Chưa đăng nhập');
      }

      final now = DateTime.now().toIso8601String();

      // 1. Update users table
      await _supabaseClient
          .from('users')
          .update({'avatar_url': avatarUrl, 'updated_at': now})
          .eq('id', userId);

      // 2. Update profiles table
      await _supabaseClient
          .from('profiles')
          .update({'avatar_url': avatarUrl, 'updated_at': now})
          .eq('user_id', userId);

      final user = await getCurrentUser(userId: userId);
      if (user == null) {
        return AuthResponse.failure(
          'Lỗi khi lấy thông tin sau khi cập nhật ảnh',
        );
      }

      return AuthResponse.success(user);
    } catch (e) {
      return AuthResponse.failure('Error: ${e.toString()}');
    }
  }

  /// Cập nhật toạ độ Location
  Future<AuthResponse<UserModel>> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        return AuthResponse.failure('Chưa đăng nhập');
      }

      await _supabaseClient
          .from('profiles')
          .update({
            'latitude': latitude,
            'longitude': longitude,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId);

      final user = await getCurrentUser(userId: userId);
      if (user == null) {
        return AuthResponse.failure('Lỗi update location');
      }

      return AuthResponse.success(user);
    } catch (e) {
      return AuthResponse.failure('Error: ${e.toString()}');
    }
  }

  /// Đăng nhập bằng Google (OAuth qua Supabase)
  Future<AuthResponse<UserModel>> signInWithGoogle() async {
    try {
      final res = await _supabaseClient.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'myapp://login-callback',
      );

      if (!res) {
        return AuthResponse.failure('Không thể mở trang đăng nhập Google');
      }

      // OAuth flow opens browser → redirect back → auth listener picks up session
      // Wait briefly for auth state to propagate
      await Future.delayed(const Duration(seconds: 2));

      final user = await getCurrentUser();
      if (user != null) {
        return AuthResponse.success(user);
      }

      // User will be resolved via auth state listener
      return AuthResponse.failure('pending_oauth');
    } on AuthException catch (e) {
      return AuthResponse.failure(e.message);
    } catch (e) {
      return AuthResponse.failure('Error: ${e.toString()}');
    }
  }

  /// Xử lý callback sau khi OAuth redirect về app
  Future<AuthResponse<UserModel>> handleOAuthCallback() async {
    try {
      final session = _supabaseClient.auth.currentSession;
      if (session == null) {
        return AuthResponse.failure('Không có session sau OAuth');
      }

      final userId = session.user.id;
      final email = session.user.email ?? '';
      final name = session.user.userMetadata?['full_name'] ?? 
                   session.user.userMetadata?['name'] ?? '';
      final avatarUrl = session.user.userMetadata?['avatar_url'] ?? 
                        session.user.userMetadata?['picture'];

      // Check nếu user đã tồn tại trong bảng users
      var user = await getCurrentUser(userId: userId);

      if (user == null) {
        // User mới từ Google → tạo record
        const defaultAvatarUrl =
            'https://res.cloudinary.com/djmftornv/image/upload/v1772683330/wngnvdvo7buy25qzfwet.jpg';
        final finalAvatar = (avatarUrl != null && avatarUrl.toString().isNotEmpty)
            ? avatarUrl.toString()
            : defaultAvatarUrl;

        await _supabaseClient.from('users').insert({
          'id': userId,
          'email': email,
          'name': name,
          'avatar_url': finalAvatar,
        });

        await _supabaseClient.from('profiles').insert({
          'user_id': userId,
          'display_name': name,
          'avatar_url': finalAvatar,
          'is_online': false,
          'last_active': DateTime.now().toIso8601String(),
        });

        user = await getCurrentUser(userId: userId);
      }

      if (user == null) {
        return AuthResponse.failure('Lỗi khi lấy thông tin người dùng sau OAuth');
      }

      return AuthResponse.success(user);
    } catch (e) {
      return AuthResponse.failure('Error: ${e.toString()}');
    }
  }

  /// Đăng xuất
  Future<void> logout() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// Kiểm tra xem có session hay không
  bool isAuthenticated() {
    return _supabaseClient.auth.currentSession != null;
  }

  /// Lấy session hiện tại
  Session? getCurrentSession() {
    return _supabaseClient.auth.currentSession;
  }

  /// Stream theo dõi thay đổi auth state
  Stream<AuthState> get authStateChanges {
    return _supabaseClient.auth.onAuthStateChange;
  }

  /// Lưu preferences cho user hiện tại (xóa cũ, insert mới)
  Future<void> savePreferences(List<String> preferences) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) throw Exception('Chưa đăng nhập');

    // Xóa preferences cũ
    await _supabaseClient
        .from('user_preferences')
        .delete()
        .eq('user_id', userId);

    // Insert preferences mới nếu có
    if (preferences.isNotEmpty) {
      final data = preferences
          .map((prefId) => {'user_id': userId, 'preference_id': prefId})
          .toList();
      await _supabaseClient.from('user_preferences').insert(data);
    }
  }

  /// Lấy danh sách tất cả preferences từ DB
  Future<List<Map<String, dynamic>>> getPreferences() async {
    try {
      final response = await _supabaseClient.from('preferences').select('*');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Lấy danh sách tất cả tỉnh thành từ DB
  Future<List<ProvinceModel>> getProvinces() async {
    try {
      final response = await _supabaseClient
          .from('provinces')
          .select('*')
          .order('name');
      return (response as List)
          .map((p) => ProvinceModel.fromJson(p as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
