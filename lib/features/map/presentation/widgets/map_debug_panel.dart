import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A debug panel that shows map state information (only visible in debug mode).
class MapDebugPanel extends StatelessWidget {
  final String tokenKind;
  final bool mapReady;
  final bool followUser;
  final bool supportedPlatform;

  const MapDebugPanel({
    super.key,
    required this.tokenKind,
    required this.mapReady,
    required this.followUser,
    required this.supportedPlatform,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final lines = [
      'platform: ${kIsWeb ? 'web' : defaultTargetPlatform.name}',
      'supported: $supportedPlatform',
      'sdk: mapbox_maps_flutter',
      'token: $tokenKind',
      'mapReady: $mapReady',
      'follow: $followUser',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: c.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines
            .map(
              (line) => Text(
                line,
                style: AppTextStyles.bodySmall.copyWith(color: c.textPrimary),
              ),
            )
            .toList(),
      ),
    );
  }
}
