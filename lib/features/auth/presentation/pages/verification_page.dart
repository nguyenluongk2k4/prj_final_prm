import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarSimple(
        title: '',
        centerTitle: false,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset(
              'assets/icons/btn_back.svg',
              width: 52,
              height: 52,
            ),
            onPressed: () => context.pop(),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 28),

            // Timer
            Text(
              _timer,
              style: const TextStyle(
                fontFamily: 'Sk-Modernist',
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: Color(0xFF000000),
                height: 1.5,
              ),
            ),

            const SizedBox(height: 16),

            // Description
            const Text(
              'Type the verification code\nwe\'ve sent you',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Sk-Modernist',
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color(0xB3000000), // 70% opacity
                height: 1.5,
              ),
            ),

            const SizedBox(height: 48),

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
              child: const Text(
                'Send again',
                style: TextStyle(
                  fontFamily: 'Sk-Modernist',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFE94057),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Keyboard
            Container(
              height: 248,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
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
        color: isFilled ? const Color(0xFFE94057) : Colors.white,
        border: Border.all(
          color: isActive ? const Color(0xFFE94057) : const Color(0xFFE8E6EA),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          _code[index],
          style: TextStyle(
            fontFamily: 'Sk-Modernist',
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: isFilled
                ? Colors.white
                : (isActive
                    ? const Color(0x66E94057) // 40% opacity
                    : const Color(0xFFE8E6EA)),
            height: 1.5,
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
                color: Color(0xFF000000),
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
                style: const TextStyle(
                  fontFamily: 'Sk-Modernist',
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF000000),
                  height: 1.5,
                ),
              ),
            ),
          );
        }
      }).toList(),
    );
  }
}
