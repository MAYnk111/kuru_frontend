import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../data/models/application_model.dart';

class ApplicationItemCard extends StatelessWidget {
  final ApplicationModel application;
  final VoidCallback onTap;

  const ApplicationItemCard({
    super.key,
    required this.application,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderCream),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                _buildCompanyLogo(application),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application.role,
                        style: AppTypography.titleMedium(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        application.company,
                        style: AppTypography.bodySmall(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        application.appliedDate,
                        style: AppTypography.bodySmall(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusPill(
                  label: application.status,
                  type: application.statusType,
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyLogo(ApplicationModel app) {
    final comp = app.company.toLowerCase();

    if (comp.contains('microsoft')) {
      return Container(
        width: 36,
        height: 36,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderCream),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          children: const [
            ColoredBox(color: Color(0xFFF25022)), // Red-orange
            ColoredBox(color: Color(0xFF7FBA00)), // Green
            ColoredBox(color: Color(0xFF00A4EF)), // Blue
            ColoredBox(color: Color(0xFFFFB900)), // Yellow
          ],
        ),
      );
    } else if (comp.contains('google')) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderCream),
        ),
        child: const Center(
          child: Text(
            'G',
            style: TextStyle(
              color: Color(0xFF4285F4),
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      );
    } else if (comp.contains('zomato')) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFE23744),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'zomato',
            style: TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    } else if (comp.contains('amazon')) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'a',
            style: TextStyle(
              color: Color(0xFFFF9900),
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      );
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.secondaryNavy,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          app.company.isNotEmpty ? app.company[0].toUpperCase() : 'C',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
