import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../data/models/application_model.dart';

class ApplicationMetricCard extends StatelessWidget {
  final ApplicationMetrics metrics;

  const ApplicationMetricCard({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderCream),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildMetricColumn(
            count: '${metrics.applied}',
            label: 'Applied',
            color: AppColors.textSecondary,
          ),
          _buildDivider(),
          _buildMetricColumn(
            count: '${metrics.inReview}',
            label: 'In Review',
            color: AppColors.primaryNavy,
          ),
          _buildDivider(),
          _buildMetricColumn(
            count: '${metrics.interviews}',
            label: 'Interviews',
            color: AppColors.primaryNavy,
          ),
          _buildDivider(),
          _buildMetricColumn(
            count: '${metrics.shortlisted}',
            label: 'Shortlisted',
            color: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn({
    required String count,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count,
            style: AppTypography.displayBold(
              fontSize: 20,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.tag(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 32,
      color: AppColors.borderCream,
    );
  }
}
