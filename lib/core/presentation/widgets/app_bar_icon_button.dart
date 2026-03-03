import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// A 52×52 rounded button used in AppBar leading and actions.
/// Light mode: white background, subtle shadow, #E8E6EA border.
/// Dark mode : transparent background, #2C2C2C border.
class AppBarIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onTap;

  const AppBarIconButton({
    super.key,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLight = brightness == Brightness.light;

    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: 52,
      height: 52,
        decoration: BoxDecoration(
          color: isLight ? AppColors.background : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isLight ? const Color(0xFFE8E6EA) : const Color(0xFF2C2C2C),
            width: 1,
          ),
          boxShadow: isLight
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: icon,
      ),
    );
  }
}
