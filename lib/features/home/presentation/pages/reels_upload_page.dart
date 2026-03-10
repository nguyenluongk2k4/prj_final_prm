import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/presentation/widgets/app_scaffold.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../stores/reels_store.dart';
import 'package:go_router/go_router.dart';

class ReelsUploadPage extends StatefulWidget {
  const ReelsUploadPage({super.key});

  @override
  State<ReelsUploadPage> createState() => _ReelsUploadPageState();
}

class _ReelsUploadPageState extends State<ReelsUploadPage> {
  final _store = getIt<ReelsStore>();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Đăng Reels',
      showBackButton: true,
      body: Observer(
        builder: (_) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Video Selection / Preview
              GestureDetector(
                onTap: _store.isUploading ? null : _store.pickVideo,
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: _store.pickedVideoPath != null
                          ? Border.all(color: Colors.pinkAccent, width: 2)
                          : null,
                    ),
                    child: _store.pickedVideoPath == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.video_library_outlined,
                                  size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text('Bấm để chọn video',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_outline,
                                  size: 64, color: Colors.green),
                              SizedBox(height: 16),
                              Text('Đã chọn video',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold)),
                              Text('Chạm để chọn lại',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _descriptionController,
                enabled: !_store.isUploading,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  hintText: 'Bạn đang nghĩ gì...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
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
                  onPressed: _store.pickedVideoPath == null
                      ? null
                      : () async {
                          await _store.uploadReel(_descriptionController.text);
                          if (_store.errorMessage != null) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(_store.errorMessage!)),
                              );
                            }
                          } else {
                            if (mounted) {
                              context.pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Đã đăng Reels thành công!')),
                              );
                            }
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
