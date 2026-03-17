import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/download_chat_file_usecase.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/get_presence_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/usecases/subscribe_messages_usecase.dart';
import '../../domain/usecases/upload_chat_file_usecase.dart';
import '../../domain/usecases/upload_chat_image_usecase.dart';
import '../../domain/utils/chat_message_formatter.dart';

part 'conversation_detail_store.g.dart';

@injectable
class ConversationDetailStore = _ConversationDetailStore
    with _$ConversationDetailStore;

abstract class _ConversationDetailStore with Store {
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final SubscribeMessagesUseCase _subscribeMessagesUseCase;
  final GetPresenceUseCase _getPresenceUseCase;
  final UploadChatImageUseCase _uploadImageUseCase;
  final UploadChatFileUseCase _uploadFileUseCase;
  final DownloadChatFileUseCase _downloadFileUseCase;

  _ConversationDetailStore(
    this._getMessagesUseCase,
    this._sendMessageUseCase,
    this._subscribeMessagesUseCase,
    this._getPresenceUseCase,
    this._uploadImageUseCase,
    this._uploadFileUseCase,
    this._downloadFileUseCase,
  );

  final Set<String> _messageIds = <String>{};
  StreamSubscription<ChatMessage>? _messagesSub;
  String? _myId;
  String? _otherId;
  int _tempIdSeed = 0;

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @observable
  bool isOnline = false;

  @observable
  DateTime? lastActive;

  @observable
  ObservableList<ChatMessage> messages = ObservableList<ChatMessage>();

  void init({required String myId, required String otherId}) {
    _myId = myId;
    _otherId = otherId;
    loadMessages();
    loadPresence();
    _subscribeMessages();
  }

  @action
  Future<void> loadMessages() async {
    final myId = _myId;
    final otherId = _otherId;
    if (myId == null || otherId == null) return;

    isLoading = true;
    error = null;

    try {
      final items = await _getMessagesUseCase.execute(
        myId: myId,
        otherId: otherId,
      );
      items.sort(_compareByTime);
      messages
        ..clear()
        ..addAll(items);
      _messageIds
        ..clear()
        ..addAll(items.where((m) => m.id != null).map((m) => m.id!));
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> loadPresence() async {
    final otherId = _otherId;
    if (otherId == null || otherId.isEmpty) return;

    try {
      final presence = await _getPresenceUseCase.execute(userId: otherId);
      if (presence == null) return;
      isOnline = presence.isOnline;
      lastActive = presence.lastActive;
    } catch (_) {
      // Ignore presence failures to avoid blocking UI.
    }
  }

  @action
  Future<bool> sendTextMessage(String text) async {
    if (text.trim().isEmpty) return false;
    final myId = _myId;
    final otherId = _otherId;
    if (myId == null || otherId == null) return false;

    final tempId = _nextTempId();
    final now = DateTime.now();
    _addTempMessage(
      ChatMessage(
        id: tempId,
        type: ChatMessageType.text,
        text: text,
        time: ChatMessageFormatter.formatTime(now),
        sender: ChatSender.me,
        createdAt: now,
      ),
    );

    try {
      final message = await _sendMessageUseCase.execute(
        myId: myId,
        otherId: otherId,
        content: text,
        type: ChatMessageType.text,
      );
      _replaceTempMessage(tempId, message);
      return true;
    } catch (e, st) {
      debugPrint('[Chat] ❌ sendTextMessage error: $e\n$st');
      _removeTempMessage(tempId);
      return false;
    }
  }

  @action
  Future<bool> sendImageMessage({required File file, required String name}) async {
    final myId = _myId;
    final otherId = _otherId;
    if (myId == null || otherId == null) return false;

    final tempId = _nextTempId();
    final now = DateTime.now();
    _addTempMessage(
      ChatMessage(
        id: tempId,
        type: ChatMessageType.image,
        text: name,
        time: ChatMessageFormatter.formatTime(now),
        sender: ChatSender.me,
        filePath: file.path,
        createdAt: now,
      ),
    );

    final url = await _uploadImageUseCase.execute(file: file);
    if (url == null) {
      _removeTempMessage(tempId);
      return false;
    }

    try {
      final message = await _sendMessageUseCase.execute(
        myId: myId,
        otherId: otherId,
        content: url,
        type: ChatMessageType.image,
      );
      _replaceTempMessage(tempId, message);
      return true;
    } catch (_) {
      _removeTempMessage(tempId);
      return false;
    }
  }

  @action
  Future<bool> sendFileMessage({
    required File file,
    required String name,
  }) async {
    final myId = _myId;
    final otherId = _otherId;
    if (myId == null || otherId == null) return false;

    final tempId = _nextTempId();
    final now = DateTime.now();
    _addTempMessage(
      ChatMessage(
        id: tempId,
        type: ChatMessageType.file,
        text: name,
        time: ChatMessageFormatter.formatTime(now),
        sender: ChatSender.me,
        filePath: file.path,
        createdAt: now,
      ),
    );

    final url = await _uploadFileUseCase.execute(file: file);
    if (url == null) {
      _removeTempMessage(tempId);
      return false;
    }

    try {
      final message = await _sendMessageUseCase.execute(
        myId: myId,
        otherId: otherId,
        content: url,
        type: ChatMessageType.file,
      );
      _replaceTempMessage(tempId, message);
      return true;
    } catch (_) {
      _removeTempMessage(tempId);
      return false;
    }
  }

  Future<String?> downloadFile({required String url}) async {
    if (url.isEmpty) return null;
    try {
      return await _downloadFileUseCase.execute(url: url);
    } catch (_) {
      return null;
    }
  }

  void dispose() {
    _messagesSub?.cancel();
    _messagesSub = null;
  }

  void _subscribeMessages() {
    final myId = _myId;
    final otherId = _otherId;
    if (myId == null || otherId == null) return;

    _messagesSub?.cancel();
    _messagesSub = _subscribeMessagesUseCase
        .execute(myId: myId, otherId: otherId)
        .listen(_handleIncoming);
  }

  @action
  void _handleIncoming(ChatMessage message) {
    final id = message.id;
    if (id != null && _messageIds.contains(id)) return;

    messages.add(message);
    if (id != null) _messageIds.add(id);
    messages.sort(_compareByTime);
  }

  void _addTempMessage(ChatMessage message) {
    messages.add(message);
    messages.sort(_compareByTime);
  }

  void _replaceTempMessage(String tempId, ChatMessage message) {
    final idx = messages.indexWhere((m) => m.id == tempId);
    if (idx != -1) {
      messages[idx] = message;
    } else {
      messages.add(message);
    }
    if (message.id != null) _messageIds.add(message.id!);
    messages.sort(_compareByTime);
  }

  void _removeTempMessage(String tempId) {
    messages.removeWhere((m) => m.id == tempId);
  }

  int _compareByTime(ChatMessage a, ChatMessage b) {
    final left = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final right = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    return left.compareTo(right);
  }

  String _nextTempId() => 'temp_${_tempIdSeed++}';
}
