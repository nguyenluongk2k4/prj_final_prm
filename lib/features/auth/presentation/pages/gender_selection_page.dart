import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';

class GenderSelectionPage extends StatefulWidget {
  const GenderSelectionPage({super.key});

  @override
  State<GenderSelectionPage> createState() => _GenderSelectionPageState();
}

class _GenderSelectionPageState extends State<GenderSelectionPage> {
  String? _selectedGender;

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
        actions: [
          TextButton(
            onPressed: () {
              context.goNamed(AppRoutes.homeName);
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                fontFamily: 'Sk-Modernist',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFFE94057),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Title
              const Text(
                'I am a',
                style: TextStyle(
                  fontFamily: 'Sk-Modernist',
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 91),

              // Woman option
              _buildGenderOption(
                label: 'Woman',
                value: 'woman',
                isSelected: _selectedGender == 'woman',
              ),

              const SizedBox(height: 10),

              // Man option
              _buildGenderOption(
                label: 'Man',
                value: 'man',
                isSelected: _selectedGender == 'man',
              ),

              const SizedBox(height: 10),

              // Choose another option
              _buildGenderOption(
                label: 'Choose another',
                value: 'other',
                isSelected: _selectedGender == 'other',
                isOther: true,
              ),

              const Spacer(),

              // Continue button
              AppPrimaryButton(
                text: 'Continue',
                onPressed: _selectedGender != null
                    ? () {
                        context.pushNamed(AppRoutes.interestsName);
                      }
                    : null,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderOption({
    required String label,
    required String value,
    required bool isSelected,
    bool isOther = false,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE94057) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFFE94057) : const Color(0xFFE8E6EA),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Sk-Modernist',
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected ? Colors.white : const Color(0xFF000000),
                  height: 1.5,
                ),
              ),
              const Spacer(),
              if (isSelected && !isOther)
                const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                )
              else if (isOther)
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF000000),
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
