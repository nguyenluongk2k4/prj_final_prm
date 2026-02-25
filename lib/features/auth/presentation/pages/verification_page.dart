import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final List<String> _code = ['7', '2', '0', ''];
  int _currentIndex = 3;
  String _timer = '00:42';

  void _onNumberTap(String number) {
    if (_currentIndex < 4) {
      setState(() {
        _code[_currentIndex] = number;
        if (_currentIndex < 3) {
          _currentIndex++;
        } else {
          // Code is complete, navigate to profile details
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              context.pushNamed(AppRoutes.profileDetailsName);
            }
          });
        }
      });
    }
  }

  void _onDeleteTap() {
    if (_currentIndex >= 0) {
      setState(() {
        _code[_currentIndex] = '';
        if (_currentIndex > 0) {
          _currentIndex--;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBackButton: true,
      body: Column(
        children: [
          const SizedBox(height: 16),

          // Timer
          Text(_timer, style: AppTextStyles.h1),

          const SizedBox(height: 16),

          // Description
          Text(
            t.verificationDesc,
            textAlign: TextAlign.center,
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary70,
            ),
          ),

          const SizedBox(height: 28),

          // Code inputs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) => _buildCodeBox(index)),
            ),
          ),

          const Spacer(),

          // Send again button
          TextButton(
            onPressed: () {
              // Resend code logic
            },
            child: Text(
              t.continueLabel,
              style: AppTextStyles.button.copyWith(color: AppColors.primary),
            ),
          ),

          const SizedBox(height: 12),

          // Keyboard
          Container(
            height: 248,
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withOpacity(0.05),
                  blurRadius: 108,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
              child: Column(
                children: [
                  _buildKeyboardRow(['1', '2', '3']),
                  const SizedBox(height: 24),
                  _buildKeyboardRow(['4', '5', '6']),
                  const SizedBox(height: 24),
                  _buildKeyboardRow(['7', '8', '9']),
                  const SizedBox(height: 24),
                  _buildKeyboardRow(['', '0', 'delete']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeBox(int index) {
    final bool isFilled = _code[index].isNotEmpty;
    final bool isActive = index == _currentIndex;

    return Container(
      width: 66,
      height: 70,
      decoration: BoxDecoration(
        color: isFilled ? AppColors.primary : AppColors.background,
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.border,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          _code[index],
          style: AppTextStyles.h1.copyWith(
            color: isFilled
                ? AppColors.textWhite
                : (isActive
                      ? AppColors.primary.withOpacity(0.4)
                      : AppColors.border),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboardRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) {
        if (number.isEmpty) {
          return const SizedBox(width: 117);
        } else if (number == 'delete') {
          return SizedBox(
            width: 117,
            height: 36,
            child: TextButton(
              onPressed: _onDeleteTap,
              child: const Icon(
                Icons.backspace_outlined,
                color: AppColors.textPrimary,
                size: 24,
              ),
            ),
          );
        } else {
          return SizedBox(
            width: 117,
            height: 36,
            child: TextButton(
              onPressed: () => _onNumberTap(number),
              child: Text(
                number,
                style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w400),
              ),
            ),
          );
        }
      }).toList(),
    );
  }
}
