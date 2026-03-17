import 'package:flutter/material.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A placeholder view shown when the platform doesn't support the map.
class MapUnsupportedPlatformView extends StatelessWidget {
  const MapUnsupportedPlatformView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      color: c.background,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        'Map view supports Android/iOS only.',
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyMedium.copyWith(color: c.textPrimary),
      ),
    );
  }
}
