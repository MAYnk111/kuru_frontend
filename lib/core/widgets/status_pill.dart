import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

class StatusPill extends StatelessWidget {
  final String label;
  final String? type; // 'in_review', 'shortlisted', 'interview', 'applied'
  final Color? customBg;
  final Color? customTextColor;

  const StatusPill({
    super.key,
    required this.label,
    this.type,
    this.customBg,
    this.customTextColor,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = AppColors.chipCream;
    Color textColor = AppColors.textPrimary;

    if (customBg != null && customTextColor != null) {
      bg = customBg!;
      textColor = customTextColor!;
    } else {
      final normalized = (type ?? label).toLowerCase().replaceAll(' ', '_');
      if (normalized.contains('review')) {
        bg = AppColors.statusInReviewBg;
        textColor = AppColors.statusInReviewText;
      } else if (normalized.contains('shortlist')) {
        bg = AppColors.statusShortlistedBg;
        textColor = AppColors.statusShortlistedText;
      } else if (normalized.contains('interview')) {
        bg = AppColors.statusInterviewBg;
        textColor = AppColors.statusInterviewText;
      } else if (normalized.contains('applied')) {
        bg = AppColors.statusAppliedBg;
        textColor = AppColors.statusAppliedText;
      } else if (normalized.contains('full') || normalized.contains('time')) {
        bg = AppColors.chipCream;
        textColor = AppColors.textPrimary;
      } else if (normalized.contains('remote')) {
        bg = AppColors.lightGold;
        textColor = AppColors.mutedGold;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: AppTypography.tag(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
