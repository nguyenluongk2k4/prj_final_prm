import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';

class PhoneSignUpPage extends StatefulWidget {
  const PhoneSignUpPage({super.key});

  @override
  State<PhoneSignUpPage> createState() => _PhoneSignUpPageState();
}

class _PhoneSignUpPageState extends State<PhoneSignUpPage> {
  final TextEditingController _phoneController = TextEditingController(text: '331 623 8413');

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 42),

              // Header
              const Text(
                'My mobile',
                style: TextStyle(
                  fontFamily: 'Sk-Modernist',
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Please enter your valid phone number. We will send you a 4-digit code to verify your account.',
                style: TextStyle(
                  fontFamily: 'Sk-Modernist',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xB3000000), // 70% opacity
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 60),

              // Phone input
              Container(
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE8E6EA)),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 20),

                    // US Flag placeholder - in real app, use proper flag
                    Container(
                      width: 20,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Center(
                        child: Text(
                          '🇺🇸',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Back icon
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 24,
                      color: Colors.black,
                    ),

                    const SizedBox(width: 8),

                    // (+1)
                    const Text(
                      '(+1)',
                      style: TextStyle(
                        fontFamily: 'Sk-Modernist',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF000000),
                      ),
                    ),

                    // Vertical divider
                    Container(
                      width: 1,
                      height: 18,
                      color: const Color(0xFFE8E6EA),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),

                    // Phone input
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                          fontFamily: 'Sk-Modernist',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF000000),
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Phone number',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Continue button
              AppPrimaryButton(
                text: 'Continue',
                onPressed: () {
                  context.pushNamed(AppRoutes.verificationName);
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}