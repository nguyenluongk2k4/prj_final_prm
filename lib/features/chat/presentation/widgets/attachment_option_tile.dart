import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

class AttachmentOptionTile extends StatelessWidget {
  final Widget icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const AttachmentOptionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.12),
        child: icon,
      ),
      title: Text(label, style: AppTextStyles.bodyMedium),
      onTap: onTap,
    );
  }
}
