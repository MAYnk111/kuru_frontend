import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../data/models/career_assessment_model.dart';

class SkillDetailSheet extends StatelessWidget {
  final SkillModel skill;

  const SkillDetailSheet({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Skill Name and Status Pill
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.secondaryNavy,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.antiqueGold.withOpacity(0.5)),
                ),
                child: const Center(
                  child: Icon(Icons.code, color: AppColors.antiqueGold, size: 22),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      skill.name,
                      style: AppTypography.titleLarge(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      skill.category,
                      style: AppTypography.bodySmall(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              StatusPill(
                label: skill.assessmentStatus,
                customBg: skill.assessmentStatus == 'Demonstrated'
                    ? AppColors.statusShortlistedBg
                    : (skill.assessmentStatus == 'In Progress'
                        ? AppColors.statusInReviewBg
                        : AppColors.warningLight),
                customTextColor: skill.assessmentStatus == 'Demonstrated'
                    ? AppColors.success
                    : (skill.assessmentStatus == 'In Progress'
                        ? AppColors.secondaryNavy
                        : AppColors.warning),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Assessment Score & Gauge Bar
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cardCream,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderCream),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Proficiency Index',
                      style: AppTypography.tag(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${skill.score}%',
                      style: AppTypography.titleMedium(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: skill.score / 100.0,
                    backgroundColor: AppColors.chipCream,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Repository & Commit Evidence Section
          Text(
            'Repository Evidence',
            style: AppTypography.titleMedium(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderCream),
            ),
            child: Column(
              children: [
                _buildEvidenceRow(
                  Icons.source_outlined,
                  'Repository',
                  skill.repository ?? 'Not demonstrated in analyzed repositories',
                ),
                if (skill.commitSha != null) ...[
                  const Divider(height: 16),
                  _buildEvidenceRow(
                    Icons.commit,
                    'Last Analyzed Commit',
                    skill.commitSha!,
                  ),
                ],
                if (skill.analyzedAt != null) ...[
                  const Divider(height: 16),
                  _buildEvidenceRow(
                    Icons.access_time,
                    'Analysis Timestamp',
                    skill.analyzedAt!,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Explanation
          Text(
            'Assessment Rationale',
            style: AppTypography.titleMedium(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            skill.evidence ??
                'This skill has not yet been demonstrated in analyzed repositories. Complete relevant growth tasks or connect repositories containing this tech stack.',
            style: AppTypography.bodySmall(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),

          // Dismiss Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close Details'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvidenceRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTypography.bodySmall(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTypography.tag(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
