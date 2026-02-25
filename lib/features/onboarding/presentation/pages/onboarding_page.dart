import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/onboarding_item.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentPage = 0;

  final List<OnboardingItem> _onboardingItems = const [
    OnboardingItem(
      title: 'Algorithm',
      description:
          'Users going through a vetting process to ensure you never match with bots.',
      imagePath: 'assets/images/onboarding_1.png',
    ),
    OnboardingItem(
      title: 'Matches',
      description:
          'We match you with people that have a large array of similar interests.',
      imagePath: 'assets/images/onboarding_2.png',
    ),
    OnboardingItem(
      title: 'Premium',
      description:
          'Sign up today and enjoy the first month of premium benefits on us.',
      imagePath: 'assets/images/onboarding_3.png',
    ),
  ];

  @override
  void dispose() {
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  // Ảnh bên trái: circular loop (page 0 -> ảnh 3, page 1 -> ảnh 1, page 2 -> ảnh 2)
  int _getLeftImageIndex() {
    return (_currentPage - 1 + _onboardingItems.length) % _onboardingItems.length;
  }

  // Ảnh bên phải: circular loop (page 0 -> ảnh 2, page 1 -> ảnh 3, page 2 -> ảnh 1)
  int _getRightImageIndex() {
    return (_currentPage + 1) % _onboardingItems.length;
  }

  void _nextPage() {
    if (_currentPage < _onboardingItems.length - 1) {
      setState(() {
        _currentPage++;
      });
    } else {
      context.go(AppRoutes.signup);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
            const SizedBox(height: 32),

            // Image carousel - 3 ảnh: left, center, right (circular loop)
            _buildImageCarousel(),

            const SizedBox(height: 44),

            // Text content (title, description, indicators)
            _buildTextContent(_onboardingItems[_currentPage]),

            // Bottom section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                children: [
                  // Create account button
                  AppPrimaryButton(
                    text: 'Create an account',
                    onPressed: _nextPage,
                  ),

                  const SizedBox(height: 20),

                  // Sign in text
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.login),
                    child: Text(
                      'Already have an account? Sign In',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }

  Widget _buildImageCarousel() {
    return SizedBox(
      height: 360,
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            // Swipe left -> next page
            if (_currentPage < _onboardingItems.length - 1) {
              setState(() {
                _currentPage++;
              });
            }
          } else if (details.primaryVelocity! > 0) {
            // Swipe right -> previous page
            if (_currentPage > 0) {
              setState(() {
                _currentPage--;
              });
            }
          }
        },
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Ảnh bên trái (nhỏ hơn) - circular loop
            Positioned(
              left: -30,
              top: 30,
              child: Container(
                width: 100,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage(_onboardingItems[_getLeftImageIndex()].imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Ảnh chính ở giữa
            Center(
              child: Container(
                width: 210,
                height: 360,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage(_onboardingItems[_currentPage].imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Ảnh bên phải (nhỏ hơn) - circular loop
            Positioned(
              right: -30,
              top: 30,
              child: Container(
                width: 100,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage(_onboardingItems[_getRightImageIndex()].imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextContent(OnboardingItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          // Title
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10),

          // Description
          Text(
            item.description,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF323755),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 36),

          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _onboardingItems.length,
              (index) => _buildPageIndicator(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    final isActive = index == _currentPage;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.primary : const Color(0xFFE8E6EA),
      ),
    );
  }
}
