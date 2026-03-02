import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Styled input box matching the app's design language.
/// Hint text is hidden on focus and shown again when the field is empty and unfocused.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()
      ..addListener(() {
        setState(() => _isFocused = _focusNode.hasFocus);
      });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 58,
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(
              color: hasError
                  ? AppColors.primary
                  : _isFocused
                      ? AppColors.primary
                      : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              if (widget.prefixIcon != null) ...[
                const SizedBox(width: 18),
                widget.prefixIcon!,
                const SizedBox(width: 12),
              ] else
                const SizedBox(width: 20),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType: widget.keyboardType,
                  obscureText: widget.obscureText,
                  style: AppTextStyles.bodyMedium,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    filled: false,
                    isDense: true,
                    // Hide hint while focused
                    hintText: _isFocused ? null : widget.hint,
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFFADAFBB), // gray
                    ),
                  ),
                ),
              ),
              if (widget.suffixIcon != null) ...[
                widget.suffixIcon!,
                const SizedBox(width: 18),
              ],
            ],
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              widget.errorText!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
