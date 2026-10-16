import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../core/widgets/skill_chip.dart';
import '../../data/models/growth_models.dart';

class ResourcesTab extends StatelessWidget {
  final List<LearningResourceModel> resources;
  final String activeFilter;
  final ValueChanged<String> onFilterChanged;

  const ResourcesTab({
    super.key,
    required this.resources,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    const filters = ['All', 'Documentation', 'Repository', 'Practice Course', 'Technical Article'];

    final filteredList = activeFilter == 'All'
        ? resources
        : resources.where((r) => r.type.toLowerCase() == activeFilter.toLowerCase()).toList();

    return Column(
      children: [
        // Filter Chips Row
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final f = filters[index];
              final isSelected = f == activeFilter;
              return GestureDetector(
                onTap: () => onFilterChanged(f),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryNavy : AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryNavy : AppColors.borderCream,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      f,
                      style: AppTypography.tag(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Resources List
        Expanded(
          child: filteredList.isEmpty
              ? Center(
                  child: Text(
                    'No resources match selected filter.',
                    style: AppTypography.bodySmall(),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final res = filteredList[index];
                    return _buildResourceCard(context, res);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildResourceCard(BuildContext context, LearningResourceModel res) {
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
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.chipCream,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  res.type,
                  style: AppTypography.tag(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryNavy,
                  ),
                ),
              ),
              const Spacer(),
              if (res.estimatedReadTime != null)
                Text(
                  res.estimatedReadTime!,
                  style: AppTypography.bodySmall(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            res.title,
            style: AppTypography.titleMedium(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Provider: ${res.provider}',
            style: AppTypography.bodySmall(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkillChip(label: res.skill),
              ElevatedButton.icon(
                onPressed: () => UrlHelper.launchWebUrl(context, res.url),
                icon: const Icon(Icons.open_in_new, size: 14),
                label: const Text('Open Resource'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNavy,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: Size.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: AppTypography.tag(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
