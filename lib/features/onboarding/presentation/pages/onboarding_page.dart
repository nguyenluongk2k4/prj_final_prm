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

    // Lấy kích thước màn hình để tính responsive
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600; // >600px coi như tablet/large phone
    final carouselHeight = screenSize.height * (isTablet ? 0.45 : 0.40); // 40-45% chiều cao màn hình
    final textPaddingHorizontal = screenSize.width * 0.08; // 8% width
    final titleFontSize = isTablet ? 36.0 : 28.0;
    final descFontSize = isTablet ? 18.0 : 16.0;
    final viewportFraction = isTablet ? 0.65 : 0.75; // Trên tablet show nhiều hơn một chút

    return AppScaffold(
      showQuickActions: false,
      actions: const [AppBarActions()],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                SizedBox(height: screenSize.height * 0.03), // ~3% top padding

                // Carousel responsive
                SizedBox(
                  height: carouselHeight,
                  child: CarouselSlider.builder(
                    carouselController: _carouselController,
                    itemCount: items.length,
                    options: CarouselOptions(
                      height: carouselHeight,
                      viewportFraction: viewportFraction,
                      enlargeCenterPage: true,
                      enlargeFactor: isTablet ? 0.20 : 0.25,
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
                          curve: Curves.easeOutCubic,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.03,
                            ),
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
                ),

                SizedBox(height: screenSize.height * 0.04),

                // Text + indicators + buttons
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: textPaddingHorizontal),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          items[_currentPage].title,
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Text(
                          items[_currentPage].description,
                          style: TextStyle(
                            fontSize: descFontSize,
                            height: 1.5,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[300]
                                : const Color(0xFF4A4A4A),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenSize.height * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            items.length,
                            (index) => _buildPageIndicator(index),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.06),

                        AppPrimaryButton(
                          text: t.createAnAccount,
                          onPressed: () => _nextPage(items),
                        ),
                        SizedBox(height: screenSize.height * 0.03),

                        GestureDetector(
                          onTap: () => context.go(AppRoutes.login),
                          child: RichText(
                            text: TextSpan(
                              text: t.alreadyHaveAccount,
                              style: TextStyle(
                                fontSize: descFontSize,
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
                ),
              ],
            );
          },
        ),
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