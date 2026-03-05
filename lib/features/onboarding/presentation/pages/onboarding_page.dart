import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../i18n/strings.g.dart';
import '../../domain/entities/onboarding_item.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentPage = 0;

  List<OnboardingItem> _buildItems(Translations t) => [
    OnboardingItem(
      title: t.onboarding1Title,
      description: t.onboarding1Desc,
      imagePath: 'assets/images/onboarding_1.png',
    ),
    OnboardingItem(
      title: t.onboarding2Title,
      description: t.onboarding2Desc,
      imagePath: 'assets/images/onboarding_2.png',
    ),
    OnboardingItem(
      title: t.onboarding3Title,
      description: t.onboarding3Desc,
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
  int _getLeftImageIndex(int length) {
    return (_currentPage - 1 + length) % length;
  }

  // Ảnh bên phải: circular loop (page 0 -> ảnh 2, page 1 -> ảnh 3, page 2 -> ảnh 1)
  int _getRightImageIndex(int length) {
    return (_currentPage + 1) % length;
  }

  void _nextPage(List<OnboardingItem> items) {
    if (_currentPage < items.length - 1) {
      setState(() {
        _currentPage++;
      });
    } else {
      context.go(AppRoutes.signup);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final items = _buildItems(t);
    return AppScaffold(
      showQuickActions: false,
      actions: const [AppBarActions()],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
            const SizedBox(height: 32),

            // Image carousel - 3 ảnh: left, center, right (circular loop)
            _buildImageCarousel(items),

            const SizedBox(height: 44),

            // Text content (title, description, indicators)
            _buildTextContent(items[_currentPage], items.length),

            // Bottom section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                children: [
                  // Create account button
                  AppPrimaryButton(
                    text: t.createAnAccount,
                    onPressed: () => _nextPage(items),
                  ),

                  const SizedBox(height: 20),

                  // Sign in text
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.login),
                    child: Text(
                      t.alreadyHaveAccountSignIn,
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

  Widget _buildImageCarousel(List<OnboardingItem> items) {
    return SizedBox(
      height: 360,
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            // Swipe left -> next page
            if (_currentPage < items.length - 1) {
              setState(() { _currentPage++; });
            }
          } else if (details.primaryVelocity! > 0) {
            // Swipe right -> previous page
            if (_currentPage > 0) {
              setState(() { _currentPage--; });
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
                    image: AssetImage(items[_getLeftImageIndex(items.length)].imagePath),
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
                    image: AssetImage(items[_currentPage].imagePath),
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
                    image: AssetImage(items[_getRightImageIndex(items.length)].imagePath),
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

  Widget _buildTextContent(OnboardingItem item, int itemCount) {
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
              itemCount,
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
