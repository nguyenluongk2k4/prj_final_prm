import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../auth/presentation/stores/auth_store.dart';
import '../../../../core/app_stores.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _themeStore = AppStores.instance.themeStore;
  final _localeStore = AppStores.instance.localeStore;
  final _authStore = GetIt.I<AuthStore>();

  bool _pushNotifications = true;
  bool _newMatchNotif = true;
  bool _newMessageNotif = true;

  Future<void> _setLocale(Locale locale) async {
    await _localeStore.setLocale(locale);
    final appLocale = AppLocale.values.firstWhere(
      (l) => l.languageCode == locale.languageCode,
      orElse: () => AppLocale.en,
    );
    LocaleSettings.setLocale(appLocale);
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;

    return AppScaffold(
      titleWidget: Text(
        t.account,
        style: AppTextStyles.h1.copyWith(color: c.textPrimary),
      ),
      showQuickActions: false,
      body: ListView(
        padding: EdgeInsets.only(
          left: 24, 
          right: 24, 
          bottom: 100 + MediaQuery.of(context).padding.bottom
        ),
        children: [
          const SizedBox(height: 24),

          // ── Profile header ──────────────────────────────────────────────
          _ProfileHeader(),

          const SizedBox(height: 32),

          // ── Profile section ─────────────────────────────────────────────
          _SectionHeader(t.myProfile),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.photo_library_outlined,
            label: t.photoAlbum,
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.play_circle_outline_rounded,
            label: t.myReels,
            onTap: () {},
          ),

          const SizedBox(height: 28),

          // ── Preferences section ─────────────────────────────────────────
          _SectionHeader(t.preferences),
          const SizedBox(height: 12),

          // Dark/Light toggle
          Observer(
            builder: (_) => _ToggleTile(
              icon: _themeStore.isDarkMode
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              label: _themeStore.isDarkMode ? t.darkMode : t.lightMode,
              value: _themeStore.isDarkMode,
              onChanged: (v) => _themeStore.setThemeMode(
                v ? ThemeMode.dark : ThemeMode.light,
              ),
            ),
          ),

          // Notifications expand tile
          _NotificationsSection(
            pushNotifications: _pushNotifications,
            newMatch: _newMatchNotif,
            newMessage: _newMessageNotif,
            onPushChanged: (v) => setState(() => _pushNotifications = v),
            onMatchChanged: (v) => setState(() => _newMatchNotif = v),
            onMessageChanged: (v) => setState(() => _newMessageNotif = v),
          ),

          const SizedBox(height: 28),

          // ── Account section ─────────────────────────────────────────────
          _SectionHeader(t.settings),
          const SizedBox(height: 12),

          // Language
          Observer(
            builder: (_) => _SettingsTile(
              icon: Icons.language_outlined,
              label: t.appLanguage,
              trailing: Text(
                _localeStore.currentLocale.languageCode == 'vi'
                    ? 'Tiếng Việt'
                    : 'English',
                style: AppTextStyles.bodySmall.copyWith(color: c.text70),
              ),
              onTap: () => _showLanguagePicker(context, t),
            ),
          ),
          _SettingsTile(
            icon: Icons.lock_outline_rounded,
            label: t.privacy,
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.block_outlined,
            label: t.blockedUsers,
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.logout_rounded,
            label: t.logout,
            iconColor: AppColors.primary,
            labelColor: AppColors.primary,
            onTap: () async {
              await _authStore.logout();
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, Translations t) {
    final c = context.appColors;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: c.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: c.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(t.appLanguage,
                style: AppTextStyles.h3.copyWith(color: c.textPrimary)),
            const SizedBox(height: 20),
            _LangOption(
              label: 'English',
              selected: _localeStore.currentLocale.languageCode == 'en',
              onTap: () {
                _setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
            _LangOption(
              label: 'Tiếng Việt',
              selected: _localeStore.currentLocale.languageCode == 'vi',
              onTap: () {
                _setLocale(const Locale('vi'));
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}

// ─── Profile header ───────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final _authStore = GetIt.I<AuthStore>();

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Translations.of(context);
    
    return Observer(
      builder: (_) {
        final user = _authStore.currentUser;
        final name = user?.name ?? 'Anonymous User';
        final email = user?.email ?? '';
        final avatarUrl = user?.avatarUrl;

        return Column(
          children: [
            Center(
              child: ClipOval(
                child: avatarUrl != null && avatarUrl.isNotEmpty
                    ? Image.network(
                        avatarUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Assets.images.chatActivityYou.image(
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Assets.images.chatActivityYou.image(
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: AppTextStyles.h2.copyWith(color: c.textPrimary),
              textAlign: TextAlign.center,
            ),
            if (email.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  email,
                  style: AppTextStyles.bodyMedium.copyWith(color: c.text70),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: AppPrimaryButton(
                    text: t.editProfile,
                    onPressed: () {
                      context.pushNamed(AppRoutes.editProfileName);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      }
    );
  }
}

// ─── Section header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Text(
      title,
      style: AppTextStyles.bodyLarge.copyWith(
        fontWeight: FontWeight.w700,
        color: c.textPrimary,
      ),
    );
  }
}

// ─── Settings tile ────────────────────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? labelColor;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor ?? AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: labelColor ?? c.textPrimary,
                ),
              ),
            ),
            trailing ??
                Icon(Icons.chevron_right_rounded, color: c.text70, size: 22),
          ],
        ),
      ),
    );
  }
}

// ─── Toggle tile ─────────────────────────────────────────────────────────────

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: c.textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

// ─── Notifications section ────────────────────────────────────────────────────

class _NotificationsSection extends StatefulWidget {
  final bool pushNotifications;
  final bool newMatch;
  final bool newMessage;
  final ValueChanged<bool> onPushChanged;
  final ValueChanged<bool> onMatchChanged;
  final ValueChanged<bool> onMessageChanged;

  const _NotificationsSection({
    required this.pushNotifications,
    required this.newMatch,
    required this.newMessage,
    required this.onPushChanged,
    required this.onMatchChanged,
    required this.onMessageChanged,
  });

  @override
  State<_NotificationsSection> createState() => _NotificationsSectionState();
}

class _NotificationsSectionState extends State<_NotificationsSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;

    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    t.notifications,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: c.textPrimary,
                    ),
                  ),
                ),
                Switch(
                  value: widget.pushNotifications,
                  onChanged: widget.onPushChanged,
                  activeThumbColor: AppColors.primary,
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: c.text70,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(left: 56),
            child: Column(
              children: [
                _SubToggle(
                  label: t.newMatchNotif,
                  value: widget.newMatch,
                  onChanged: widget.onMatchChanged,
                  enabled: widget.pushNotifications,
                ),
                _SubToggle(
                  label: t.newMessageNotif,
                  value: widget.newMessage,
                  onChanged: widget.onMessageChanged,
                  enabled: widget.pushNotifications,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SubToggle extends StatelessWidget {
  final String label;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _SubToggle({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: enabled ? c.textPrimary : c.text70,
              ),
            ),
          ),
          Switch(
            value: value && enabled,
            onChanged: enabled ? onChanged : null,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

// ─── Language option ──────────────────────────────────────────────────────────

class _LangOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LangOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.08)
              : c.backgroundSecondary,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected ? AppColors.primary : c.border,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: selected ? AppColors.primary : c.textPrimary,
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check_rounded,
                  color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
