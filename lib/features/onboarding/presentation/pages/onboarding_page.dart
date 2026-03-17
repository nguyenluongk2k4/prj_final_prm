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
            const SizedBox(height: 32),
            _buildLottieCarousel(items),
            const SizedBox(height: 44),
            Expanded(
              child: SingleChildScrollView(
                child: _buildTextContent(items[_currentPage], items.length),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppPrimaryButton(
                    text: t.createAnAccount,
                    onPressed: () => _nextPage(items),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.login),
                    child: Text(
                      t.alreadyHaveAccountSignIn,
                      style: const TextStyle(
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
    );
  }

  Widget _buildLottieCarousel(List<OnboardingItem> items) {
    return SizedBox(
      height: 400,
      child: CarouselSlider.builder(
        carouselController: _carouselController,
        itemCount: items.length,
        options: CarouselOptions(
          height: 400,
          viewportFraction: 0.62,
          enlargeCenterPage: true,
          enlargeFactor: 0.3,
          autoPlay: false,
          enableInfiniteScroll: true,
          onPageChanged: (index, reason) {
            setState(() => _currentPage = index);
          },
        ),
        itemBuilder: (context, index, realIndex) {
          final item = items[index];
          final isCenter = index == _currentPage;

          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: isCenter ? 1.0 : 0.6,
            child: Center(
              child: Container(
                width: isCenter ? 240 : 140,
                height: isCenter ? 400 : 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isCenter
                      ? [
                          const BoxShadow(
                            color: Colors.black26,
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Lottie.asset(
                    item.imagePath,
                    fit: BoxFit.contain,
                    animate: isCenter,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.animation, size: 40),
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

  // Các hàm _buildTextContent và _buildPageIndicator giữ nguyên như cũ...
  Widget _buildTextContent(OnboardingItem item, int itemCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
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