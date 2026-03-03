import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/app_button.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../i18n/strings.g.dart';

void showChatFilterSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _ChatFilterSheet(),
  );
}

class _ChatFilterSheet extends StatefulWidget {
  const _ChatFilterSheet();

  @override
  State<_ChatFilterSheet> createState() => _ChatFilterSheetState();
}

class _ChatFilterSheetState extends State<_ChatFilterSheet> {
  int _interestedIndex = 0; // 0=Girls, 1=Boys, 2=Both
  double _distance = 40;
  RangeValues _ageRange = const RangeValues(20, 28);
  final TextEditingController _locationCtrl =
      TextEditingController(text: 'Chicago, USA');

  @override
  void dispose() {
    _locationCtrl.dispose();
    super.dispose();
  }

  void _clear() {
    setState(() {
      _interestedIndex = 0;
      _distance = 40;
      _ageRange = const RangeValues(20, 28);
      _locationCtrl.text = 'Chicago, USA';
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Drag handle ──────────────────────────────────────────
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: c.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // ── Header ───────────────────────────────────────────────
              Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    t.filters,
                    style: AppTextStyles.h2.copyWith(color: c.textPrimary),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: _clear,
                      child: Text(
                        t.clear,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ── Interested in ─────────────────────────────────────────
              Text(
                t.interestedIn,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _InterestedInSelector(
                selected: _interestedIndex,
                onChanged: (i) => setState(() => _interestedIndex = i),
                labels: [t.girls, t.boys, t.both],
              ),

              const SizedBox(height: 24),

              // ── Location ──────────────────────────────────────────────
              Text(
                t.location,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _LocationInput(controller: _locationCtrl),

              const SizedBox(height: 24),

              // ── Distance ──────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.distance,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                  Text(
                    '${_distance.round()}km',
                    style:
                        AppTextStyles.bodyMedium.copyWith(color: c.text70),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              _buildSliderTheme(
                child: Slider(
                  value: _distance,
                  min: 0,
                  max: 100,
                  onChanged: (v) => setState(() => _distance = v),
                ),
              ),

              const SizedBox(height: 12),

              // ── Age ───────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.age,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                  Text(
                    '${_ageRange.start.round()}-${_ageRange.end.round()}',
                    style:
                        AppTextStyles.bodyMedium.copyWith(color: c.text70),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              _buildSliderTheme(
                child: RangeSlider(
                  values: _ageRange,
                  min: 18,
                  max: 60,
                  onChanged: (v) => setState(() => _ageRange = v),
                ),
              ),

              const SizedBox(height: 28),

              // ── Continue ──────────────────────────────────────────────
              AppPrimaryButton(
                text: t.continueLabel,
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderTheme({required Widget child}) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 6,
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: const Color(0xFFE8E6EA),
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withOpacity(0.1),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
      ),
      child: child,
    );
  }
}

// ─── Interested In Selector ──────────────────────────────────────────────────

class _InterestedInSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;
  final List<String> labels;

  const _InterestedInSelector({
    required this.selected,
    required this.onChanged,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isSelected = i == selected;
          BorderRadius? radius;
          if (i == 0) {
            radius = const BorderRadius.horizontal(left: Radius.circular(14));
          } else if (i == labels.length - 1) {
            radius = const BorderRadius.horizontal(right: Radius.circular(14));
          }
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: radius,
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[i],
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : c.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─── Location Input ──────────────────────────────────────────────────────────

class _LocationInput extends StatelessWidget {
  final TextEditingController controller;
  const _LocationInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: c.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTextStyles.bodyMedium.copyWith(color: c.textPrimary),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintStyle:
                    AppTextStyles.bodyMedium.copyWith(color: c.text70),
              ),
            ),
          ),
          Icon(Icons.keyboard_arrow_right, color: c.text70, size: 22),
        ],
      ),
    );
  }
}
