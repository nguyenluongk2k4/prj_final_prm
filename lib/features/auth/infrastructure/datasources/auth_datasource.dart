import 'package:supabase_flutter/supabase_flutter.dart' hide AuthResponse;
import '../models/models.dart';

class AuthDatasource {
  final SupabaseClient _supabaseClient;

  AuthDatasource({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  SupabaseClient get client => _supabaseClient;

  /// Lấy user hiện tại từ bảng users
  Future<UserModel?> getCurrentUser() async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await _supabaseClient
          .from('users')
          .select(
              'id, email, name, phone, avatar_url, gender, target_gender, bio, birth_date, location, is_online, last_active, created_at, updated_at, user_preferences(preference_id)')
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;

      final preferences = (response['user_preferences'] as List?)
              ?.map((p) => p['preference_id'] as String)
              .toList() ??
          [];

      return UserModel(
        id: response['id'],
        email: response['email'],
        name: response['name'],
        phone: response['phone'],
        avatarUrl: response['avatar_url'],
        gender: response['gender'],
        targetGender: response['target_gender'],
        bio: response['bio'],
        birthDate: response['birth_date'] != null
            ? DateTime.parse(response['birth_date'])
            : null,
        location: response['location'],
        isOnline: response['is_online'] ?? false,
        lastActive: response['last_active'] != null
            ? DateTime.parse(response['last_active'])
            : null,
        preferences: preferences,
        createdAt: response['created_at'] != null
            ? DateTime.parse(response['created_at'])
            : null,
        updatedAt: response['updated_at'] != null
            ? DateTime.parse(response['updated_at'])
            : null,
      );
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
    required List<String>? preferences,
    required String? location,
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

      // 2. Tạo record trong bảng users
      await _supabaseClient.from('users').insert({
        'id': userId,
        'email': email,
        'name': name,
        'phone': phone,
        'location': location,
        'is_online': false,
      });

      // 3. Tạo profile
      await _supabaseClient.from('profiles').insert({
        'user_id': userId,
        'display_name': name,
      });

      // 4. Thêm preferences nếu có
      if (preferences != null && preferences.isNotEmpty) {
        final preferencesData = preferences.map((prefId) => {
              'user_id': userId,
              'preference_id': prefId,
            }).toList();

        await _supabaseClient.from('user_preferences').insert(preferencesData);
      }

      // 5. Fetch và return user
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

  /// Lấy danh sách tất cả preferences từ DB
  Future<List<Map<String, dynamic>>> getPreferences() async {
    try {
      final response = await _supabaseClient.from('preferences').select('*');
      return response as List<Map<String, dynamic>>;
    } catch (e) {
      rethrow;
    }
  }
}
