import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/image_upload_service.dart';
import '../models/album_image_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AlbumRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final ImageUploadService _imageUploadService;

  SupabaseClient get supabase => _supabaseClient;

  AlbumRemoteDataSource(this._supabaseClient, this._imageUploadService);

  Future<List<AlbumImageModel>> getMyAlbumImages() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return [];
    return getUserAlbumImages(userId);
  }

  Future<List<AlbumImageModel>> getUserAlbumImages(String userId) async {
    final response = await _supabaseClient
        .from('album_images')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((json) => AlbumImageModel.fromJson(json)).toList();
  }

  Future<AlbumImageModel> uploadAlbumImage(File imageFile) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    // 1. Upload to Cloudinary
    final imageUrl = await _imageUploadService.uploadImage(imageFile);
    if (imageUrl == null) throw Exception('Failed to upload image to Cloudinary');

    // 2. Save metadata to Supabase
    final response = await _supabaseClient.from('album_images').insert({
      'user_id': userId,
      'image_url': imageUrl,
    }).select().single();

    return AlbumImageModel.fromJson(response);
  }

  Future<void> deleteAlbumImage(String imageId) async {
    await _supabaseClient.from('album_images').delete().eq('id', imageId);
  }
}
