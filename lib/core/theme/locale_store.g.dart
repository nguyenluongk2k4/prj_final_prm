// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LocaleStore on _LocaleStore, Store {
  late final _$currentLocaleAtom = Atom(
    name: '_LocaleStore.currentLocale',
    context: context,
  );

  @override
  Locale get currentLocale {
    _$currentLocaleAtom.reportRead();
    return super.currentLocale;
  }

  @override
  set currentLocale(Locale value) {
    _$currentLocaleAtom.reportWrite(value, super.currentLocale, () {
      super.currentLocale = value;
    });
  }

  late final _$loadLocaleAsyncAction = AsyncAction(
    '_LocaleStore.loadLocale',
    context: context,
  );

  @override
  Future<void> loadLocale() {
    return _$loadLocaleAsyncAction.run(() => super.loadLocale());
  }

  late final _$setLocaleAsyncAction = AsyncAction(
    '_LocaleStore.setLocale',
    context: context,
  );

  @override
  Future<void> setLocale(Locale locale) {
    return _$setLocaleAsyncAction.run(() => super.setLocale(locale));
  }

  late final _$toggleLocaleAsyncAction = AsyncAction(
    '_LocaleStore.toggleLocale',
    context: context,
  );

  @override
  Future<void> toggleLocale() {
    return _$toggleLocaleAsyncAction.run(() => super.toggleLocale());
  }

  @override
  String toString() {
    return '''
currentLocale: ${currentLocale}
    ''';
  }
}
