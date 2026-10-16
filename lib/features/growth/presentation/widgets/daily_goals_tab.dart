import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../data/models/growth_models.dart';
import 'growth_wisdom_card.dart';

class DailyGoalsTab extends StatelessWidget {
  final List<DailyGoalModel> goals;
  final ValueChanged<String> onToggleGoal;
  final VoidCallback? onWhyMattersTap;

  const DailyGoalsTab({
    super.key,
    required this.goals,
    required this.onToggleGoal,
    this.onWhyMattersTap,
  });

  @override
  Widget build(BuildContext context) {
    final completedCount = goals.where((g) => g.isCompleted).length;
    final totalCount = goals.length;
    final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Inspirational Wisdom Quote Card
          const GrowthWisdomCard(
            quote: 'Discipline today builds the opportunities of tomorrow.',
          ),
          const SizedBox(height: 20),

          // Today's Focus Header + Progress Ratio
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Focus",
                style: AppTypography.titleLarge(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$completedCount of $totalCount completed',
                style: AppTypography.bodySmall(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Dark Navy Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.chipCream,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryNavy),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 16),

          // Daily Tasks List
          ...goals.map((goal) => _buildGoalCard(context, goal)),

          const SizedBox(height: 16),

          // "Why this matters?" Card
          _buildWhyThisMattersCard(context),
        ],
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, DailyGoalModel goal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderCream),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () => onToggleGoal(goal.id),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox matching reference
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: goal.isCompleted ? AppColors.success : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: goal.isCompleted ? AppColors.success : AppColors.borderCream,
                        width: 1.5,
                      ),
                    ),
                    child: goal.isCompleted
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),

                // Goal Title and Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        style: AppTypography.titleMedium(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: goal.isCompleted
                              ? AppColors.textPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        goal.description,
                        style: AppTypography.bodySmall(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Effort badge if present (e.g. 2h, 30m)
                if (goal.effort != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.chipCream,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          goal.effort!,
                          style: AppTypography.tag(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWhyThisMattersCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderCream),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onWhyMattersTap ??
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Target jobs on Naukri heavily value FastAPI, clean tests, and basic System Design.',
                    ),
                  ),
                );
              },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why this matters?',
                  style: AppTypography.titleMedium(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.warningLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.bar_chart,
                        color: AppColors.warning,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'These skills are required in 68% of your target opportunities on Naukri.',
                        style: AppTypography.bodySmall(
                          fontSize: 12.5,
                          color: AppColors.textPrimary,
                          height: 1.35,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
