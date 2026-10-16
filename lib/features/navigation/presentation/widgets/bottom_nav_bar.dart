import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/lotus_icon.dart';

class VedicBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const VedicBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCream,
        border: Border(
          top: BorderSide(
            color: AppColors.borderCream.withOpacity(0.8),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _buildNavItem(
                index: 0,
                label: 'Discover',
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
              ),
              _buildNavItem(
                index: 1,
                label: 'Career Twin',
                icon: Icons.psychology_outlined,
                activeIcon: Icons.psychology,
                useLotus: true,
              ),
              _buildNavItem(
                index: 2,
                label: 'Growth',
                icon: Icons.eco_outlined,
                activeIcon: Icons.eco,
              ),
              _buildNavItem(
                index: 3,
                label: 'Applications',
                icon: Icons.assignment_outlined,
                activeIcon: Icons.assignment,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
    required IconData activeIcon,
    bool useLotus = false,
  }) {
    final isSelected = index == currentIndex;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected)
              Container(
                width: 44,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primaryNavy,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.antiqueGold.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: useLotus
                      ? const LotusMotif(width: 20, height: 16, color: AppColors.antiqueGold)
                      : Icon(
                          activeIcon,
                          color: AppColors.antiqueGold,
                          size: 17,
                        ),
                ),
              )
            else
              SizedBox(
                height: 28,
                child: Center(
                  child: Icon(
                    icon,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTypography.tag(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primaryNavy : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
