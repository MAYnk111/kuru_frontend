import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../providers/growth_provider.dart';
import '../widgets/daily_goals_tab.dart';
import '../widgets/roadmap_tab.dart';
import '../widgets/resources_tab.dart';

class GrowthScreen extends ConsumerStatefulWidget {
  const GrowthScreen({super.key});

  @override
  ConsumerState<GrowthScreen> createState() => _GrowthScreenState();
}

class _GrowthScreenState extends ConsumerState<GrowthScreen> {
  final List<String> _tabs = ['Today', 'Roadmap', 'Resources'];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(growthNotifierProvider);
    final notifier = ref.read(growthNotifierProvider.notifier);

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
                          'My Growth Plan',
                          style: AppTypography.titleLarge(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Growth calendar and daily streak'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Sub-navigation Tabs: Today, Roadmap, Resources
                    Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.navySurface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: _tabs.map((tab) {
                          final isSelected = tab == state.activeTab;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => notifier.setActiveTab(tab),
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

          // Main Body with Tab Content
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primaryNavy,
              onRefresh: () => notifier.loadAllGrowthData(),
              child: Builder(
                builder: (context) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryNavy),
                      ),
                    );
                  }

                  if (state.errorMessage != null && state.goals.isEmpty) {
                    return ErrorStateView(
                      message: state.errorMessage!,
                      onRetry: () => notifier.loadAllGrowthData(),
                    );
                  }

                  if (state.activeTab == 'Today') {
                    if (state.goals.isEmpty) {
                      return EmptyStateView(
                        title: 'No Goals for Today',
                        message: 'Complete repository assessment or set a target career role to generate targeted tasks.',
                        actionLabel: 'Refresh Goals',
                        onAction: () => notifier.loadAllGrowthData(),
                      );
                    }
                    return DailyGoalsTab(
                      goals: state.goals,
                      onToggleGoal: (id) => notifier.toggleGoal(id),
                    );
                  } else if (state.activeTab == 'Roadmap') {
                    return RoadmapTab(
                      roadmap: state.roadmap,
                      projects: state.projects,
                    );
                  } else {
                    return ResourcesTab(
                      resources: state.resources,
                      activeFilter: state.selectedResourceFilter,
                      onFilterChanged: (f) => notifier.setResourceFilter(f),
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
}
