import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../i18n/strings.g.dart';
import '../../domain/entities/onboarding_item.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  late CarouselSliderController _carouselController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
  }

  List<OnboardingItem> _buildItems(Translations t) => [
        OnboardingItem(
          title: t.onboarding1Title,
          description: t.onboarding1Desc,
          imagePath: 'assets/animations/Dating app Lottie JSON animation.json',
        ),
        OnboardingItem(
          title: t.onboarding2Title,
          description: t.onboarding2Desc,
          imagePath: 'assets/animations/Chat.json',
        ),
        OnboardingItem(
          title: t.onboarding3Title,
          description: t.onboarding3Desc,
          imagePath: 'assets/animations/Firery Passion.json',
        ),
      ];

  void _nextPage(List<OnboardingItem> items) {
    if (_currentPage < items.length - 1) {
      _carouselController.nextPage();
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
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Carousel phần animation
            _buildLottieCarousel(items),

            const SizedBox(height: 32),

            // Phần text + indicators + buttons (không dùng Expanded để text luôn hiển thị hết)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    items[_currentPage].title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    items[_currentPage].description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Color(0xFF4A4A4A), // Có thể thay bằng Theme.of(context).textTheme.bodyMedium?.color để adaptive dark/light
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      items.length,
                      (index) => _buildPageIndicator(index),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Nút Create account
                  AppPrimaryButton(
                    text: t.createAnAccount,
                    onPressed: () => _nextPage(items),
                  ),
                  const SizedBox(height: 24),

                  // Sign in link
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.login),
                    child: RichText(
                      text: TextSpan(
                        text: t.alreadyHaveAccount,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        children: [
                          TextSpan(
                            text: ' ${t.signIn}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(), // Đẩy nhẹ xuống dưới nếu màn hình lớn
          ],
        ),
      ),
    );
  }

  Widget _buildLottieCarousel(List<OnboardingItem> items) {
  return SizedBox(
    height: 380,
    child: CarouselSlider.builder(
      carouselController: _carouselController,
      itemCount: items.length,
      options: CarouselOptions(
        height: 380,
        viewportFraction: 0.75,
        enlargeCenterPage: true,
        enlargeFactor: 0.25,
        enlargeStrategy: CenterPageEnlargeStrategy.height,
        autoPlay: false,
        enableInfiniteScroll: true,
        scrollPhysics: const BouncingScrollPhysics(),
        onPageChanged: (index, reason) {
          setState(() => _currentPage = index);
        },
      ),
      itemBuilder: (context, index, realIndex) {
        final item = items[index];
        final isCenter = index == _currentPage;

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: isCenter ? 1.0 : 0.5,
          child: AnimatedScale(
            scale: isCenter ? 1.0 : 0.75,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,  // ← Sửa ở đây: dùng curve có sẵn
            // Hoặc thử: Curves.easeInOutCubicEmphasized (nếu muốn emphasized hơn)
            // curve: Curves.easeInOutCubicEmphasized,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12.0),
              // Không decoration để transparent
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Lottie.asset(
                  item.imagePath,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  animate: isCenter,
                  repeat: true,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error_outline, size: 80, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
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