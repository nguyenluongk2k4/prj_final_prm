import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:prj_final_prm/features/home/presentation/widgets/music_selection_sheet.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/presentation/widgets/app_scaffold.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../stores/reels_store.dart';

class PhotoUploadPage extends StatefulWidget {
  const PhotoUploadPage({super.key});

  @override
  State<PhotoUploadPage> createState() => _PhotoUploadPageState();
}

class _PhotoUploadPageState extends State<PhotoUploadPage> {
  final _store = getIt<ReelsStore>();
  final _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _store.clearPickedImage();
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Đăng ảnh',
      showBackButton: true,
      body: Observer(
        builder: (_) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image picker / preview
              GestureDetector(
                onTap: _store.isUploading ? null : _store.pickImage,
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: _store.pickedImagePath != null
                          ? Border.all(color: Colors.pinkAccent, width: 2)
                          : null,
                    ),
                    child: _store.pickedImagePath == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add_photo_alternate_outlined,
                                  size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text('Bấm để chọn ảnh',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(_store.pickedImagePath!),
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _captionController,
                enabled: !_store.isUploading,
                decoration: const InputDecoration(
                  labelText: 'Caption',
                  hintText: 'Bạn đang nghĩ gì...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              // Music Selection
              Observer(
                builder: (_) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.music_note, color: Colors.pinkAccent),
                  title: Text(
                    _store.selectedMusic?.title ?? 'Chọn nhạc nền',
                    style: TextStyle(
                      fontWeight: _store.selectedMusic != null ? FontWeight.bold : FontWeight.normal,
                      color: _store.selectedMusic != null ? Colors.black : Colors.grey,
                    ),
                  ),
                  trailing: _store.selectedMusic != null
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => _store.selectMusic(null),
                        )
                      : const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => MusicSelectionSheet(store: _store),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              if (_store.isUploading)
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: _store.uploadProgress,
                      backgroundColor: Colors.grey[300],
                      color: Colors.pinkAccent,
                    ),
                    const SizedBox(height: 8),
                    const Text('Đang đăng tải...',
                        style: TextStyle(color: Colors.grey)),
                  ],
                )
              else
                ElevatedButton(
                  onPressed: _store.pickedImagePath == null
                      ? null
                      : () async {
                          await _store.uploadPhotoPost(_captionController.text);
                          if (!mounted) return;
                          if (_store.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(_store.errorMessage!)),
                            );
                          } else {
                            context.pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Đã đăng ảnh thành công!')),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: const Text('Đăng ngay', style: AppTextStyles.button),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
