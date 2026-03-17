/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 400 (200 per locale)
///
/// Built on 2026-03-17 at 15:50 UTC

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
	String get skip => 'Skip';
	String get continueLabel => 'Continue';
	String get myMobileNumber => 'My mobile number';
	String get phoneNumberDesc => 'Please enter your valid phone number. We will send you a 4-digit code to verify your account.';
	String get verificationCode => 'My code is';
	String get verificationDesc => 'This code helps us verify that messages are coming from you.';
	String get profileDetails => 'Profile details';
	String get firstName => 'First name';
	String get lastName => 'Last name';
	String get birthday => 'Birthday';
	String get iAm => 'I am';
	String get woman => 'Woman';
	String get man => 'Man';
	String get other => 'Other';
	String get yourInterests => 'Your interests';
	String get interestsDesc => 'Select a few of your interests and let everyone know what you\'re passionate about.';
	String get searchFriends => 'Search friend\'s';
	String get searchFriendsDesc => 'You can find friends from your contact lists\nto connected';
	String get accessContactList => 'Access to a contact list';
	String get photography => 'Photography';
	String get shopping => 'Shopping';
	String get karaoke => 'Karaoke';
	String get yoga => 'Yoga';
	String get cooking => 'Cooking';
	String get tennis => 'Tennis';
	String get run => 'Run';
	String get swimming => 'Swimming';
	String get art => 'Art';
	String get traveling => 'Traveling';
	String get extreme => 'Extreme';
	String get music => 'Music';
	String get drink => 'Drink';
	String get videoGames => 'Video games';
	String get enableNotifications => 'Enable notification\'s';
	String get notificationDesc => 'Get push-notification when you get the match or receive a message.';
	String get iWantToBeNotified => 'I want to be notified';
	String get discover => 'Discover';
	String get professionalModel => 'Professional model';
	String get itsAMatch => 'It\'s a match, Jake!';
	String get startConversation => 'Start a conversation now with each other';
	String get sayHello => 'Say hello';
	String get keepSwiping => 'Keep swiping';
	String get matches => 'Matches';
	String get matchesDesc => 'This is a list of people who have liked you and your matches.';
	String get today => 'Today';
	String get yesterday => 'Yesterday';
	String get like => 'Like';
	String get dislike => 'Dislike';
	String get myEmail => 'My email';
	String get emailLoginDesc => 'Please enter your email and password to continue.';
	String get emailHint => 'Enter your email address';
	String get passwordHint => 'Enter your password';
	String get forgotPassword => 'Forgot password?';
	String get noAccount => 'Don\'t have an account?';
	String get signUpNow => 'Sign up';
	String get invalidEmail => 'Please enter a valid email';
	String get createAccount => 'Create account';
	String get createAccountDesc => 'Fill in your details to get started.';
	String get fullName => 'Full name';
	String get fullNameHint => 'Enter your full name';
	String get confirmPassword => 'Confirm password';
	String get confirmPasswordHint => 'Re-enter your password';
	String get passwordMinLength => 'Password must be at least 6 characters';
	String get passwordsDoNotMatch => 'Passwords do not match';
	String get nameRequired => 'Name is required';
	String get emailRequired => 'Email is required';
	String get passwordRequired => 'Password is required';
	String get confirmPasswordRequired => 'Please confirm password';
	String get alreadyHaveAccount => 'Already have an account?';
	String get signIn => 'Sign in';
	String get pleaseEnterFullName => 'Please enter your full name';
	String get messages => 'Messages';
	String get activities => 'Activities';
	String get typing => 'Typing..';
	String get searchMessages => 'Search';
	String get filters => 'Filters';
	String get clear => 'Clear';
	String get interestedIn => 'Interested in';
	String get girls => 'Girls';
	String get boys => 'Boys';
	String get both => 'Both';
	String get location => 'Location';
	String get distance => 'Distance';
	String get age => 'Age';
	String get account => 'Account';
	String get editProfile => 'Edit profile';
	String get myProfile => 'My profile';
	String get photoAlbum => 'Photo album';
	String get myReels => 'My reels';
	String get preferences => 'Preferences';
	String get notifications => 'Notifications';
	String get pushNotifications => 'Push notifications';
	String get newMatchNotif => 'New matches';
	String get newMessageNotif => 'New messages';
	String get appLanguage => 'App language';
	String get privacy => 'Privacy';
	String get blockedUsers => 'Blocked users';
	String get deleteAccount => 'Delete account';
	String get onboarding1Title => 'Algorithm';
	String get onboarding1Desc => 'Users going through a vetting process to ensure you never match with bots.';
	String get onboarding2Title => 'Matches';
	String get onboarding2Desc => 'We match you with people that have a large array of similar interests.';
	String get onboarding3Title => 'Premium';
	String get onboarding3Desc => 'Sign up today and enjoy the first month of premium benefits on us.';
	String get createAnAccount => 'Create an account';
	String get alreadyHaveAccountSignIn => 'Already have an account? Sign In';
	String get signUpToContinue => 'Sign up to continue';
	String get continueWithEmail => 'Continue with email';
	String get usePhoneNumber => 'Use phone number';
	String get orSignUpWith => 'or sign up with';
	String get orLoginWith => 'or login with';
	String get continueWithGoogle => 'Continue with Google';
	String get termsOfUse => 'Terms of use';
	String get privacyPolicy => 'Privacy Policy';
	String get bio => 'Bio';
	String get yourGender => 'Your Gender';
	String get lookingFor => 'Looking for';
	String get selectGender => 'Select gender';
	String get saveChanges => 'Save Changes';
	String get male => 'Male';
	String get female => 'Female';
	String get uploadNewPicture => 'Upload new picture';
	String get friendList => 'Friend List';
	String get about => 'About';
	String get interests => 'Interests';
	String get gallery => 'Gallery';
	String get readMore => 'Read more';
	String get showLess => 'Show less';
	String get myFriends => 'My Friends';
	String get anonymousUser => 'Anonymous User';
	String get noBio => 'No biography available.';
	String get distanceUnit => 'km';
	String get userTitle => 'User';
	String get noInterests => 'No interests listed';
	String get yourMessageHint => 'Your message';
	String get photo => 'Photo';
	String get imageLabel => 'Image';
	String get fileLabel => 'File';
	String downloadLabel({required Object label}) => 'Download ${label}';
	String downloadedTo({required Object path}) => 'Downloaded to ${path}';
	String get failedToDownloadFile => 'Failed to download file';
	String get failedToUploadImage => 'Failed to upload image';
	String get failedToUploadFile => 'Failed to upload file';
	String get failedToSendMessage => 'Failed to send message';
	String get userIdNotAvailableForCalling => 'User ID not available for calling';
	String get longPressToDownload => 'Long press to download';
	String get holdToRecordAudioMessage => 'Hold to record audio message (Tencent SDK)';
	String get activeNow => 'Active now';
	String get offline => 'Offline';
	String activeTimeAgo({required Object time}) => 'Active ${time}';
	String get chatNow => 'Chat now';
	String get you => 'You';
	String get sentImage => 'sent a photo';
	String get sentFile => 'sent a file';
	String get sentVoice => 'sent a voice message';
	String get retry => 'Retry';
	String get albumEmpty => 'Your album is empty';
	String get uploadPhoto => 'Upload Photo';
	String get deletePhoto => 'Delete Photo';
	String get deletePhotoConfirm => 'Are you sure you want to delete this photo?';
	String get viewProfile => 'View Profile';
	String get seeAll => 'See all';
	String get resetPassword => 'Reset password';
	String get resetPasswordDesc => 'Enter your email and we\'ll send you a link to reset your password.';
	String get sendResetLink => 'Send reset link';
	String get resetLinkSent => 'Password reset link sent! Check your email.';
	String get backToLogin => 'Back to login';
	String get changePassword => 'Change password';
	String get currentPassword => 'Current password';
	String get newPassword => 'New password';
	String get confirmNewPassword => 'Confirm new password';
	String get passwordChanged => 'Password changed successfully!';
	String get newPasswordHint => 'Enter new password';
	String get confirmNewPasswordHint => 'Re-enter new password';
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
	@override String get skip => 'Bỏ qua';
	@override String get continueLabel => 'Tiếp tục';
	@override String get myMobileNumber => 'Số điện thoại của tôi';
	@override String get phoneNumberDesc => 'Vui lòng nhập số điện thoại hợp lệ. Chúng tôi sẽ gửi mã 4 chữ số để xác minh tài khoản của bạn.';
	@override String get verificationCode => 'Mã của tôi là';
	@override String get verificationDesc => 'Mã này giúp chúng tôi xác minh rằng tin nhắn đang đến từ bạn.';
	@override String get profileDetails => 'Chi tiết hồ sơ';
	@override String get firstName => 'Tên';
	@override String get lastName => 'Họ';
	@override String get birthday => 'Ngày sinh';
	@override String get iAm => 'Tôi là';
	@override String get woman => 'Nữ';
	@override String get man => 'Nam';
	@override String get other => 'Khác';
	@override String get yourInterests => 'Sở thích của bạn';
	@override String get interestsDesc => 'Chọn một vài sở thích và cho mọi người biết bạn đam mê điều gì.';
	@override String get searchFriends => 'Tìm bạn bè';
	@override String get searchFriendsDesc => 'Bạn có thể tìm bạn bè từ danh bạ\nđể kết nối';
	@override String get accessContactList => 'Truy cập danh bạ';
	@override String get photography => 'Nhiếp ảnh';
	@override String get shopping => 'Mua sắm';
	@override String get karaoke => 'Karaoke';
	@override String get yoga => 'Yoga';
	@override String get cooking => 'Nấu ăn';
	@override String get tennis => 'Quần vợt';
	@override String get run => 'Chạy bộ';
	@override String get swimming => 'Bơi lội';
	@override String get art => 'Nghệ thuật';
	@override String get traveling => 'Du lịch';
	@override String get extreme => 'Mạo hiểm';
	@override String get music => 'Âm nhạc';
	@override String get drink => 'Đồ uống';
	@override String get videoGames => 'Trò chơi điện tử';
	@override String get enableNotifications => 'Bật thông báo';
	@override String get notificationDesc => 'Nhận thông báo đẩy khi bạn có kết nối hoặc nhận tin nhắn.';
	@override String get iWantToBeNotified => 'Tôi muốn nhận thông báo';
	@override String get discover => 'Khám phá';
	@override String get professionalModel => 'Người mẫu chuyên nghiệp';
	@override String get itsAMatch => 'Đã ghép đôi, Jake!';
	@override String get startConversation => 'Bắt đầu cuộc trò chuyện với nhau ngay bây giờ';
	@override String get sayHello => 'Chào hỏi';
	@override String get keepSwiping => 'Tiếp tục vuốt';
	@override String get matches => 'Kết nối';
	@override String get matchesDesc => 'Đây là danh sách những người đã thích bạn và các kết nối của bạn.';
	@override String get today => 'Hôm nay';
	@override String get yesterday => 'Hôm qua';
	@override String get like => 'Thích';
	@override String get dislike => 'Bỏ qua';
	@override String get myEmail => 'Email của tôi';
	@override String get emailLoginDesc => 'Vui lòng nhập email và mật khẩu để tiếp tục.';
	@override String get emailHint => 'Nhập địa chỉ email';
	@override String get passwordHint => 'Nhập mật khẩu';
	@override String get forgotPassword => 'Quên mật khẩu?';
	@override String get noAccount => 'Chưa có tài khoản?';
	@override String get signUpNow => 'Đăng ký';
	@override String get invalidEmail => 'Vui lòng nhập email hợp lệ';
	@override String get createAccount => 'Tạo tài khoản';
	@override String get createAccountDesc => 'Nhập thông tin của bạn để bắt đầu.';
	@override String get fullName => 'Họ và tên';
	@override String get fullNameHint => 'Nhập họ và tên';
	@override String get confirmPassword => 'Xác nhập mật khẩu';
	@override String get confirmPasswordHint => 'Nhập lại mật khẩu';
	@override String get passwordMinLength => 'Mật khẩu phải có ít nhất 6 ký tự';
	@override String get passwordsDoNotMatch => 'Mật khẩu không khớp';
	@override String get nameRequired => 'Vui lòng nhập tên';
	@override String get emailRequired => 'Vui lòng nhập email';
	@override String get passwordRequired => 'Vui lòng nhập mật khẩu';
	@override String get confirmPasswordRequired => 'Vui lòng xác nhận mật khẩu';
	@override String get alreadyHaveAccount => 'Đã có tài khoản?';
	@override String get signIn => 'Đăng nhập';
	@override String get pleaseEnterFullName => 'Vui lòng nhập họ và tên';
	@override String get messages => 'Tin nhắn';
	@override String get activities => 'Hoạt động';
	@override String get typing => 'Đang gõ..';
	@override String get searchMessages => 'Tìm kiếm';
	@override String get filters => 'Bộ lọc';
	@override String get clear => 'Xóa';
	@override String get interestedIn => 'Quan tâm đến';
	@override String get girls => 'Nữ';
	@override String get boys => 'Nam';
	@override String get both => 'Tất cả';
	@override String get location => 'Vị trí';
	@override String get distance => 'Khoảng cách';
	@override String get age => 'Độ tuổi';
	@override String get account => 'Tài khoản';
	@override String get editProfile => 'Chỉnh sửa hồ sơ';
	@override String get myProfile => 'Hồ sơ của tôi';
	@override String get photoAlbum => 'Album ảnh';
	@override String get myReels => 'Reels của tôi';
	@override String get preferences => 'Tuỳ chỉnh';
	@override String get notifications => 'Thông báo';
	@override String get pushNotifications => 'Thông báo đẩy';
	@override String get newMatchNotif => 'Kết nối mới';
	@override String get newMessageNotif => 'Tin nhắn mới';
	@override String get appLanguage => 'Ngôn ngữ ứng dụng';
	@override String get privacy => 'Quyền riêng tư';
	@override String get blockedUsers => 'Người dùng bị chặn';
	@override String get deleteAccount => 'Xóa tài khoản';
	@override String get onboarding1Title => 'Thuật toán';
	@override String get onboarding1Desc => 'Người dùng trải qua quy trình xác minh để đảm bảo bạn không bao giờ ghép đôi với bot.';
	@override String get onboarding2Title => 'Kết nối';
	@override String get onboarding2Desc => 'Chúng tôi ghép bạn với những người có nhiều sở thích tương đồng.';
	@override String get onboarding3Title => 'Cao cấp';
	@override String get onboarding3Desc => 'Đăng ký ngay hôm nay và tận hưởng tháng đầu tiên ưu đãi cao cấp miễn phí.';
	@override String get createAnAccount => 'Tạo tài khoản';
	@override String get alreadyHaveAccountSignIn => 'Đã có tài khoản? Đăng nhập';
	@override String get signUpToContinue => 'Đăng ký để tiếp tục';
	@override String get continueWithEmail => 'Tiếp tục với email';
	@override String get usePhoneNumber => 'Dùng số điện thoại';
	@override String get orSignUpWith => 'hoặc đăng ký với';
	@override String get orLoginWith => 'hoặc đăng nhập với';
	@override String get continueWithGoogle => 'Tiếp tục với Google';
	@override String get termsOfUse => 'Điều khoản sử dụng';
	@override String get privacyPolicy => 'Chính sách bảo mật';
	@override String get bio => 'Tiểu sử';
	@override String get yourGender => 'Giới tính của bạn';
	@override String get lookingFor => 'Đang tìm kiếm';
	@override String get selectGender => 'Chọn giới tính';
	@override String get saveChanges => 'Lưu thay đổi';
	@override String get male => 'Nam';
	@override String get female => 'Nữ';
	@override String get uploadNewPicture => 'Tải ảnh mới lên';
	@override String get friendList => 'Danh sách bạn bè';
	@override String get about => 'Giới thiệu';
	@override String get interests => 'Sở thích';
	@override String get gallery => 'Bộ sưu tập';
	@override String get readMore => 'Xem thêm';
	@override String get showLess => 'Rút gọn';
	@override String get myFriends => 'Bạn bè của tôi';
	@override String get anonymousUser => 'Người dùng ẩn danh';
	@override String get noBio => 'Chưa có tiểu sử.';
	@override String get distanceUnit => 'km';
	@override String get userTitle => 'Người dùng';
	@override String get noInterests => 'Chưa có sở thích';
	@override String get yourMessageHint => 'Nhập tin nhắn';
	@override String get photo => 'Ảnh';
	@override String get imageLabel => 'Ảnh';
	@override String get fileLabel => 'Tệp';
	@override String downloadLabel({required Object label}) => 'Tải xuống ${label}';
	@override String downloadedTo({required Object path}) => 'Đã tải xuống: ${path}';
	@override String get failedToDownloadFile => 'Tải xuống tệp thất bại';
	@override String get failedToUploadImage => 'Tải ảnh lên thất bại';
	@override String get failedToUploadFile => 'Tải tệp lên thất bại';
	@override String get failedToSendMessage => 'Gửi tin nhắn thất bại';
	@override String get userIdNotAvailableForCalling => 'Không có ID người dùng để gọi';
	@override String get longPressToDownload => 'Nhấn giữ để tải xuống';
	@override String get holdToRecordAudioMessage => 'Giữ để ghi âm (Tencent SDK)';
	@override String get activeNow => 'Đang hoạt động';
	@override String get offline => 'Ngoại tuyến';
	@override String activeTimeAgo({required Object time}) => 'Hoạt động ${time}';
	@override String get chatNow => 'Nhắn tin ngay';
	@override String get you => 'Bạn';
	@override String get sentImage => 'đã gửi 1 ảnh';
	@override String get sentFile => 'đã gửi 1 tệp đính kèm';
	@override String get sentVoice => 'đã gửi 1 tin nhắn thoại';
	@override String get retry => 'Thử lại';
	@override String get albumEmpty => 'Album của bạn đang trống';
	@override String get uploadPhoto => 'Tải ảnh lên';
	@override String get deletePhoto => 'Xóa ảnh';
	@override String get deletePhotoConfirm => 'Bạn có chắc chắn muốn xóa ảnh này không?';
	@override String get viewProfile => 'Xem hồ sơ';
	@override String get seeAll => 'Tất cả';
	@override String get resetPassword => 'Đặt lại mật khẩu';
	@override String get resetPasswordDesc => 'Nhập email và chúng tôi sẽ gửi cho bạn liên kết để đặt lại mật khẩu.';
	@override String get sendResetLink => 'Gửi liên kết đặt lại';
	@override String get resetLinkSent => 'Đã gửi liên kết đặt lại mật khẩu! Kiểm tra email của bạn.';
	@override String get backToLogin => 'Quay lại đăng nhập';
	@override String get changePassword => 'Đổi mật khẩu';
	@override String get currentPassword => 'Mật khẩu hiện tại';
	@override String get newPassword => 'Mật khẩu mới';
	@override String get confirmNewPassword => 'Xác nhận mật khẩu mới';
	@override String get passwordChanged => 'Đổi mật khẩu thành công!';
	@override String get newPasswordHint => 'Nhập mật khẩu mới';
	@override String get confirmNewPasswordHint => 'Nhập lại mật khẩu mới';
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
			case 'skip': return 'Skip';
			case 'continueLabel': return 'Continue';
			case 'myMobileNumber': return 'My mobile number';
			case 'phoneNumberDesc': return 'Please enter your valid phone number. We will send you a 4-digit code to verify your account.';
			case 'verificationCode': return 'My code is';
			case 'verificationDesc': return 'This code helps us verify that messages are coming from you.';
			case 'profileDetails': return 'Profile details';
			case 'firstName': return 'First name';
			case 'lastName': return 'Last name';
			case 'birthday': return 'Birthday';
			case 'iAm': return 'I am';
			case 'woman': return 'Woman';
			case 'man': return 'Man';
			case 'other': return 'Other';
			case 'yourInterests': return 'Your interests';
			case 'interestsDesc': return 'Select a few of your interests and let everyone know what you\'re passionate about.';
			case 'searchFriends': return 'Search friend\'s';
			case 'searchFriendsDesc': return 'You can find friends from your contact lists\nto connected';
			case 'accessContactList': return 'Access to a contact list';
			case 'photography': return 'Photography';
			case 'shopping': return 'Shopping';
			case 'karaoke': return 'Karaoke';
			case 'yoga': return 'Yoga';
			case 'cooking': return 'Cooking';
			case 'tennis': return 'Tennis';
			case 'run': return 'Run';
			case 'swimming': return 'Swimming';
			case 'art': return 'Art';
			case 'traveling': return 'Traveling';
			case 'extreme': return 'Extreme';
			case 'music': return 'Music';
			case 'drink': return 'Drink';
			case 'videoGames': return 'Video games';
			case 'enableNotifications': return 'Enable notification\'s';
			case 'notificationDesc': return 'Get push-notification when you get the match or receive a message.';
			case 'iWantToBeNotified': return 'I want to be notified';
			case 'discover': return 'Discover';
			case 'professionalModel': return 'Professional model';
			case 'itsAMatch': return 'It\'s a match, Jake!';
			case 'startConversation': return 'Start a conversation now with each other';
			case 'sayHello': return 'Say hello';
			case 'keepSwiping': return 'Keep swiping';
			case 'matches': return 'Matches';
			case 'matchesDesc': return 'This is a list of people who have liked you and your matches.';
			case 'today': return 'Today';
			case 'yesterday': return 'Yesterday';
			case 'like': return 'Like';
			case 'dislike': return 'Dislike';
			case 'myEmail': return 'My email';
			case 'emailLoginDesc': return 'Please enter your email and password to continue.';
			case 'emailHint': return 'Enter your email address';
			case 'passwordHint': return 'Enter your password';
			case 'forgotPassword': return 'Forgot password?';
			case 'noAccount': return 'Don\'t have an account?';
			case 'signUpNow': return 'Sign up';
			case 'invalidEmail': return 'Please enter a valid email';
			case 'createAccount': return 'Create account';
			case 'createAccountDesc': return 'Fill in your details to get started.';
			case 'fullName': return 'Full name';
			case 'fullNameHint': return 'Enter your full name';
			case 'confirmPassword': return 'Confirm password';
			case 'confirmPasswordHint': return 'Re-enter your password';
			case 'passwordMinLength': return 'Password must be at least 6 characters';
			case 'passwordsDoNotMatch': return 'Passwords do not match';
			case 'nameRequired': return 'Name is required';
			case 'emailRequired': return 'Email is required';
			case 'passwordRequired': return 'Password is required';
			case 'confirmPasswordRequired': return 'Please confirm password';
			case 'alreadyHaveAccount': return 'Already have an account?';
			case 'signIn': return 'Sign in';
			case 'pleaseEnterFullName': return 'Please enter your full name';
			case 'messages': return 'Messages';
			case 'activities': return 'Activities';
			case 'typing': return 'Typing..';
			case 'searchMessages': return 'Search';
			case 'filters': return 'Filters';
			case 'clear': return 'Clear';
			case 'interestedIn': return 'Interested in';
			case 'girls': return 'Girls';
			case 'boys': return 'Boys';
			case 'both': return 'Both';
			case 'location': return 'Location';
			case 'distance': return 'Distance';
			case 'age': return 'Age';
			case 'account': return 'Account';
			case 'editProfile': return 'Edit profile';
			case 'myProfile': return 'My profile';
			case 'photoAlbum': return 'Photo album';
			case 'myReels': return 'My reels';
			case 'preferences': return 'Preferences';
			case 'notifications': return 'Notifications';
			case 'pushNotifications': return 'Push notifications';
			case 'newMatchNotif': return 'New matches';
			case 'newMessageNotif': return 'New messages';
			case 'appLanguage': return 'App language';
			case 'privacy': return 'Privacy';
			case 'blockedUsers': return 'Blocked users';
			case 'deleteAccount': return 'Delete account';
			case 'onboarding1Title': return 'Algorithm';
			case 'onboarding1Desc': return 'Users going through a vetting process to ensure you never match with bots.';
			case 'onboarding2Title': return 'Matches';
			case 'onboarding2Desc': return 'We match you with people that have a large array of similar interests.';
			case 'onboarding3Title': return 'Premium';
			case 'onboarding3Desc': return 'Sign up today and enjoy the first month of premium benefits on us.';
			case 'createAnAccount': return 'Create an account';
			case 'alreadyHaveAccountSignIn': return 'Already have an account? Sign In';
			case 'signUpToContinue': return 'Sign up to continue';
			case 'continueWithEmail': return 'Continue with email';
			case 'usePhoneNumber': return 'Use phone number';
			case 'orSignUpWith': return 'or sign up with';
			case 'orLoginWith': return 'or login with';
			case 'continueWithGoogle': return 'Continue with Google';
			case 'termsOfUse': return 'Terms of use';
			case 'privacyPolicy': return 'Privacy Policy';
			case 'bio': return 'Bio';
			case 'yourGender': return 'Your Gender';
			case 'lookingFor': return 'Looking for';
			case 'selectGender': return 'Select gender';
			case 'saveChanges': return 'Save Changes';
			case 'male': return 'Male';
			case 'female': return 'Female';
			case 'uploadNewPicture': return 'Upload new picture';
			case 'friendList': return 'Friend List';
			case 'about': return 'About';
			case 'interests': return 'Interests';
			case 'gallery': return 'Gallery';
			case 'readMore': return 'Read more';
			case 'showLess': return 'Show less';
			case 'myFriends': return 'My Friends';
			case 'anonymousUser': return 'Anonymous User';
			case 'noBio': return 'No biography available.';
			case 'distanceUnit': return 'km';
			case 'userTitle': return 'User';
			case 'noInterests': return 'No interests listed';
			case 'yourMessageHint': return 'Your message';
			case 'photo': return 'Photo';
			case 'imageLabel': return 'Image';
			case 'fileLabel': return 'File';
			case 'downloadLabel': return ({required Object label}) => 'Download ${label}';
			case 'downloadedTo': return ({required Object path}) => 'Downloaded to ${path}';
			case 'failedToDownloadFile': return 'Failed to download file';
			case 'failedToUploadImage': return 'Failed to upload image';
			case 'failedToUploadFile': return 'Failed to upload file';
			case 'failedToSendMessage': return 'Failed to send message';
			case 'userIdNotAvailableForCalling': return 'User ID not available for calling';
			case 'longPressToDownload': return 'Long press to download';
			case 'holdToRecordAudioMessage': return 'Hold to record audio message (Tencent SDK)';
			case 'activeNow': return 'Active now';
			case 'offline': return 'Offline';
			case 'activeTimeAgo': return ({required Object time}) => 'Active ${time}';
			case 'chatNow': return 'Chat now';
			case 'you': return 'You';
			case 'sentImage': return 'sent a photo';
			case 'sentFile': return 'sent a file';
			case 'sentVoice': return 'sent a voice message';
			case 'retry': return 'Retry';
			case 'albumEmpty': return 'Your album is empty';
			case 'uploadPhoto': return 'Upload Photo';
			case 'deletePhoto': return 'Delete Photo';
			case 'deletePhotoConfirm': return 'Are you sure you want to delete this photo?';
			case 'viewProfile': return 'View Profile';
			case 'seeAll': return 'See all';
			case 'resetPassword': return 'Reset password';
			case 'resetPasswordDesc': return 'Enter your email and we\'ll send you a link to reset your password.';
			case 'sendResetLink': return 'Send reset link';
			case 'resetLinkSent': return 'Password reset link sent! Check your email.';
			case 'backToLogin': return 'Back to login';
			case 'changePassword': return 'Change password';
			case 'currentPassword': return 'Current password';
			case 'newPassword': return 'New password';
			case 'confirmNewPassword': return 'Confirm new password';
			case 'passwordChanged': return 'Password changed successfully!';
			case 'newPasswordHint': return 'Enter new password';
			case 'confirmNewPasswordHint': return 'Re-enter new password';
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
			case 'skip': return 'Bỏ qua';
			case 'continueLabel': return 'Tiếp tục';
			case 'myMobileNumber': return 'Số điện thoại của tôi';
			case 'phoneNumberDesc': return 'Vui lòng nhập số điện thoại hợp lệ. Chúng tôi sẽ gửi mã 4 chữ số để xác minh tài khoản của bạn.';
			case 'verificationCode': return 'Mã của tôi là';
			case 'verificationDesc': return 'Mã này giúp chúng tôi xác minh rằng tin nhắn đang đến từ bạn.';
			case 'profileDetails': return 'Chi tiết hồ sơ';
			case 'firstName': return 'Tên';
			case 'lastName': return 'Họ';
			case 'birthday': return 'Ngày sinh';
			case 'iAm': return 'Tôi là';
			case 'woman': return 'Nữ';
			case 'man': return 'Nam';
			case 'other': return 'Khác';
			case 'yourInterests': return 'Sở thích của bạn';
			case 'interestsDesc': return 'Chọn một vài sở thích và cho mọi người biết bạn đam mê điều gì.';
			case 'searchFriends': return 'Tìm bạn bè';
			case 'searchFriendsDesc': return 'Bạn có thể tìm bạn bè từ danh bạ\nđể kết nối';
			case 'accessContactList': return 'Truy cập danh bạ';
			case 'photography': return 'Nhiếp ảnh';
			case 'shopping': return 'Mua sắm';
			case 'karaoke': return 'Karaoke';
			case 'yoga': return 'Yoga';
			case 'cooking': return 'Nấu ăn';
			case 'tennis': return 'Quần vợt';
			case 'run': return 'Chạy bộ';
			case 'swimming': return 'Bơi lội';
			case 'art': return 'Nghệ thuật';
			case 'traveling': return 'Du lịch';
			case 'extreme': return 'Mạo hiểm';
			case 'music': return 'Âm nhạc';
			case 'drink': return 'Đồ uống';
			case 'videoGames': return 'Trò chơi điện tử';
			case 'enableNotifications': return 'Bật thông báo';
			case 'notificationDesc': return 'Nhận thông báo đẩy khi bạn có kết nối hoặc nhận tin nhắn.';
			case 'iWantToBeNotified': return 'Tôi muốn nhận thông báo';
			case 'discover': return 'Khám phá';
			case 'professionalModel': return 'Người mẫu chuyên nghiệp';
			case 'itsAMatch': return 'Đã ghép đôi, Jake!';
			case 'startConversation': return 'Bắt đầu cuộc trò chuyện với nhau ngay bây giờ';
			case 'sayHello': return 'Chào hỏi';
			case 'keepSwiping': return 'Tiếp tục vuốt';
			case 'matches': return 'Kết nối';
			case 'matchesDesc': return 'Đây là danh sách những người đã thích bạn và các kết nối của bạn.';
			case 'today': return 'Hôm nay';
			case 'yesterday': return 'Hôm qua';
			case 'like': return 'Thích';
			case 'dislike': return 'Bỏ qua';
			case 'myEmail': return 'Email của tôi';
			case 'emailLoginDesc': return 'Vui lòng nhập email và mật khẩu để tiếp tục.';
			case 'emailHint': return 'Nhập địa chỉ email';
			case 'passwordHint': return 'Nhập mật khẩu';
			case 'forgotPassword': return 'Quên mật khẩu?';
			case 'noAccount': return 'Chưa có tài khoản?';
			case 'signUpNow': return 'Đăng ký';
			case 'invalidEmail': return 'Vui lòng nhập email hợp lệ';
			case 'createAccount': return 'Tạo tài khoản';
			case 'createAccountDesc': return 'Nhập thông tin của bạn để bắt đầu.';
			case 'fullName': return 'Họ và tên';
			case 'fullNameHint': return 'Nhập họ và tên';
			case 'confirmPassword': return 'Xác nhập mật khẩu';
			case 'confirmPasswordHint': return 'Nhập lại mật khẩu';
			case 'passwordMinLength': return 'Mật khẩu phải có ít nhất 6 ký tự';
			case 'passwordsDoNotMatch': return 'Mật khẩu không khớp';
			case 'nameRequired': return 'Vui lòng nhập tên';
			case 'emailRequired': return 'Vui lòng nhập email';
			case 'passwordRequired': return 'Vui lòng nhập mật khẩu';
			case 'confirmPasswordRequired': return 'Vui lòng xác nhận mật khẩu';
			case 'alreadyHaveAccount': return 'Đã có tài khoản?';
			case 'signIn': return 'Đăng nhập';
			case 'pleaseEnterFullName': return 'Vui lòng nhập họ và tên';
			case 'messages': return 'Tin nhắn';
			case 'activities': return 'Hoạt động';
			case 'typing': return 'Đang gõ..';
			case 'searchMessages': return 'Tìm kiếm';
			case 'filters': return 'Bộ lọc';
			case 'clear': return 'Xóa';
			case 'interestedIn': return 'Quan tâm đến';
			case 'girls': return 'Nữ';
			case 'boys': return 'Nam';
			case 'both': return 'Tất cả';
			case 'location': return 'Vị trí';
			case 'distance': return 'Khoảng cách';
			case 'age': return 'Độ tuổi';
			case 'account': return 'Tài khoản';
			case 'editProfile': return 'Chỉnh sửa hồ sơ';
			case 'myProfile': return 'Hồ sơ của tôi';
			case 'photoAlbum': return 'Album ảnh';
			case 'myReels': return 'Reels của tôi';
			case 'preferences': return 'Tuỳ chỉnh';
			case 'notifications': return 'Thông báo';
			case 'pushNotifications': return 'Thông báo đẩy';
			case 'newMatchNotif': return 'Kết nối mới';
			case 'newMessageNotif': return 'Tin nhắn mới';
			case 'appLanguage': return 'Ngôn ngữ ứng dụng';
			case 'privacy': return 'Quyền riêng tư';
			case 'blockedUsers': return 'Người dùng bị chặn';
			case 'deleteAccount': return 'Xóa tài khoản';
			case 'onboarding1Title': return 'Thuật toán';
			case 'onboarding1Desc': return 'Người dùng trải qua quy trình xác minh để đảm bảo bạn không bao giờ ghép đôi với bot.';
			case 'onboarding2Title': return 'Kết nối';
			case 'onboarding2Desc': return 'Chúng tôi ghép bạn với những người có nhiều sở thích tương đồng.';
			case 'onboarding3Title': return 'Cao cấp';
			case 'onboarding3Desc': return 'Đăng ký ngay hôm nay và tận hưởng tháng đầu tiên ưu đãi cao cấp miễn phí.';
			case 'createAnAccount': return 'Tạo tài khoản';
			case 'alreadyHaveAccountSignIn': return 'Đã có tài khoản? Đăng nhập';
			case 'signUpToContinue': return 'Đăng ký để tiếp tục';
			case 'continueWithEmail': return 'Tiếp tục với email';
			case 'usePhoneNumber': return 'Dùng số điện thoại';
			case 'orSignUpWith': return 'hoặc đăng ký với';
			case 'orLoginWith': return 'hoặc đăng nhập với';
			case 'continueWithGoogle': return 'Tiếp tục với Google';
			case 'termsOfUse': return 'Điều khoản sử dụng';
			case 'privacyPolicy': return 'Chính sách bảo mật';
			case 'bio': return 'Tiểu sử';
			case 'yourGender': return 'Giới tính của bạn';
			case 'lookingFor': return 'Đang tìm kiếm';
			case 'selectGender': return 'Chọn giới tính';
			case 'saveChanges': return 'Lưu thay đổi';
			case 'male': return 'Nam';
			case 'female': return 'Nữ';
			case 'uploadNewPicture': return 'Tải ảnh mới lên';
			case 'friendList': return 'Danh sách bạn bè';
			case 'about': return 'Giới thiệu';
			case 'interests': return 'Sở thích';
			case 'gallery': return 'Bộ sưu tập';
			case 'readMore': return 'Xem thêm';
			case 'showLess': return 'Rút gọn';
			case 'myFriends': return 'Bạn bè của tôi';
			case 'anonymousUser': return 'Người dùng ẩn danh';
			case 'noBio': return 'Chưa có tiểu sử.';
			case 'distanceUnit': return 'km';
			case 'userTitle': return 'Người dùng';
			case 'noInterests': return 'Chưa có sở thích';
			case 'yourMessageHint': return 'Nhập tin nhắn';
			case 'photo': return 'Ảnh';
			case 'imageLabel': return 'Ảnh';
			case 'fileLabel': return 'Tệp';
			case 'downloadLabel': return ({required Object label}) => 'Tải xuống ${label}';
			case 'downloadedTo': return ({required Object path}) => 'Đã tải xuống: ${path}';
			case 'failedToDownloadFile': return 'Tải xuống tệp thất bại';
			case 'failedToUploadImage': return 'Tải ảnh lên thất bại';
			case 'failedToUploadFile': return 'Tải tệp lên thất bại';
			case 'failedToSendMessage': return 'Gửi tin nhắn thất bại';
			case 'userIdNotAvailableForCalling': return 'Không có ID người dùng để gọi';
			case 'longPressToDownload': return 'Nhấn giữ để tải xuống';
			case 'holdToRecordAudioMessage': return 'Giữ để ghi âm (Tencent SDK)';
			case 'activeNow': return 'Đang hoạt động';
			case 'offline': return 'Ngoại tuyến';
			case 'activeTimeAgo': return ({required Object time}) => 'Hoạt động ${time}';
			case 'chatNow': return 'Nhắn tin ngay';
			case 'you': return 'Bạn';
			case 'sentImage': return 'đã gửi 1 ảnh';
			case 'sentFile': return 'đã gửi 1 tệp đính kèm';
			case 'sentVoice': return 'đã gửi 1 tin nhắn thoại';
			case 'retry': return 'Thử lại';
			case 'albumEmpty': return 'Album của bạn đang trống';
			case 'uploadPhoto': return 'Tải ảnh lên';
			case 'deletePhoto': return 'Xóa ảnh';
			case 'deletePhotoConfirm': return 'Bạn có chắc chắn muốn xóa ảnh này không?';
			case 'viewProfile': return 'Xem hồ sơ';
			case 'seeAll': return 'Tất cả';
			case 'resetPassword': return 'Đặt lại mật khẩu';
			case 'resetPasswordDesc': return 'Nhập email và chúng tôi sẽ gửi cho bạn liên kết để đặt lại mật khẩu.';
			case 'sendResetLink': return 'Gửi liên kết đặt lại';
			case 'resetLinkSent': return 'Đã gửi liên kết đặt lại mật khẩu! Kiểm tra email của bạn.';
			case 'backToLogin': return 'Quay lại đăng nhập';
			case 'changePassword': return 'Đổi mật khẩu';
			case 'currentPassword': return 'Mật khẩu hiện tại';
			case 'newPassword': return 'Mật khẩu mới';
			case 'confirmNewPassword': return 'Xác nhận mật khẩu mới';
			case 'passwordChanged': return 'Đổi mật khẩu thành công!';
			case 'newPasswordHint': return 'Nhập mật khẩu mới';
			case 'confirmNewPasswordHint': return 'Nhập lại mật khẩu mới';
			default: return null;
		}
	}
}
