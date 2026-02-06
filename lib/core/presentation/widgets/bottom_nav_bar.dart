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
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
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
        height: 48,
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
            if (isSelected)
              Positioned(
                bottom: 0,
                child: Container(
                  width: 60,
                  height: 2,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0x1AE94057), Colors.transparent],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
