import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import 'star_sparkle.dart';

/// Reusable Navy top header with subtle constellation / Vedic accent
class VedicHeader extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? bottom;
  final bool showStarConstellation;

  const VedicHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.bottom,
    this.showStarConstellation = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryNavy,
        image: DecorationImage(
          image: AssetImage('assets/images/stars_bg.png'),
          fit: BoxFit.cover,
          opacity: 0.15,
          alignment: Alignment.topRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (leading != null) ...[
                    leading!,
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: AppTypography.bodySmall(
                              color: AppColors.antiqueGold,
                              fontSize: 12,
                            ),
                          ),
                        Text(
                          title,
                          style: AppTypography.titleLarge(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (actions != null) ...actions!,
                ],
              ),
              if (bottom != null) ...[
                const SizedBox(height: 14),
                bottom!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Vedic inspirational quote banner on Navy background
class VedicQuoteBanner extends StatelessWidget {
  final String quote;

  const VedicQuoteBanner({
    super.key,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const StarSparkle(size: 16, color: AppColors.antiqueGold),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            '"$quote"',
            style: AppTypography.serifQuote(
              fontSize: 13.5,
              color: AppColors.textOnNavySecondary,
            ),
          ),
        ),
      ],
    );
  }
}
