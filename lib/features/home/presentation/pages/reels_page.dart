import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/presentation/widgets/app_scaffold.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../stores/reels_store.dart';
import '../widgets/reel_card.dart';

class ReelsPage extends StatefulWidget {
  final String? initialType;
  const ReelsPage({super.key, this.initialType});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  final _store = getIt<ReelsStore>();
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    if (widget.initialType == 'profile') {
       _store.feedType = ReelsFeedType.profile;
    } else if (widget.initialType == 'friends') {
       _store.feedType = ReelsFeedType.friends;
    }
    _store.fetchReels();

    // Reset PageView to top when reels list is refreshed/updated after upload
    reaction(
      (_) => _store.reels.length,
      (length) {
        if (length > 0 && _store.currentIndex == 0 && _pageController.hasClients) {
          _pageController.jumpToPage(0);
        }
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: Colors.black,
      appBarColor: Colors.black.withOpacity(0.5),
      extendBodyBehindAppBar: true,
      removeSafeArea: true,
      showQuickActions: false,
      titleWidget: Observer(
        builder: (_) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTabItem(
              title: 'Bạn bè',
              isSelected: _store.feedType == ReelsFeedType.friends,
              onTap: () => _store.setFeedType(ReelsFeedType.friends),
            ),
            const SizedBox(width: 24),
            _buildTabItem(
              title: 'Khám phá',
              isSelected: _store.feedType == ReelsFeedType.discover,
              onTap: () => _store.setFeedType(ReelsFeedType.discover),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add_box_outlined, color: Colors.white, size: 28),
          onPressed: () => _showUploadOptions(context),
        ),
        const SizedBox(width: 8),
      ],
      body: VisibilityDetector(
        key: const Key('reels_page_vis'),
        onVisibilityChanged: (info) {
          final isVisible = info.visibleFraction > 0.8;
          _store.setPageVisibility(isVisible);
        },
        child: Observer(
          builder: (_) {
            if (_store.isLoading && _store.reels.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (_store.errorMessage != null && _store.reels.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _store.errorMessage!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _store.fetchReels(refresh: true),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (_store.reels.isEmpty) {
               return Center(
                 child: Text(
                   _store.feedType == ReelsFeedType.friends 
                     ? 'Chưa có tin từ bạn bè' 
                     : 'Không có nội dung',
                   style: const TextStyle(color: Colors.white70),
                 ),
               );
            }

            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: _store.reels.length,
              onPageChanged: _store.setCurrentIndex,
              itemBuilder: (context, index) {
                final reel = _store.reels[index];
                return ReelCard(
                  reel: reel,
                  shouldPlay: index == _store.currentIndex,
                  store: _store,
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showUploadOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.videocam_outlined, color: Colors.white, size: 28),
                title: const Text('Đăng Video (Reels)',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(ctx);
                  context.pushNamed(AppRoutes.reelsUploadName);
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_photo_alternate_outlined,
                    color: Colors.white, size: 28),
                title: const Text('Đăng Ảnh',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(ctx);
                  context.pushNamed(AppRoutes.photoUploadName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.h3.copyWith(
              color: isSelected ? Colors.white : Colors.white60,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 20,
              color: Colors.white,
            ),
        ],
      ),
    );
  }
}
