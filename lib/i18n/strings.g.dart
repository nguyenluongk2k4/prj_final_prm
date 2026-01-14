/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 52 (26 per locale)
///
/// Built on 2026-01-14 at 14:02 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.en;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale with BaseAppLocale<AppLocale, Translations> {
	en(languageCode: 'en', build: Translations.build),
	vi(languageCode: 'vi', build: _StringsVi.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, Translations> build;

	/// Gets current instance managed by [LocaleSettings].
	Translations get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
Translations get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class TranslationProvider extends BaseTranslationProvider<AppLocale, Translations> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, Translations> of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	Translations get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, Translations> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, Translations> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	// Translations
	String get appName => 'PRM Final Project';
	String get ok => 'OK';
	String get cancel => 'Cancel';
	String get save => 'Save';
	String get delete => 'Delete';
	String get edit => 'Edit';
	String get search => 'Search';
	String get loading => 'Loading...';
	String get error => 'Error';
	String get success => 'Success';
	String get login => 'Login';
	String get logout => 'Logout';
	String get register => 'Register';
	String get email => 'Email';
	String get password => 'Password';
	String get name => 'Name';
	String get pleaseEnterEmail => 'Please enter email';
	String get pleaseEnterPassword => 'Please enter password';
	String get pleaseEnterName => 'Please enter name';
	String get settings => 'Settings';
	String get darkMode => 'Dark Mode';
	String get lightMode => 'Light Mode';
	String get language => 'Language';
	String get theme => 'Theme';
	String get noInternetConnection => 'No internet connection';
	String get serverError => 'Server error occurred';
}

// Path: <root>
class _StringsVi extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsVi.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.vi,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <vi>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	@override late final _StringsVi _root = this; // ignore: unused_field

	// Translations
	@override String get appName => 'Dự án PRM';
	@override String get ok => 'Đồng ý';
	@override String get cancel => 'Hủy';
	@override String get save => 'Lưu';
	@override String get delete => 'Xóa';
	@override String get edit => 'Sửa';
	@override String get search => 'Tìm kiếm';
	@override String get loading => 'Đang tải...';
	@override String get error => 'Lỗi';
	@override String get success => 'Thành công';
	@override String get login => 'Đăng nhập';
	@override String get logout => 'Đăng xuất';
	@override String get register => 'Đăng ký';
	@override String get email => 'Email';
	@override String get password => 'Mật khẩu';
	@override String get name => 'Tên';
	@override String get pleaseEnterEmail => 'Vui lòng nhập email';
	@override String get pleaseEnterPassword => 'Vui lòng nhập mật khẩu';
	@override String get pleaseEnterName => 'Vui lòng nhập tên';
	@override String get settings => 'Cài đặt';
	@override String get darkMode => 'Chế độ tối';
	@override String get lightMode => 'Chế độ sáng';
	@override String get language => 'Ngôn ngữ';
	@override String get theme => 'Giao diện';
	@override String get noInternetConnection => 'Không có kết nối internet';
	@override String get serverError => 'Đã xảy ra lỗi máy chủ';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'appName': return 'PRM Final Project';
			case 'ok': return 'OK';
			case 'cancel': return 'Cancel';
			case 'save': return 'Save';
			case 'delete': return 'Delete';
			case 'edit': return 'Edit';
			case 'search': return 'Search';
			case 'loading': return 'Loading...';
			case 'error': return 'Error';
			case 'success': return 'Success';
			case 'login': return 'Login';
			case 'logout': return 'Logout';
			case 'register': return 'Register';
			case 'email': return 'Email';
			case 'password': return 'Password';
			case 'name': return 'Name';
			case 'pleaseEnterEmail': return 'Please enter email';
			case 'pleaseEnterPassword': return 'Please enter password';
			case 'pleaseEnterName': return 'Please enter name';
			case 'settings': return 'Settings';
			case 'darkMode': return 'Dark Mode';
			case 'lightMode': return 'Light Mode';
			case 'language': return 'Language';
			case 'theme': return 'Theme';
			case 'noInternetConnection': return 'No internet connection';
			case 'serverError': return 'Server error occurred';
			default: return null;
		}
	}
}

extension on _StringsVi {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'appName': return 'Dự án PRM';
			case 'ok': return 'Đồng ý';
			case 'cancel': return 'Hủy';
			case 'save': return 'Lưu';
			case 'delete': return 'Xóa';
			case 'edit': return 'Sửa';
			case 'search': return 'Tìm kiếm';
			case 'loading': return 'Đang tải...';
			case 'error': return 'Lỗi';
			case 'success': return 'Thành công';
			case 'login': return 'Đăng nhập';
			case 'logout': return 'Đăng xuất';
			case 'register': return 'Đăng ký';
			case 'email': return 'Email';
			case 'password': return 'Mật khẩu';
			case 'name': return 'Tên';
			case 'pleaseEnterEmail': return 'Vui lòng nhập email';
			case 'pleaseEnterPassword': return 'Vui lòng nhập mật khẩu';
			case 'pleaseEnterName': return 'Vui lòng nhập tên';
			case 'settings': return 'Cài đặt';
			case 'darkMode': return 'Chế độ tối';
			case 'lightMode': return 'Chế độ sáng';
			case 'language': return 'Ngôn ngữ';
			case 'theme': return 'Giao diện';
			case 'noInternetConnection': return 'Không có kết nối internet';
			case 'serverError': return 'Đã xảy ra lỗi máy chủ';
			default: return null;
		}
	}
}
