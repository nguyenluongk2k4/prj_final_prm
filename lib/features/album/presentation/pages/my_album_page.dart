import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../i18n/strings.g.dart';
import '../stores/album_store.dart';

class MyAlbumPage extends StatefulWidget {
  const MyAlbumPage({super.key});

  @override
  State<MyAlbumPage> createState() => _MyAlbumPageState();
}

class _MyAlbumPageState extends State<MyAlbumPage> {
  final _store = getIt<AlbumStore>();
  final _picker = ImagePicker();

  /// Giữ file đang upload để hiện preview placeholder trong grid
  File? _uploadingFile;

  @override
  void initState() {
    super.initState();
    _store.fetchImages();
  }

  Future<void> _pickAndUploadImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      // Hiện placeholder ngay lập tức với ảnh local
      setState(() => _uploadingFile = File(picked.path));
      await _store.uploadImage(File(picked.path));
      // Ảnh thật đã được thêm vào store → bỏ placeholder
      setState(() => _uploadingFile = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;

    return AppScaffold(
      showBackButton: true,
      showQuickActions: false,
      titleWidget: Text(
        t.photoAlbum,
        style: AppTextStyles.h2.copyWith(color: c.textPrimary),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add_a_photo_outlined),
          // Disable nút khi đang upload
          onPressed: _uploadingFile != null ? null : _pickAndUploadImage,
        ),
      ],
      body: Observer(
        builder: (_) => _buildBody(context, t, c),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Translations t, dynamic c) {
    if (_store.isLoading && _store.images.isEmpty && _uploadingFile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_store.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_store.errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _store.fetchImages,
              child: Text(t.retry),
            ),
          ],
        ),
      );
    }

    final hasItems = _store.images.isNotEmpty || _uploadingFile != null;

    if (!hasItems) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined, size: 64, color: c.text70),
            const SizedBox(height: 16),
            Text(
              t.albumEmpty,
              style: AppTextStyles.bodyLarge.copyWith(color: c.text70),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _pickAndUploadImage,
              icon: const Icon(Icons.add_a_photo_outlined),
              label: Text(t.uploadPhoto),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    // Nếu đang upload: placeholder ở đầu + các ảnh đã tải
    final uploadingCount = _uploadingFile != null ? 1 : 0;
    final totalCount = uploadingCount + _store.images.length;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: totalCount,
      itemBuilder: (context, index) {
        // Ô đầu tiên = placeholder ảnh đang upload
        if (index == 0 && _uploadingFile != null) {
          return _UploadingPlaceholder(file: _uploadingFile!);
        }

        final imageIndex = index - uploadingCount;
        final image = _store.images[imageIndex];
        return _AlbumImageItem(
          imageUrl: image.imageUrl,
          onDelete: () => _store.deleteImage(image.id),
        );
      },
    );
  }
}

/// Ô placeholder hiển thị ảnh local preview + spinner trong khi upload
class _UploadingPlaceholder extends StatelessWidget {
  final File file;

  const _UploadingPlaceholder({required this.file});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Preview ảnh local
          Image.file(file, fit: BoxFit.cover),
          // Overlay mờ + spinner
          Container(
            color: Colors.black45,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Ô ảnh đã upload xong — hiển thị từ URL + nút xoá
class _AlbumImageItem extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onDelete;

  const _AlbumImageItem({
    required this.imageUrl,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              final t = Translations.of(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(t.deletePhoto),
                  content: Text(t.deletePhotoConfirm),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(t.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        onDelete();
                        Navigator.pop(context);
                      },
                      child: Text(t.delete, style: const TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
