import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../gen/assets.gen.dart';

class InterestsPage extends StatefulWidget {
  const InterestsPage({super.key});

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  final List<Interest> _interests = [
    Interest(name: 'Photography', icon: '177:332', isSelected: false),
    Interest(name: 'Shopping', icon: '177:328', isSelected: true),
    Interest(name: 'Karaoke', icon: '177:324', isSelected: false),
    Interest(name: 'Yoga', icon: '177:334', isSelected: false),
    Interest(name: 'Cooking', icon: '177:329', isSelected: false),
    Interest(name: 'Tennis', icon: '177:325', isSelected: false),
    Interest(name: 'Run', icon: '177:326', isSelected: true),
    Interest(name: 'Swimming', icon: '177:336', isSelected: false),
    Interest(name: 'Art', icon: '177:327', isSelected: false),
    Interest(name: 'Traveling', icon: '177:333', isSelected: true),
    Interest(name: 'Extreme', icon: '177:330', isSelected: false),
    Interest(name: 'Music', icon: '177:401', isSelected: false),
    Interest(name: 'Drink', icon: '177:335', isSelected: false),
    Interest(name: 'Video games', icon: '177:337', isSelected: false),
  ];

  void _toggleInterest(int index) {
    setState(() {
      _interests[index].isSelected = !_interests[index].isSelected;
    });
  }

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
            icon: Assets.icons.btnBack.svg(width: 52, height: 52),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // Title and description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your interests',
                    style: TextStyle(
                      fontFamily: 'Sk-Modernist',
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF000000),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Select a few of your interests and let everyone know what you\'re passionate about.',
                    style: TextStyle(
                      fontFamily: 'Sk-Modernist',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xB3000000), // 70% opacity
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Interests grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 10,
                    childAspectRatio: 140 / 45,
                  ),
                  itemCount: _interests.length,
                  itemBuilder: (context, index) {
                    return _buildInterestChip(_interests[index], index);
                  },
                ),
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: AppPrimaryButton(
                text: 'Continue',
                onPressed: () {
                  context.goNamed(AppRoutes.homeName);
                },
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestChip(Interest interest, int index) {
    return GestureDetector(
      onTap: () => _toggleInterest(index),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: interest.isSelected ? const Color(0xFFE94057) : Colors.white,
          border: Border.all(
            color: interest.isSelected
                ? const Color(0xFFE94057)
                : const Color(0xFFE8E6EA),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: interest.isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFE94057).withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 15),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              // Icon from assets
              SizedBox(
                width: 19,
                height: 19,
                child: _getIcon(interest.name).svg(
                  colorFilter: ColorFilter.mode(
                    interest.isSelected
                        ? Colors.white
                        : const Color(0xFF000000),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  interest.name,
                  style: TextStyle(
                    fontFamily: 'Sk-Modernist',
                    fontSize: 14,
                    fontWeight: interest.isSelected
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: interest.isSelected
                        ? Colors.white
                        : const Color(0xFF000000),
                    height: 1.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SvgGenImage _getIcon(String name) {
    switch (name) {
      case 'Photography':
        return Assets.icons.camera;
      case 'Shopping':
        return Assets.icons.shopping;
      case 'Karaoke':
        return Assets.icons.voice;
      case 'Yoga':
        return Assets.icons.yoga;
      case 'Cooking':
        return Assets.icons.noodles;
      case 'Tennis':
        return Assets.icons.tennis;
      case 'Run':
        return Assets.icons.sport;
      case 'Swimming':
        return Assets.icons.ripple;
      case 'Art':
        return Assets.icons.platte;
      case 'Traveling':
        return Assets.icons.outdoor;
      case 'Extreme':
        return Assets.icons.parachute;
      case 'Music':
        return Assets.icons.music;
      case 'Drink':
        return Assets.icons.goblet;
      case 'Video games':
        return Assets.icons.gameHandle;
      default:
        return Assets.icons.camera;
    }
  }
}

class Interest {
  final String name;
  final String icon;
  bool isSelected;

  Interest({required this.name, required this.icon, required this.isSelected});
}
