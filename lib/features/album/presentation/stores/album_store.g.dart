// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AlbumStore on _AlbumStore, Store {
  late final _$imagesAtom = Atom(name: '_AlbumStore.images', context: context);

  @override
  ObservableList<AlbumImage> get images {
    _$imagesAtom.reportRead();
    return super.images;
  }

  @override
  set images(ObservableList<AlbumImage> value) {
    _$imagesAtom.reportWrite(value, super.images, () {
      super.images = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_AlbumStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isUploadingAtom = Atom(
    name: '_AlbumStore.isUploading',
    context: context,
  );

  @override
  bool get isUploading {
    _$isUploadingAtom.reportRead();
    return super.isUploading;
  }

  @override
  set isUploading(bool value) {
    _$isUploadingAtom.reportWrite(value, super.isUploading, () {
      super.isUploading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_AlbumStore.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$fetchImagesAsyncAction = AsyncAction(
    '_AlbumStore.fetchImages',
    context: context,
  );

  @override
  Future<void> fetchImages() {
    return _$fetchImagesAsyncAction.run(() => super.fetchImages());
  }

  late final _$uploadImageAsyncAction = AsyncAction(
    '_AlbumStore.uploadImage',
    context: context,
  );

  @override
  Future<void> uploadImage(File imageFile) {
    return _$uploadImageAsyncAction.run(() => super.uploadImage(imageFile));
  }

  late final _$deleteImageAsyncAction = AsyncAction(
    '_AlbumStore.deleteImage',
    context: context,
  );

  @override
  Future<void> deleteImage(String imageId) {
    return _$deleteImageAsyncAction.run(() => super.deleteImage(imageId));
  }

  late final _$_AlbumStoreActionController = ActionController(
    name: '_AlbumStore',
    context: context,
  );

  @override
  void clearError() {
    final _$actionInfo = _$_AlbumStoreActionController.startAction(
      name: '_AlbumStore.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_AlbumStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
images: ${images},
isLoading: ${isLoading},
isUploading: ${isUploading},
errorMessage: ${errorMessage}
    ''';
  }
}
