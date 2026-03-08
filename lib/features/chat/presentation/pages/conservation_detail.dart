import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prj_final_prm/core/theme/app_color_scheme.dart';
import 'package:prj_final_prm/core/theme/app_text_styles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tencent_calls_uikit/tencent_calls_uikit.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../gen/assets.gen.dart';
import '../../domain/entities/chat_message.dart';
import '../widgets/attachment_option_tile.dart';
import '../widgets/conversation_header.dart';
import '../widgets/conversation_input_bar.dart';
import '../widgets/conversation_message_tiles.dart';
import '../stores/conversation_detail_store.dart';
import '../stores/typing_store.dart';

// ─── Page ─────────────────────────────────────────────────────────────────────

class ConservationDetailPage extends StatefulWidget {
  final String name;
  final String? avatarUrl;
  final String userId;
  final bool hasReels;

  const ConservationDetailPage({
    super.key,
    required this.name,
    this.avatarUrl,
    this.userId = '',
    this.hasReels = false,
  });

  @override
  State<ConservationDetailPage> createState() => _ConservationDetailPageState();
}

class _ConservationDetailPageState extends State<ConservationDetailPage>
  with WidgetsBindingObserver {
  final TextEditingController _msgCtrl = TextEditingController();
  final FocusNode _msgFocusNode = FocusNode();
  final ScrollController _listScrollCtrl = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  final SupabaseClient _supabase = Supabase.instance.client;
  final ConversationDetailStore _detailStore =
      GetIt.I<ConversationDetailStore>();
  final _typingStore = GetIt.I<TypingStore>();
  bool _hasText = false;
  String? _currentUserId;
  double _lastViewInsetsBottom = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    _currentUserId = _supabase.auth.currentUser?.id;
    _msgFocusNode.addListener(() {
      if (kDebugMode) {
        debugPrint('[ConversationDetail] focus=${_msgFocusNode.hasFocus}');
      }
      if (_msgFocusNode.hasFocus) {
        _typingStore.sendTypingNow(true);
        _scrollToBottom();
      } else {
        _typingStore.sendTypingNow(false);
      }
    });
    _msgCtrl.addListener(() {
      final hasText = _msgCtrl.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
      if (hasText) {
        _typingStore.scheduleTypingPing(true);
      }
    });
    final myId = _currentUserId;
    if (myId != null && widget.userId.isNotEmpty) {
      _detailStore.init(myId: myId, otherId: widget.userId);
      _typingStore.init(myId: myId, otherId: widget.userId);
    }
  }

  @override
  void dispose() {
    _typingStore.sendTypingNow(false);
    _typingStore.dispose();
    _detailStore.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _msgFocusNode.dispose();
    _msgCtrl.dispose();
    _listScrollCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final viewInsets = WidgetsBinding.instance.window.viewInsets;
    final pixelRatio = WidgetsBinding.instance.window.devicePixelRatio;
    final currentBottom = viewInsets.bottom / pixelRatio;

    if (currentBottom > _lastViewInsetsBottom && _msgFocusNode.hasFocus) {
      if (kDebugMode) {
        debugPrint('[ConversationDetail] keyboard opened');
      }
      _scrollToBottom();
    }

    _lastViewInsetsBottom = currentBottom;
  }

  Future<void> _sendMessage() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    _typingStore.sendTypingNow(false);
    _msgCtrl.clear();
    final ok = await _detailStore.sendTextMessage(text);
    if (!ok && mounted) {
      final t = context.t;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.failedToSendMessage)),
      );
    }
    _scrollToBottom();
  }


  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_listScrollCtrl.hasClients) return;
      _listScrollCtrl.animateTo(
        _listScrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }


  Future<void> _startAudioCall() async {
    if (widget.userId.isEmpty) {
      _showNoUserIdSnack();
      return;
    }
    await TUICallKit.instance.call(widget.userId, TUICallMediaType.audio);
  }

  Future<void> _startVideoCall() async {
    if (widget.userId.isEmpty) {
      _showNoUserIdSnack();
      return;
    }
    await TUICallKit.instance.call(widget.userId, TUICallMediaType.video);
  }

  void _showNoUserIdSnack() {
    final t = context.t;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.userIdNotAvailableForCalling)),
    );
  }

  void _showAttachmentOptions() {
    final c = context.appColors;
    final t = context.t;
    showModalBottomSheet(
      context: context,
      backgroundColor: c.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AttachmentOptionTile(
              icon: Assets.icons.icCamera.svg(
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              label: t.photo,
              color: AppColors.primary,
              onTap: _pickImage,
            ),
            AttachmentOptionTile(
              icon: Assets.icons.icAttachment.svg(
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF7B61FF),
                  BlendMode.srcIn,
                ),
              ),
              label: t.fileLabel,
              color: const Color(0xFF7B61FF),
              onTap: _pickFile,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    Navigator.of(context).pop();
    final img = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (img == null) return;
    final ok = await _detailStore.sendImageMessage(
      file: File(img.path),
      name: img.name,
    );
    if (!ok && mounted) {
      final t = context.t;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.failedToUploadImage)),
      );
    }
    _scrollToBottom();
  }

  Future<void> _pickFile() async {
    Navigator.of(context).pop();
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    final path = file.path;
    if (path == null) return;
    final ok = await _detailStore.sendFileMessage(
      file: File(path),
      name: file.name,
    );
    if (!ok && mounted) {
      final t = context.t;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.failedToUploadFile)),
      );
    }
    _scrollToBottom();
  }

  void _showDownloadSheet({required String url, required String label}) {
    if (url.isEmpty) return;
    final c = context.appColors;
    final t = context.t;
    showModalBottomSheet(
      context: context,
      backgroundColor: c.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: ListTile(
          leading: const Icon(Icons.download_rounded),
          title: Text(t.downloadLabel(label: label)),
          onTap: () async {
            Navigator.of(context).pop();
            final savePath = await _detailStore.downloadFile(url: url);
            if (!mounted) return;
            if (savePath == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(t.failedToDownloadFile)),
              );
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(t.downloadedTo(path: savePath))),
            );
          },
        ),
      ),
    );
  }

  void _previewImage({String? filePath, String? fileUrl}) {
    if (filePath == null && (fileUrl == null || fileUrl.isEmpty)) return;
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (_) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: InteractiveViewer(
            child: filePath != null
                ? Image.file(File(filePath))
                : Image.network(fileUrl!),
          ),
        ),
      ),
    );
  }

  void _onVoiceTap() {
    final t = context.t;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.holdToRecordAudioMessage),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return Scaffold(
      backgroundColor: c.background,
      body: Column(
        children: [
          Observer(
            builder: (_) => ConversationHeader(
              name: widget.name,
              avatarUrl: widget.avatarUrl,
              hasReels: widget.hasReels,
              isOnline: _detailStore.isOnline,
              lastActive: _detailStore.lastActive,
              statusTextOverride:
                  _typingStore.isOtherTyping ? context.t.typing : null,
              onBack: () => Navigator.of(context).pop(),
              onCall: _startAudioCall,
              onVideoCall: _startVideoCall,
            ),
          ),
          Expanded(
            child: Observer(builder: (_) {
              if (_detailStore.isLoading && _detailStore.messages.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_detailStore.error != null && _detailStore.messages.isEmpty) {
                return Center(
                  child: Text(
                    _detailStore.error!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.red,
                    ),
                  ),
                );
              }

              final showTyping = _typingStore.isOtherTyping;
              return ListView.builder(
                controller: _listScrollCtrl,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                itemCount:
                    _detailStore.messages.length + 1 + (showTyping ? 1 : 0),
                itemBuilder: (_, i) {
                  if (i == 1) {
                    return ConversationDateSeparator(
                      label: context.t.today,
                      colors: c,
                    );
                  }

                  final baseIdx = i > 1 ? i - 1 : i;
                  if (baseIdx >= _detailStore.messages.length) {
                    return showTyping
                        ? ConversationTypingIndicatorTile(colors: c)
                        : const SizedBox.shrink();
                  }

                  final msg = _detailStore.messages[baseIdx];
                  if (msg.type == ChatMessageType.image) {
                    return ConversationImageBubbleTile(
                      message: msg,
                      colors: c,
                      onTap: () => _previewImage(
                        filePath: msg.filePath,
                        fileUrl: msg.fileUrl,
                      ),
                      onLongPress: () => _showDownloadSheet(
                        url: msg.fileUrl ?? '',
                        label: context.t.imageLabel,
                      ),
                    );
                  }
                  if (msg.type == ChatMessageType.file) {
                    return ConversationFileBubbleTile(
                      message: msg,
                      colors: c,
                      onTap: () {
                        final t = context.t;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(t.longPressToDownload),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      onLongPress: () => _showDownloadSheet(
                        url: msg.fileUrl ?? '',
                        label: context.t.fileLabel,
                      ),
                    );
                  }
                  return ConversationBubbleTile(message: msg, colors: c);
                },
              );
            }),
          ),
          ConversationInputBar(
            controller: _msgCtrl,
            focusNode: _msgFocusNode,
            hasText: _hasText,
            onSend: _sendMessage,
            onAttachmentTap: _showAttachmentOptions,
            onVoiceTap: _onVoiceTap,
            onInputTap: () {
              if (kDebugMode) {
                debugPrint('[ConversationDetail] input tap');
              }
              _typingStore.sendTypingNow(true);
              _scrollToBottom();
            },
          ),
        ],
      ),
    );
  }
}
