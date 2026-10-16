import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/lotus_icon.dart';

class GrowthWisdomCard extends StatelessWidget {
  final String quote;

  const GrowthWisdomCard({
    super.key,
    this.quote = 'Discipline today builds the opportunities of tomorrow.',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardCream,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.antiqueGold.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Background lotus motif on right
          Positioned(
            right: 4,
            bottom: -4,
            child: Opacity(
              opacity: 0.85,
              child: const LotusMotif(
                width: 78,
                height: 56,
                color: AppColors.antiqueGold,
                strokeWidth: 1.3,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 2,
                      height: 12,
                      color: AppColors.antiqueGold,
                    ),
                    const SizedBox(width: 3),
                    Container(
                      width: 2,
                      height: 12,
                      color: AppColors.antiqueGold,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  quote,
                  style: AppTypography.serifQuote(
                    fontSize: 14.5,
                    color: AppColors.mutedGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
