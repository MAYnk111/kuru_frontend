import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../core/widgets/skill_chip.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../data/models/growth_models.dart';

class RoadmapTab extends StatelessWidget {
  final RoadmapModel? roadmap;
  final List<ProjectRecommendationModel> projects;

  const RoadmapTab({
    super.key,
    required this.roadmap,
    required this.projects,
  });

  @override
  Widget build(BuildContext context) {
    if (roadmap == null) {
      return Center(
        child: Text('No active roadmap found.', style: AppTypography.bodyMedium()),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Target Role Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondaryNavy,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.antiqueGold.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Target Career Role',
                      style: AppTypography.tag(
                        fontSize: 11,
                        color: AppColors.antiqueGold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${roadmap!.completionPercentage}% Complete',
                      style: AppTypography.tag(
                        fontSize: 11.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  roadmap!.targetRole,
                  style: AppTypography.titleMedium(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: roadmap!.completionPercentage / 100.0,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.antiqueGold),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Milestone Timeline
          Text(
            'Career Roadmap Milestones',
            style: AppTypography.titleLarge(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),

          ...roadmap!.milestones.map((m) => _buildMilestoneCard(context, m)),

          const SizedBox(height: 20),

          // Gap-Targeted Project Recommendations
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Skill-Gap Project Recommendations',
                style: AppTypography.titleLarge(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ...projects.map((proj) => _buildProjectCard(context, proj)),
        ],
      ),
    );
  }

  Widget _buildMilestoneCard(BuildContext context, RoadmapMilestone milestone) {
    final isCompleted = milestone.status == 'Completed';
    final isInProgress = milestone.status == 'In Progress';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isInProgress ? AppColors.antiqueGold.withOpacity(0.6) : AppColors.borderCream,
          width: isInProgress ? 1.4 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? AppColors.successLight
                      : (isInProgress ? AppColors.lightGold : AppColors.chipCream),
                ),
                child: Center(
                  child: Icon(
                    isCompleted
                        ? Icons.check
                        : (isInProgress ? Icons.hourglass_top : Icons.lock_outline),
                    size: 15,
                    color: isCompleted
                        ? AppColors.success
                        : (isInProgress ? AppColors.mutedGold : AppColors.textMuted),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  milestone.title,
                  style: AppTypography.titleMedium(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              StatusPill(
                label: milestone.status,
                type: isCompleted ? 'shortlisted' : (isInProgress ? 'in_review' : 'applied'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            milestone.description,
            style: AppTypography.bodySmall(fontSize: 12.5),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: milestone.skills.map((s) => SkillChip(label: s)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, ProjectRecommendationModel project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderCream),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.lightGold,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Recommended Project',
                  style: AppTypography.tag(
                    fontSize: 10.5,
                    color: AppColors.mutedGold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${project.difficulty} • ${project.duration}',
                style: AppTypography.tag(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            project.title,
            style: AppTypography.titleMedium(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            project.objective,
            style: AppTypography.bodySmall(fontSize: 12.5),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.cardCream,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 14, color: AppColors.mutedGold),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    project.reason,
                    style: AppTypography.bodySmall(
                      fontSize: 11.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                spacing: 6,
                children: project.targetSkills.map((s) => SkillChip(label: s)).toList(),
              ),
              if (project.referenceRepo.isNotEmpty)
                TextButton.icon(
                  onPressed: () => UrlHelper.launchWebUrl(context, project.referenceRepo),
                  icon: const Icon(Icons.open_in_new, size: 14),
                  label: const Text('GitHub Template'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryNavy,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
