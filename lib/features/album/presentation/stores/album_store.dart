import 'dart:io';
import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/album_image.dart';
import '../../domain/usecases/get_my_album_images_usecase.dart';
import '../../domain/usecases/upload_album_image_usecase.dart';
import '../../domain/usecases/delete_album_image_usecase.dart';

part 'album_store.g.dart';

@injectable
class AlbumStore = _AlbumStore with _$AlbumStore;

abstract class _AlbumStore with Store {
  final GetMyAlbumImagesUseCase _getMyAlbumImagesUseCase;
  final UploadAlbumImageUseCase _uploadAlbumImageUseCase;
  final DeleteAlbumImageUseCase _deleteAlbumImageUseCase;

  _AlbumStore(
    this._getMyAlbumImagesUseCase,
    this._uploadAlbumImageUseCase,
    this._deleteAlbumImageUseCase,
  );

  @observable
  ObservableList<AlbumImage> images = ObservableList<AlbumImage>();

  @observable
  bool isLoading = false;

  @observable
  bool isUploading = false;

  @observable
  String? errorMessage;

  @action
  Future<void> fetchImages() async {
    isLoading = true;
    errorMessage = null;
    
    final result = await _getMyAlbumImagesUseCase();
    result.fold(
      (l) => errorMessage = l.message,
      (r) {
        images.clear();
        images.addAll(r);
      },
    );
    
    isLoading = false;
  }

  @action
  Future<void> uploadImage(File imageFile) async {
    isUploading = true;
    errorMessage = null;

    final result = await _uploadAlbumImageUseCase(imageFile);
    result.fold(
      (l) => errorMessage = l.message,
      (r) => images.insert(0, r),
    );

    isUploading = false;
  }

  @action
  Future<void> deleteImage(String imageId) async {
    final result = await _deleteAlbumImageUseCase(imageId);
    result.fold(
      (l) => errorMessage = l.message,
      (r) => images.removeWhere((img) => img.id == imageId),
    );
  }

  @action
  void clearError() => errorMessage = null;
}
