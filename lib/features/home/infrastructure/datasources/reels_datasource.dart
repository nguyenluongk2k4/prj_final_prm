import 'dart:io';
import 'package:prj_final_prm/core/services/image_upload_service.dart';
import 'package:prj_final_prm/features/home/domain/entities/reel_comment.dart';
import 'package:prj_final_prm/features/home/domain/entities/music.dart';
import '../../domain/entities/reel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';


@injectable
class ReelsDatasource {
  final SupabaseClient _supabaseClient;
  final ImageUploadService _imageUploadService;

  ReelsDatasource(this._supabaseClient, this._imageUploadService);

  /// Supabase trả về snake_case, nhưng Freezed generated code expect camelCase.
  /// Helper này chuyển đổi trước khi gọi Reel.fromJson().
  Map<String, dynamic> _mapReelJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    return {
      'id': json['id'],
      'authorId': json['author_id'],
      'videoUrl': json['video_url'] ?? '',
      'imageUrl': json['image_url'],
      'mediaType': json['media_type'] ?? (json['image_url'] != null ? 'image' : 'video'),
      'audioUrl': json['audio_url'],
      'thumbnailUrl': json['thumbnail_url'],
      'description': json['description'],
      'likesCount': (json['likes_count'] as num?)?.toInt() ?? 0,
      'commentsCount': (json['comments_count'] as num?)?.toInt() ?? 0,
      'createdAt': json['created_at'],
      'isLikedByMe': false, // will be overridden by caller
      if (author != null)
        'author': {
          'id': author['id'],
          'displayName': author['displayName'], // already aliased via displayName:name in select
          'avatarUrl': author['avatar_url'],
        },
    };
  }

  /// Supabase trả về snake_case cho ReelComment cũng vậy.
  Map<String, dynamic> _mapCommentJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    return {
      'id': json['id'],
      'reelId': json['reel_id'],
      'userId': json['user_id'],
      'content': json['content'],
      'createdAt': json['created_at'],
      'parentId': json['parent_id'],
      if (user != null)
        'user': {
          'id': user['id'],
          'displayName': user['displayName'], // aliased via displayName:name
          'avatarUrl': user['avatar_url'],
        },
    };
  }

  Future<List<Reel>> getReels({
    int offset = 0,
    int limit = 10,
    String? authorId,
    List<String>? friendIds,
  }) async {
    try {
      final currentUserId = _supabaseClient.auth.currentUser?.id;
      
      var query = _supabaseClient
          .from('reels')
          .select('*, author:author_id(id, displayName:name, avatar_url), isLiked:reel_likes(user_id)');

      if (authorId != null) {
        query = query.eq('author_id', authorId);
      } else if (friendIds != null && friendIds.isNotEmpty) {
        query = query.inFilter('author_id', friendIds);
      }

      final response = await query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List).map((json) {
        final List matches = json['isLiked'] as List? ?? [];
        final bool isLikedByMe = currentUserId != null && matches.any((m) => m['user_id'] == currentUserId);
        
        return Reel.fromJson({
          ..._mapReelJson(json),
          'isLikedByMe': isLikedByMe,
        });
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> likeReel(String reelId) async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) return;

      await _supabaseClient.from('reel_likes').upsert({
        'reel_id': reelId,
        'user_id': userId,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unlikeReel(String reelId) async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) return;

      await _supabaseClient
          .from('reel_likes')
          .delete()
          .match({'reel_id': reelId, 'user_id': userId});
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ReelComment>> getComments(String reelId) async {
    try {
      final response = await _supabaseClient
          .from('reel_comments')
          .select('*, user:user_id(id, displayName:name, avatar_url)')
          .eq('reel_id', reelId)
          .order('created_at', ascending: true);
          
      return (response as List).map((json) => ReelComment.fromJson(_mapCommentJson(json))).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<ReelComment> postComment({
    required String reelId,
    required String content,
    String? parentId,
  }) async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _supabaseClient.from('reel_comments').insert({
        'reel_id': reelId,
        'user_id': userId,
        'content': content,
        'parent_id': parentId,
      }).select('*, user:user_id(id, displayName:name, avatar_url)').single();

      return ReelComment.fromJson(_mapCommentJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteComment({
    required String commentId,
    required String reelId,
  }) async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Only allow deleting own comments (DB RLS also enforces this)
      await _supabaseClient
          .from('reel_comments')
          .delete()
          .match({'id': commentId, 'user_id': userId});
    } catch (e) {
      rethrow;
    }
  }

  Future<Reel> uploadReel({
    required String videoPath,
    required String description,
    String? thumbnailPath,
  }) async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final videoUrl = await _imageUploadService.uploadVideo(File(videoPath));
      if (videoUrl == null) throw Exception('Failed to upload video to Cloudinary');

      final thumbnailUrl = thumbnailPath != null 
          ? await _imageUploadService.uploadImage(File(thumbnailPath))
          : null;

      final response = await _supabaseClient.from('reels').insert({
        'author_id': userId,
        'video_url': videoUrl,
        'thumbnail_url': thumbnailUrl,
        'description': description,
      }).select('*, author:author_id(id, displayName:name, avatar_url)').single();

      return Reel.fromJson(_mapReelJson(response));
    } catch (e) {
      rethrow;
    }
  }
  Future<Reel> uploadPhotoPost({
    required String imagePath,
    required String description,
    String? audioUrl,
  }) async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final imageUrl = await _imageUploadService.uploadImage(File(imagePath));
      if (imageUrl == null) throw Exception('Failed to upload image to Cloudinary');

      final response = await _supabaseClient.from('reels').insert({
        'author_id': userId,
        'video_url': '',
        'image_url': imageUrl,
        'audio_url': audioUrl,
        'media_type': 'image',
        'description': description,
      }).select('*, author:author_id(id, displayName:name, avatar_url)').single();

      return Reel.fromJson(_mapReelJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SystemMusic>> getSystemMusic() async {
    try {
      final response = await _supabaseClient.from('system_music').select().order('created_at');
      return (response as List).map((json) => SystemMusic.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
