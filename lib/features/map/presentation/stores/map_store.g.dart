// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MapStore on _MapStoreBase, Store {
  late final _$matchLocationsAtom = Atom(
    name: '_MapStoreBase.matchLocations',
    context: context,
  );

  @override
  ObservableList<LocationEntity> get matchLocations {
    _$matchLocationsAtom.reportRead();
    return super.matchLocations;
  }

  @override
  set matchLocations(ObservableList<LocationEntity> value) {
    _$matchLocationsAtom.reportWrite(value, super.matchLocations, () {
      super.matchLocations = value;
    });
  }

  late final _$currentLocationAtom = Atom(
    name: '_MapStoreBase.currentLocation',
    context: context,
  );

  @override
  LatLng? get currentLocation {
    _$currentLocationAtom.reportRead();
    return super.currentLocation;
  }

  @override
  set currentLocation(LatLng? value) {
    _$currentLocationAtom.reportWrite(value, super.currentLocation, () {
      super.currentLocation = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_MapStoreBase.isLoading',
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

  late final _$errorMessageAtom = Atom(
    name: '_MapStoreBase.errorMessage',
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

  late final _$nearbyUsersAtom = Atom(
    name: '_MapStoreBase.nearbyUsers',
    context: context,
  );

  @override
  ObservableList<LocationEntity> get nearbyUsers {
    _$nearbyUsersAtom.reportRead();
    return super.nearbyUsers;
  }

  @override
  set nearbyUsers(ObservableList<LocationEntity> value) {
    _$nearbyUsersAtom.reportWrite(value, super.nearbyUsers, () {
      super.nearbyUsers = value;
    });
  }

  late final _$fetchCurrentLocationAsyncAction = AsyncAction(
    '_MapStoreBase.fetchCurrentLocation',
    context: context,
  );

  @override
  Future<void> fetchCurrentLocation() {
    return _$fetchCurrentLocationAsyncAction.run(
      () => super.fetchCurrentLocation(),
    );
  }

  late final _$fetchNearbyUsersAsyncAction = AsyncAction(
    '_MapStoreBase.fetchNearbyUsers',
    context: context,
  );

  @override
  Future<void> fetchNearbyUsers(double radius) {
    return _$fetchNearbyUsersAsyncAction.run(
      () => super.fetchNearbyUsers(radius),
    );
  }

  late final _$updateUserLocationAsyncAction = AsyncAction(
    '_MapStoreBase.updateUserLocation',
    context: context,
  );

  @override
  Future<void> updateUserLocation(double latitude, double longitude) {
    return _$updateUserLocationAsyncAction.run(
      () => super.updateUserLocation(latitude, longitude),
    );
  }

  late final _$updateMatchLocationAsyncAction = AsyncAction(
    '_MapStoreBase.updateMatchLocation',
    context: context,
  );

  @override
  Future<void> updateMatchLocation({
    required String matchId,
    required double latitude,
    required double longitude,
  }) {
    return _$updateMatchLocationAsyncAction.run(
      () => super.updateMatchLocation(
        matchId: matchId,
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }

  late final _$_MapStoreBaseActionController = ActionController(
    name: '_MapStoreBase',
    context: context,
  );

  @override
  void subscribeToMatchLocations(String matchId) {
    final _$actionInfo = _$_MapStoreBaseActionController.startAction(
      name: '_MapStoreBase.subscribeToMatchLocations',
    );
    try {
      return super.subscribeToMatchLocations(matchId);
    } finally {
      _$_MapStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
matchLocations: ${matchLocations},
currentLocation: ${currentLocation},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
nearbyUsers: ${nearbyUsers}
    ''';
  }
}
