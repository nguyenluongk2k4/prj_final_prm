import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_color_scheme.dart';
import '../../theme/app_text_styles.dart';

/// Styled input box matching the app's design language.
/// Hint text is hidden on focus and shown again when the field is empty and unfocused.
///
/// Set [embedded] = true when placing the field inside its own custom container
/// (e.g. a chat input bar). In that mode only the bare TextField is rendered —
/// no outer border, no height constraint, no error label.
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
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.minLines,
    this.embedded = false,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final int maxLines;
  final int? minLines;
  /// When true, renders only the inner [TextField] with no outer container or border.
  /// Use this inside a custom container that already provides its own styling.
  final bool embedded;
  final String? Function(String?)? validator;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  bool get hasError {
    final explicitError = widget.errorText != null && widget.errorText!.isNotEmpty;
    if (explicitError) return true;
    
    if (widget.validator != null) {
      final validationError = widget.validator!(widget.controller.text);
      return validationError != null && validationError.isNotEmpty;
    }
    
    return false;
  }

  String? _getErrorMessage() {
    if (widget.errorText != null && widget.errorText!.isNotEmpty) {
      return widget.errorText;
    }
    
    if (widget.validator != null) {
      return widget.validator!(widget.controller.text);
    }
    
    return null;
  }

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
    final c = context.appColors;
    final textColor = c.textPrimary;
    final hintColor = c.text70;

    final innerField = TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      onChanged: (value) {
        widget.onChanged?.call(value);
        if (widget.validator != null) {
          setState(() {}); // Trigger validation check
        }
      },
      onSubmitted: widget.onSubmitted,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      style: AppTextStyles.bodyMedium.copyWith(color: textColor),
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        filled: false,
        isDense: true,
        hintText: _isFocused ? null : widget.hint,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: hintColor),
        contentPadding: widget.embedded
            ? const EdgeInsets.symmetric(vertical: 14)
            : null,
      ),
    );

    // ── Embedded mode: bare field only, no outer container ────────────────
    if (widget.embedded) return innerField;

    // ── Normal mode: styled container + optional error label ──────────────
    final borderCol = hasError
        ? AppColors.primary
        : _isFocused
            ? AppColors.primary
            : c.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 58,
          decoration: BoxDecoration(
            color: c.background,
            border: Border.all(color: borderCol),
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
              Expanded(child: innerField),
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
              _getErrorMessage() ?? 'Error',
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
