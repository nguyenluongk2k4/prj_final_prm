import 'package:flutter/material.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A banner that displays status messages on the map.
class MapStatusBanner extends StatelessWidget {
  final String message;

  const MapStatusBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: c.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border),
      ),
      child: Text(
        message,
        style: AppTextStyles.bodySmall.copyWith(color: c.textPrimary),
      ),
    );
  }
}
