import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../providers/application_provider.dart';
import '../widgets/application_item_card.dart';
import '../widgets/application_metric_card.dart';
import '../widgets/resume_workflow_sheet.dart';

class ApplicationsScreen extends ConsumerStatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  ConsumerState<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends ConsumerState<ApplicationsScreen> {
  final List<String> _tabs = ['Overview', 'Resumes', 'Activity'];

  void _showTailorSheet(bool isAutoApply) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ResumeWorkflowSheet(isAutoApply: isAutoApply),
    );
  }

  void _showApplicationDetail(dynamic app) {
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
              Text(
                app.role,
                style: AppTypography.titleLarge(fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                '${app.company} • ${app.appliedDate}',
                style: AppTypography.bodySmall(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cardCream,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Current Status:', style: AppTypography.bodySmall()),
                        Text(
                          app.status,
                          style: AppTypography.tag(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                      ],
                    ),
                    if (app.resumeVersion != null) ...[
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Submitted Resume:', style: AppTypography.bodySmall()),
                          Text(
                            app.resumeVersion!,
                            style: AppTypography.tag(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (app.listingUrl != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      UrlHelper.launchWebUrl(context, app.listingUrl!);
                    },
                    child: const Text('View Original Listing'),
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
    final state = ref.watch(applicationNotifierProvider);
    final notifier = ref.read(applicationNotifierProvider.notifier);

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
                          'Applications',
                          style: AppTypography.titleLarge(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () => _showTailorSheet(false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Sub-navigation Tabs: Overview, Resumes, Activity
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

          // Main Body
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primaryNavy,
              onRefresh: () => notifier.loadApplications(),
              child: Builder(
                builder: (context) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryNavy),
                      ),
                    );
                  }

                  if (state.errorMessage != null && state.applications.isEmpty) {
                    return ErrorStateView(
                      message: state.errorMessage!,
                      onRetry: () => notifier.loadApplications(),
                    );
                  }

                  if (state.activeTab == 'Overview') {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 4-Column Metric Summary Card
                          if (state.metrics != null)
                            ApplicationMetricCard(metrics: state.metrics!),

                          const SizedBox(height: 20),

                          // Active Applications Section Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Active Applications',
                                style: AppTypography.titleLarge(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'See All',
                                  style: AppTypography.tag(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.mutedGold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Applications List
                          ...state.applications.map(
                            (app) => ApplicationItemCard(
                              application: app,
                              onTap: () => _showApplicationDetail(app),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Resume & Autopilot Action Cards
                          _buildWorkflowActionCard(
                            icon: Icons.description_outlined,
                            iconColor: AppColors.secondaryNavy,
                            iconBg: AppColors.statusInReviewBg,
                            title: 'Tailor Resume for a New Role',
                            subtitle: 'Generate a customized resume based on job requirements.',
                            onTap: () => _showTailorSheet(false),
                          ),
                          const SizedBox(height: 10),
                          _buildWorkflowActionCard(
                            icon: Icons.send_rounded,
                            iconColor: const Color(0xFFE53935),
                            iconBg: const Color(0xFFFFECEB),
                            title: 'Auto Apply (With Approval)',
                            subtitle: 'Get matched jobs and approve before applying.',
                            onTap: () => _showTailorSheet(true),
                          ),
                        ],
                      ),
                    );
                  } else if (state.activeTab == 'Resumes') {
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        ListTile(
                          tileColor: AppColors.cardWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: AppColors.borderCream),
                          ),
                          leading: const Icon(Icons.picture_as_pdf, color: AppColors.error),
                          title: const Text('Resume_v3_Software_Intern.pdf'),
                          subtitle: const Text('Verified from GitHub evidence • Updated 12 Aug'),
                          trailing: const Icon(Icons.more_vert),
                        ),
                      ],
                    );
                  } else {
                    return const EmptyStateView(
                      icon: Icons.history,
                      title: 'No Recent Activity',
                      message: 'Status transitions and interview invitations will appear here in chronological order.',
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

  Widget _buildWorkflowActionCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderCream),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.titleMedium(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTypography.bodySmall(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
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
          ),
        ),
      ),
    );
  }
}
