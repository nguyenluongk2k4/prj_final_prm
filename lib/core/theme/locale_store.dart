import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_store.g.dart';

/// MobX Store quản lý ngôn ngữ
class LocaleStore = _LocaleStore with _$LocaleStore;

abstract class _LocaleStore with Store {
  static const String _localeKey = 'locale';

  @observable
  Locale currentLocale = const Locale('en');

  /// Danh sách ngôn ngữ hỗ trợ
  final List<Locale> supportedLocales = const [
    Locale('en'), // English
    Locale('vi'), // Vietnamese
  ];

  @action
  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey);
    
    if (localeCode != null) {
      currentLocale = Locale(localeCode);
    }
  }

  @action
  Future<void> setLocale(Locale locale) async {
    currentLocale = locale;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  @action
  Future<void> toggleLocale() async {
    if (currentLocale.languageCode == 'en') {
      await setLocale(const Locale('vi'));
    } else {
      await setLocale(const Locale('en'));
    }
  }
}
