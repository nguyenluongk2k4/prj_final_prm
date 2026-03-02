import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CardSwiperController _swiperController = CardSwiperController();

  final List<ProfileCard> _profiles = [
    ProfileCard(
      name: 'Jessica Parker',
      age: 23,
      profession: 'Professional model',
      distance: '1 km',
      location: 'Chicago, II',
      imageUrl: Assets.images.profileExample.path,
    ),
    ProfileCard(
      name: 'Camila Snow',
      age: 23,
      profession: 'Marketer',
      distance: '2 km',
      location: 'New York, NY',
      imageUrl: Assets.images.profileExample.path,
    ),
    ProfileCard(
      name: 'Bred Jackson',
      age: 25,
      profession: 'Photograph',
      distance: '3 km',
      location: 'Los Angeles, CA',
      imageUrl: Assets.images.profileExample.path,
    ),
    ProfileCard(
      name: 'Emma Wilson',
      age: 24,
      profession: 'Designer',
      distance: '1.5 km',
      location: 'San Francisco, CA',
      imageUrl: Assets.images.profileExample.path,
    ),
    ProfileCard(
      name: 'Sophia Martinez',
      age: 22,
      profession: 'Artist',
      distance: '4 km',
      location: 'Miami, FL',
      imageUrl: Assets.images.profileExample.path,
    ),
  ];

  int _currentIndex = 0;

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final horizontalPadding = screenWidth * 0.1; // 10% of screen width

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                screenHeight * 0.054,
                horizontalPadding,
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button placeholder (empty for main screen)
                  Assets.images.btnBack.svg(width: 52, height: 52),

                  // Title
                  Column(
                    children: [
                      Text(t.discover, style: AppTextStyles.h2),
                      const SizedBox(height: 4),
                      Text(
                        _profiles[_currentIndex].location,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary70,
                        ),
                      ),
                    ],
                  ),

                  // Filter button
                  Assets.images.btnFilter.svg(width: 52, height: 52),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.03),

            // Profile Card with CardSwiper
            SizedBox(
              height: screenHeight * 0.57,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: CardSwiper(
                  controller: _swiperController,
                  cardsCount: _profiles.length,
                  numberOfCardsDisplayed: 2,
                  backCardOffset: const Offset(0, -30),
                  padding: EdgeInsets.zero,
                  isLoop: true,
                  scale: 0.9,
                  onSwipe: _onSwipe,
                  onUndo: _onUndo,
                  allowedSwipeDirection: AllowedSwipeDirection.symmetric(
                    horizontal: true,
                    vertical: false,
                  ),
                  cardBuilder:
                      (
                        context,
                        index,
                        horizontalOffsetPercentage,
                        verticalOffsetPercentage,
                      ) {
                        return _buildProfileCard(_profiles[index]);
                      },
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.026),

            // Action buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Dislike button
                  GestureDetector(
                    onTap: () =>
                        _swiperController.swipe(CardSwiperDirection.left),
                    child: Container(
                      width: screenWidth * 0.21,
                      height: screenWidth * 0.21,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.close,
                          color: Color(0xFFF27121),
                          size: 32,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: screenWidth * 0.043),

                  // Like button
                  GestureDetector(
                    onTap: () =>
                        _swiperController.swipe(CardSwiperDirection.right),
                    child: Container(
                      width: screenWidth * 0.264,
                      height: screenWidth * 0.264,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE94057), Color(0xFFF27121)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE94057).withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: screenWidth * 0.043),

                  // Super like button
                  GestureDetector(
                    onTap: () =>
                        _swiperController.swipe(CardSwiperDirection.top),
                    child: Container(
                      width: screenWidth * 0.21,
                      height: screenWidth * 0.21,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.star,
                          color: Color(0xFF8A2387),
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    ));
  }

  Widget _buildProfileCard(ProfileCard profile) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.57;

    return Container(
      width: double.infinity,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(profile.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Bottom gradient overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
          ),

          // Location badge
          Positioned(
            left: 16,
            top: 36,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    profile.distance,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Pagination indicators
          Positioned(
            right: 20,
            top: 162,
            child: Column(
              children: List.generate(
                5,
                (index) => Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == 0
                        ? AppColors.primary
                        : Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),

          // Profile info
          Positioned(
            left: 16,
            bottom: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${profile.name}, ${profile.age}',
                  style: AppTextStyles.h2.copyWith(color: AppColors.textWhite),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.profession,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    final profile = _profiles[previousIndex];

    switch (direction) {
      case CardSwiperDirection.left:
        debugPrint('Disliked: ${profile.name}');
        break;
      case CardSwiperDirection.right:
        debugPrint('Liked: ${profile.name}');
        break;
      case CardSwiperDirection.top:
        debugPrint('Super Liked: ${profile.name}');
        break;
      default:
        break;
    }

    if (currentIndex != null) {
      setState(() {
        _currentIndex = currentIndex;
      });
    }

    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    setState(() {
      _currentIndex = currentIndex;
    });
    return true;
  }
}

class ProfileCard {
  final String name;
  final int age;
  final String profession;
  final String distance;
  final String location;
  final String imageUrl;

  ProfileCard({
    required this.name,
    required this.age,
    required this.profession,
    required this.distance,
    required this.location,
    required this.imageUrl,
  });
}
