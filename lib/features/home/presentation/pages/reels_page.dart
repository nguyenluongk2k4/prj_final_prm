import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
          onPressed: () => context.pushNamed(AppRoutes.reelsUploadName),
        ),
        const SizedBox(width: 8),
      ],
      body: Observer(
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
