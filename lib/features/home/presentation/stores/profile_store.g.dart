// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProfileStore on _ProfileStore, Store {
  Computed<bool>? _$isMeComputed;

  @override
  bool get isMe => (_$isMeComputed ??= Computed<bool>(
    () => super.isMe,
    name: '_ProfileStore.isMe',
  )).value;
  Computed<bool>? _$hasRelationshipComputed;

  @override
  bool get hasRelationship => (_$hasRelationshipComputed ??= Computed<bool>(
    () => super.hasRelationship,
    name: '_ProfileStore.hasRelationship',
  )).value;
  Computed<bool>? _$showActionsComputed;

  @override
  bool get showActions => (_$showActionsComputed ??= Computed<bool>(
    () => super.showActions,
    name: '_ProfileStore.showActions',
  )).value;

  late final _$isLoadingAtom = Atom(
    name: '_ProfileStore.isLoading',
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

  late final _$errorAtom = Atom(name: '_ProfileStore.error', context: context);

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

  late final _$profileAtom = Atom(
    name: '_ProfileStore.profile',
    context: context,
  );

  @override
  UserProfile? get profile {
    _$profileAtom.reportRead();
    return super.profile;
  }

  @override
  set profile(UserProfile? value) {
    _$profileAtom.reportWrite(value, super.profile, () {
      super.profile = value;
    });
  }

  late final _$friendStatusAtom = Atom(
    name: '_ProfileStore.friendStatus',
    context: context,
  );

  @override
  FriendStatus? get friendStatus {
    _$friendStatusAtom.reportRead();
    return super.friendStatus;
  }

  @override
  set friendStatus(FriendStatus? value) {
    _$friendStatusAtom.reportWrite(value, super.friendStatus, () {
      super.friendStatus = value;
    });
  }

  late final _$fetchProfileAsyncAction = AsyncAction(
    '_ProfileStore.fetchProfile',
    context: context,
  );

  @override
  Future<void> fetchProfile(String userId) {
    return _$fetchProfileAsyncAction.run(() => super.fetchProfile(userId));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
error: ${error},
profile: ${profile},
friendStatus: ${friendStatus},
isMe: ${isMe},
hasRelationship: ${hasRelationship},
showActions: ${showActions}
    ''';
  }
}
