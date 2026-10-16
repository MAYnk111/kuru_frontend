import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/circular_progress_gauge.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../providers/career_twin_provider.dart';
import '../widgets/skill_detail_sheet.dart';
import '../widgets/skill_graph_widget.dart';

class CareerTwinScreen extends ConsumerStatefulWidget {
  const CareerTwinScreen({super.key});

  @override
  ConsumerState<CareerTwinScreen> createState() => _CareerTwinScreenState();
}

class _CareerTwinScreenState extends ConsumerState<CareerTwinScreen> {
  final List<String> _subTabs = ['Overview', 'Skills', 'Projects', 'Simulate'];

  void _showConnectedReposSheet(BuildContext context) {
    final state = ref.read(careerTwinNotifierProvider);
    final repos = state.assessment?.connectedRepositories ?? [];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryNavy,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.code, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Connected GitHub Repositories',
                    style: AppTypography.titleMedium(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (repos.isEmpty)
                Text(
                  'No repositories connected yet. Connect your GitHub account to analyze code evidence.',
                  style: AppTypography.bodySmall(),
                )
              else
                ...repos.map(
                  (repo) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cardCream,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderCream),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.folder_outlined, color: AppColors.secondaryNavy, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                repo.name,
                                style: AppTypography.tag(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Commit ${repo.lastCommit} • ${repo.analyzedAt}',
                                style: AppTypography.bodySmall(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.statusShortlistedBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            repo.status,
                            style: AppTypography.tag(
                              fontSize: 10.5,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ref.read(careerTwinNotifierProvider.notifier).triggerReassessment();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Re-assessment requested from FastAPI backend.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Request Code Re-assessment'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(careerTwinNotifierProvider);
    final notifier = ref.read(careerTwinNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      body: Column(
        children: [
          // Navy Top Header
          Container(
            color: AppColors.primaryNavy,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 16, 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Career Twin',
                          style: AppTypography.titleLarge(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.settings_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Twin Assessment Preferences')),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Sub-navigation Tabs: Overview, Skills, Projects, Simulate
                    Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.navySurface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: _subTabs.map((tab) {
                          final isSelected = tab == state.selectedSubTab;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => notifier.setSubTab(tab),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.secondaryNavy : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: isSelected
                                      ? Border.all(
                                          color: AppColors.antiqueGold.withOpacity(0.4),
                                          width: 1,
                                        )
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  tab,
                                  style: AppTypography.tag(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                    color: isSelected ? Colors.white : AppColors.textOnNavySecondary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Screen Body
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primaryNavy,
              onRefresh: () => notifier.loadAssessment(),
              child: Builder(
                builder: (context) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryNavy),
                      ),
                    );
                  }

                  if (state.errorMessage != null && state.assessment == null) {
                    return ErrorStateView(
                      message: state.errorMessage!,
                      onRetry: () => notifier.loadAssessment(),
                    );
                  }

                  final assessment = state.assessment;
                  if (assessment == null) {
                    return EmptyStateView(
                      title: 'No Assessment Data',
                      message: 'Connect your GitHub repository to generate your AI Career Twin.',
                      actionLabel: 'Connect GitHub',
                      onAction: () => _showConnectedReposSheet(context),
                    );
                  }

                  // Overview Tab Content
                  if (state.selectedSubTab == 'Overview') {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card 1: Circular Gauge & Metric Counts
                          _buildReadinessCard(context, assessment),
                          const SizedBox(height: 16),

                          // Card 2: Skill Graph
                          SkillGraphWidget(
                            skills: assessment.skills,
                            onViewFullGraph: () {
                              notifier.setSubTab('Skills');
                            },
                          ),
                          const SizedBox(height: 16),

                          // Card 3: Connected Repositories
                          _buildConnectedReposCard(context, assessment),
                        ],
                      ),
                    );
                  } else if (state.selectedSubTab == 'Skills') {
                    // Skills list tab
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: assessment.skills.length,
                      itemBuilder: (context, index) {
                        final skill = assessment.skills[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: AppColors.cardWhite,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderCream),
                          ),
                          child: ListTile(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => SkillDetailSheet(skill: skill),
                              );
                            },
                            leading: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: AppColors.chipCream,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.code, color: AppColors.secondaryNavy, size: 20),
                            ),
                            title: Text(skill.name, style: AppTypography.titleMedium(fontSize: 14)),
                            subtitle: Text('${skill.category} • ${skill.score}% proficiency'),
                            trailing: const Icon(Icons.chevron_right, size: 18),
                          ),
                        );
                      },
                    );
                  } else if (state.selectedSubTab == 'Projects') {
                    return EmptyStateView(
                      icon: Icons.lightbulb_outline,
                      title: 'Gap-Targeted Projects',
                      message: 'Recommended projects tailored to your assessed gaps are integrated in the Growth tab.',
                      actionLabel: 'Go to Growth',
                      onAction: () {},
                    );
                  } else {
                    // Simulate Tab
                    return EmptyStateView(
                      icon: Icons.tune,
                      title: 'Career Simulator',
                      message: 'Simulate the impact of acquiring new frameworks on your target Naukri match rates.',
                      actionLabel: 'Start Simulation',
                      onAction: () {},
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadinessCard(BuildContext context, dynamic assessment) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderCream),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Circular Gauge with Orbiting Categories
          CircularReadinessGauge(
            score: assessment.readinessScore,
            categories: [
              GaugeCategoryNode(name: 'Problem Solving', icon: Icons.psychology_outlined, level: 85),
              GaugeCategoryNode(name: 'Programming', icon: Icons.code, level: 90),
              GaugeCategoryNode(name: 'System Design', icon: Icons.dns_outlined, level: 65),
              GaugeCategoryNode(name: 'Tools & Frameworks', icon: Icons.build_outlined, level: 80),
              GaugeCategoryNode(name: 'Communication', icon: Icons.groups_outlined, level: 75),
            ],
            onCategoryTap: (category) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${category.name} Proficiency: ${category.level}%')),
              );
            },
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.borderCream),
          const SizedBox(height: 12),

          // Summary Metrics Row (3 columns)
          Row(
            children: [
              _buildMetricColumn(
                count: '${assessment.demonstratedSkillsCount}',
                label: 'Key Skills\nDemonstrated',
                countColor: AppColors.primaryNavy,
              ),
              _buildVerticalDivider(),
              _buildMetricColumn(
                count: '${assessment.inProgressCount}',
                label: 'In\nProgress',
                countColor: AppColors.primaryNavy,
              ),
              _buildVerticalDivider(),
              _buildMetricColumn(
                count: '${assessment.toDevelopCount}',
                label: 'To\nDevelop',
                countColor: const Color(0xFFD95345),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn({
    required String count,
    required String label,
    required Color countColor,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count,
            style: AppTypography.displayBold(
              fontSize: 22,
              color: countColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
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

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 36,
      color: AppColors.borderCream,
    );
  }

  Widget _buildConnectedReposCard(BuildContext context, dynamic assessment) {
    final repoCount = assessment.connectedRepositories.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderCream),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: AppColors.primaryNavy,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.code, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connected Repositories',
                  style: AppTypography.titleMedium(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$repoCount repos analyzed',
                  style: AppTypography.bodySmall(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => _showConnectedReposSheet(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'View',
              style: AppTypography.tag(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryNavy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
