import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/skill_chip.dart';
import '../../data/models/job_model.dart';

class JobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback onTap;
  final VoidCallback onToggleSave;

  const JobCard({
    super.key,
    required this.job,
    required this.onTap,
    required this.onToggleSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderCream, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tag & Provider Row
                Row(
                  children: [
                    if (job.isTopMatch)
                      Row(
                        children: [
                          const Icon(Icons.local_fire_department, color: Colors.deepOrange, size: 15),
                          const SizedBox(width: 4),
                          Text(
                            'Top Match for You',
                            style: AppTypography.tag(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFC85A17),
                            ),
                          ),
                        ],
                      )
                    else
                      const SizedBox.shrink(),
                    const Spacer(),
                    // Source attribution (e.g. naukri)
                    Row(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF1E88E5),
                          ),
                          child: const Center(
                            child: Text(
                              'n',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          job.source.toLowerCase(),
                          style: AppTypography.tag(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E88E5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Company logo + Job title + Company name + Location
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company logo or verified placeholder
                    _buildCompanyLogo(job),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: AppTypography.titleMedium(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            job.company,
                            style: AppTypography.bodySmall(
                              fontSize: 12.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 13,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  job.location,
                                  style: AppTypography.bodySmall(
                                    fontSize: 11.5,
                                    color: AppColors.textMuted,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Skill Chips Row
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    ...job.skills.take(3).map((s) => SkillChip(label: s)),
                    if (job.extraSkillsCount > 0)
                      SkillChip(label: '+${job.extraSkillsCount}'),
                  ],
                ),
                const SizedBox(height: 12),

                // Match Score Bar + Save Action
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${job.matchScore}% Match',
                            style: AppTypography.tag(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.success,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: job.matchScore / 100.0,
                              backgroundColor: AppColors.chipCream,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.success,
                              ),
                              minHeight: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(
                        job.isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: job.isSaved ? AppColors.antiqueGold : AppColors.textMuted,
                        size: 22,
                      ),
                      onPressed: onToggleSave,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
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

  Widget _buildCompanyLogo(JobModel job) {
    final companyLower = job.company.toLowerCase();

    // Specific styling for reference companies
    if (companyLower.contains('zoho')) {
      return Container(
        width: 42,
        height: 42,
        padding: const EdgeInsets.all(5),
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
            ColoredBox(color: Color(0xFFE53935)), // Red
            ColoredBox(color: Color(0xFF43A047)), // Green
            ColoredBox(color: Color(0xFF1E88E5)), // Blue
            ColoredBox(color: Color(0xFFFDD835)), // Yellow
          ],
        ),
      );
    } else if (companyLower.contains('swiggy')) {
      return Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFFC8019),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(Icons.fastfood, color: Colors.white, size: 20),
        ),
      );
    } else if (companyLower.contains('adobe')) {
      return Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFED2224),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'A',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    // Neutral verified placeholder for other providers
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.secondaryNavy,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          job.company.isNotEmpty ? job.company[0].toUpperCase() : 'C',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
