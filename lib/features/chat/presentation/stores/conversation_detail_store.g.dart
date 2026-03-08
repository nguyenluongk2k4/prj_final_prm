// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_detail_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConversationDetailStore on _ConversationDetailStore, Store {
  late final _$isLoadingAtom = Atom(
    name: '_ConversationDetailStore.isLoading',
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

  late final _$errorAtom = Atom(
    name: '_ConversationDetailStore.error',
    context: context,
  );

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$isOnlineAtom = Atom(
    name: '_ConversationDetailStore.isOnline',
    context: context,
  );

  @override
  bool get isOnline {
    _$isOnlineAtom.reportRead();
    return super.isOnline;
  }

  @override
  set isOnline(bool value) {
    _$isOnlineAtom.reportWrite(value, super.isOnline, () {
      super.isOnline = value;
    });
  }

  late final _$lastActiveAtom = Atom(
    name: '_ConversationDetailStore.lastActive',
    context: context,
  );

  @override
  DateTime? get lastActive {
    _$lastActiveAtom.reportRead();
    return super.lastActive;
  }

  @override
  set lastActive(DateTime? value) {
    _$lastActiveAtom.reportWrite(value, super.lastActive, () {
      super.lastActive = value;
    });
  }

  late final _$messagesAtom = Atom(
    name: '_ConversationDetailStore.messages',
    context: context,
  );

  @override
  ObservableList<ChatMessage> get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(ObservableList<ChatMessage> value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

  late final _$loadMessagesAsyncAction = AsyncAction(
    '_ConversationDetailStore.loadMessages',
    context: context,
  );

  @override
  Future<void> loadMessages() {
    return _$loadMessagesAsyncAction.run(() => super.loadMessages());
  }

  late final _$loadPresenceAsyncAction = AsyncAction(
    '_ConversationDetailStore.loadPresence',
    context: context,
  );

  @override
  Future<void> loadPresence() {
    return _$loadPresenceAsyncAction.run(() => super.loadPresence());
  }

  late final _$sendTextMessageAsyncAction = AsyncAction(
    '_ConversationDetailStore.sendTextMessage',
    context: context,
  );

  @override
  Future<bool> sendTextMessage(String text) {
    return _$sendTextMessageAsyncAction.run(() => super.sendTextMessage(text));
  }

  late final _$sendImageMessageAsyncAction = AsyncAction(
    '_ConversationDetailStore.sendImageMessage',
    context: context,
  );

  @override
  Future<bool> sendImageMessage({required File file, required String name}) {
    return _$sendImageMessageAsyncAction.run(
      () => super.sendImageMessage(file: file, name: name),
    );
  }

  late final _$sendFileMessageAsyncAction = AsyncAction(
    '_ConversationDetailStore.sendFileMessage',
    context: context,
  );

  @override
  Future<bool> sendFileMessage({required File file, required String name}) {
    return _$sendFileMessageAsyncAction.run(
      () => super.sendFileMessage(file: file, name: name),
    );
  }

  late final _$_ConversationDetailStoreActionController = ActionController(
    name: '_ConversationDetailStore',
    context: context,
  );

  @override
  void _handleIncoming(ChatMessage message) {
    final _$actionInfo = _$_ConversationDetailStoreActionController.startAction(
      name: '_ConversationDetailStore._handleIncoming',
    );
    try {
      return super._handleIncoming(message);
    } finally {
      _$_ConversationDetailStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
error: ${error},
isOnline: ${isOnline},
lastActive: ${lastActive},
messages: ${messages}
    ''';
  }
}
