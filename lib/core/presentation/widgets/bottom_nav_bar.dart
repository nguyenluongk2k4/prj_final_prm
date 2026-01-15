import 'package:flutter/material.dart';
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
            icon: Icons.explore,
            isSelected: selectedIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavBarItem(
            icon: Icons.favorite_border,
            isSelected: selectedIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavBarItem(
            icon: Icons.chat_bubble_outline,
            isSelected: selectedIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavBarItem(
            icon: Icons.person_outline,
            isSelected: selectedIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
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
            Icon(
              icon,
              color: isSelected ? AppColors.primary : const Color(0xFFADAFBB),
              size: 24,
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
