import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:prj_final_prm/core/theme/app_colors.dart';
import 'package:prj_final_prm/features/auth/infrastructure/models/user_model.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../stores/discover_store.dart';
import '../../../chat/domain/usecases/send_first_message_usecase.dart';
import '../../domain/entities/swipe_type.dart' as domain;
import '../widgets/discover_filter_sheet.dart';
import '../widgets/match_notification_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CardSwiperController _swiperController = CardSwiperController();
  late final DiscoverStore _discoverStore;
  SendFirstMessageUseCase? _sendFirstMessageUseCase;

  @override
  void initState() {
    super.initState();
    print('🏠 HomePage initState called');
    
    try {
      _discoverStore = getIt<DiscoverStore>();
      print('✅ DiscoverStore injected successfully: ${_discoverStore.runtimeType}');
    } catch (e) {
      print('❌ Error injecting DiscoverStore: $e');
      rethrow;
    }
    
    // Try to get SendFirstMessageUseCase, but don't fail if it's not available
    try {
      _sendFirstMessageUseCase = getIt<SendFirstMessageUseCase>();
      print('✅ SendFirstMessageUseCase injected successfully');
    } catch (e) {
      print('⚠️ SendFirstMessageUseCase not available: $e');
    }
    
    _discoverStore.fetchInitialBatch();
    _checkLocationPermission();
    
    // Listen for new matches
    reaction(
      (_) => _discoverStore.newMatchUser,
      (UserModel? matchedUser) {
        print('🎯 Reaction triggered: newMatchUser = ${matchedUser?.name}');
        if (matchedUser != null) {
          print('🎉 Showing match notification for ${matchedUser.name}');
          _showMatchNotification(matchedUser);
        }
      },
    );
    
    print('🏠 HomePage initState completed');
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    if (status.isDenied || status.isRestricted) {
      await Permission.locationWhenInUse.request();
    }
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final horizontalPadding = screenWidth * 0.1;
    final c = context.appColors;

    return AppScaffold(
      showQuickActions: false,
      showBackButton: false,
      titleWidget: Column(
        children: [
          Text(t.discover, style: AppTextStyles.h2),
          const SizedBox(height: 2),
          Observer(
            builder: (_) {
              if (_discoverStore.profiles.isEmpty) {
                return const SizedBox.shrink();
              }
              return Text(
                'Nearby', // Since we don't fetch city yet
                style: AppTextStyles.bodySmall.copyWith(color: c.text70),
              );
            }
          ),
        ],
      ),
      centerTitle: true,
      secondaryAction: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Undo button moved to top right
            Observer(
              builder: (_) => AppBarIconButton(
                icon: Icon(
                  Icons.replay,
                  color: _discoverStore.lastSwipedId == null 
                      ? Colors.grey 
                      : Color(0xFFFFC107),
                  size: 24,
                ),
                onTap: _discoverStore.isSwipeInProgress || _discoverStore.lastSwipedId == null
                    ? null
                    : () async {
                        final success = await _discoverStore.undoLastSwipe();
                        if (success && mounted) {
                          _swiperController.undo();
                        }
                      },
              ),
            ),
            const SizedBox(width: 8),
            AppBarIconButton(
              icon: Assets.icons.icSetting.svg(width: 24, height: 24),
              onTap: () async {
                final filter = await showDiscoverFilterSheet(
                  context,
                  currentFilter: _discoverStore.currentFilter,
                );
                if (filter != null) {
                  await _discoverStore.setFilter(filter);
                }
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _discoverStore.fetchInitialBatch();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 24 + MediaQuery.of(context).padding.bottom),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.03),

            // Profile Card with CardSwiper
            SizedBox(
              height: screenHeight * 0.57,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Observer(
                  builder: (context) {
                    if (_discoverStore.isLoading && _discoverStore.profiles.isEmpty) {
                      return _buildSkeletonLoader();
                    }

                    if (_discoverStore.error != null && _discoverStore.profiles.isEmpty) {
                      return _buildErrorView();
                    }

                    if (_discoverStore.profiles.isEmpty) {
                      return Center(
                        child: Text(
                          'No more profiles to discover right now.',
                          style: AppTextStyles.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return CardSwiper(
                      controller: _swiperController,
                      cardsCount: _discoverStore.profiles.length,
                      numberOfCardsDisplayed: _discoverStore.profiles.length > 1 ? 2 : 1,
                      backCardOffset: const Offset(0, -30),
                      padding: EdgeInsets.zero,
                      isLoop: false,
                      scale: 0.9,
                      onSwipe: _onSwipe,
                      onUndo: _onUndo,
                      allowedSwipeDirection: const AllowedSwipeDirection.all(),
                      cardBuilder:
                          (
                            context,
                            index,
                            horizontalOffsetPercentage,
                            verticalOffsetPercentage,
                          ) {
                            return _buildProfileCard(_discoverStore.profiles[index]);
                          },
                    );
                  }
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.026),

            // Action buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Observer(
                builder: (_) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Dislike button
                    GestureDetector(
                      onTap: _discoverStore.isSwipeInProgress
                          ? null
                          : () => _swiperController.swipe(CardSwiperDirection.left),
                      child: Container(
                        width: screenWidth * 0.21,
                        height: screenWidth * 0.21,
                        decoration: BoxDecoration(
                          color: c.background,
                          shape: BoxShape.circle,
                          border: Border.all(color: c.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
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
                      onTap: _discoverStore.isSwipeInProgress
                          ? null
                          : () => _swiperController.swipe(CardSwiperDirection.right),
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
                              color: const Color(0xFFE94057).withValues(alpha: 0.3),
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
                      onTap: _discoverStore.isSwipeInProgress
                          ? null
                          : () => _swiperController.swipe(CardSwiperDirection.top),
                      child: Container(
                        width: screenWidth * 0.21,
                        height: screenWidth * 0.21,
                        decoration: BoxDecoration(
                          color: c.background,
                          shape: BoxShape.circle,
                          border: Border.all(color: c.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
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
            ),

          ],
        ),
      ),
      ),
    );
  }

  Widget _buildProfileCard(UserModel user) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.57;
    
    // Calculate age from birthDate
    int age = 0;
    if (user.birthDate != null) {
      final today = DateTime.now();
      age = today.year - user.birthDate!.year;
      if (today.month < user.birthDate!.month || 
         (today.month == user.birthDate!.month && today.day < user.birthDate!.day)) {
        age -= 1;
      }
    }

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoutes.profileName,
          pathParameters: {'userId': user.id},
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
      width: double.infinity,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: user.avatarUrl != null 
              ? NetworkImage(user.avatarUrl!) as ImageProvider
              : AssetImage(Assets.images.profileExample.path),
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
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
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
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'Nearby', // Placeholder until location mapping is set
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
                        : Colors.white.withValues(alpha: 0.3),
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
                  '${user.name ?? user.id.substring(0, 5)}${age > 0 ? ', $age' : ''}',
                  style: AppTextStyles.h2.copyWith(color: AppColors.textWhite),
                ),
                const SizedBox(height: 4),
                Text(
                  user.bio ?? 'No bio',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    print('🎯 _onSwipe called: previousIndex=$previousIndex, direction=$direction');
    
    if (previousIndex < _discoverStore.profiles.length) {
      final profile = _discoverStore.profiles[previousIndex];
      print('👤 Profile: ${profile.name} (${profile.id})');

      domain.SwipeType domainSwipeType;
      switch (direction) {
        case CardSwiperDirection.left:
          domainSwipeType = domain.SwipeType.dislike;
          debugPrint('Disliked: ${profile.name}');
          break;
        case CardSwiperDirection.right:
          domainSwipeType = domain.SwipeType.like;
          debugPrint('Liked: ${profile.name}');
          break;
        case CardSwiperDirection.top:
          domainSwipeType = domain.SwipeType.superlike;
          debugPrint('Super Liked: ${profile.name}');
          break;
        default:
          print('❌ Unknown swipe direction: $direction');
          return false;
      }

      print('📞 Calling _discoverStore.onSwiped...');
      _discoverStore.onSwiped(profile, domainSwipeType);
      print('✅ _discoverStore.onSwiped called');
    } else {
      print('❌ Invalid previousIndex: $previousIndex >= ${_discoverStore.profiles.length}');
    }

    if (currentIndex != null) {
      final remainingCards = _discoverStore.profiles.length - currentIndex;
      if (remainingCards < 3 && !_discoverStore.hasReachedEnd) {
        _discoverStore.fetchNextBatch();
      }
    } else {
      if (!_discoverStore.hasReachedEnd) {
        _discoverStore.fetchNextBatch();
      }
    }

    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    return true;
  }

  Widget _buildSkeletonLoader() {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.57;
    
    return Container(
      width: double.infinity,
      height: cardHeight,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorView() {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.57;
    final c = context.appColors;
    
    return Container(
      width: double.infinity,
      height: cardHeight,
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: c.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: c.text70,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load profiles',
            style: AppTextStyles.bodyLarge.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            _discoverStore.error ?? 'Unknown error',
            style: AppTextStyles.bodyMedium.copyWith(color: c.text70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _discoverStore.fetchInitialBatch(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showMatchNotification(UserModel matchedUser) {
    print('🎯 _showMatchNotification called for ${matchedUser.name}');
    showMatchNotificationDialog(
      context,
      matchedUser,
      isSuperLike: _discoverStore.isNewMatchSuperLike, // Pass SuperLike info
      onKeepSwiping: () {
        print('🔄 Keep swiping pressed');
        _discoverStore.clearNewMatch();
      },
      onSendMessage: (String message) async {
        print('💬 Home: Received message to send: "$message"');
        if (_sendFirstMessageUseCase == null) {
          print('⚠️ SendFirstMessageUseCase not available');
          throw Exception('Message service not available');
        }
        try {
          print('📤 Calling SendFirstMessageUseCase...');
          await _sendFirstMessageUseCase!.execute(
            receiverId: matchedUser.id,
            message: message,
          );
          print('✅ Message sent via SendFirstMessageUseCase');
          _discoverStore.clearNewMatch();
        } catch (e) {
          print('❌ Error sending first message: $e');
          rethrow; // Let the dialog handle the error
        }
      },
    );
  }
}
