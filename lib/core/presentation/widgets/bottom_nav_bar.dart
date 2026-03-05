import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../gen/assets.gen.dart';
import '../../theme/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Container(
      color: AppColors.bg(brightness),
      child: SafeArea(
        bottom: true,
        child: Stack(
          children: [
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.bg(brightness),
                border: Border(top: BorderSide(color: AppColors.borderColor(brightness), width: 1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavBarItem(
                    iconPath: Assets.icons.navHomeInactive.path,
                    isSelected: selectedIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  _NavBarItem(
                    iconPath: Assets.icons.navMatchesInactive.path,
                    isSelected: selectedIndex == 1,
                    onTap: () => onTap(1),
                  ),
                  _NavBarItem(
                    iconPath: Assets.icons.navChatInactive.path,
                    isSelected: selectedIndex == 2,
                    onTap: () => onTap(2),
                  ),
                  _NavBarItem(
                    iconPath: Assets.icons.navAccountInactive.path,
                    isSelected: selectedIndex == 3,
                    onTap: () => onTap(3),
                  ),
                ],
              ),
            ),
            AnimatedPositioned(
              top: 0,
              left: (MediaQuery.of(context).size.width / 4) * selectedIndex + (MediaQuery.of(context).size.width / 8) - 30,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              child: Container(
                width: 60,
                height: 3,
                decoration: const BoxDecoration(
                  color: Color(0xFFE94057),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 60,
        height: 56,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColors.primary : const Color(0xFFADAFBB),
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
