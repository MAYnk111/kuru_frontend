import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../../../../core/widgets/star_sparkle.dart';
import '../providers/job_provider.dart';
import '../widgets/filter_chips.dart';
import '../widgets/job_card.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showServerSettingsModal() {
    final textController = TextEditingController(text: ApiConfig.baseUrl);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.dns, color: AppColors.primaryNavy),
                      const SizedBox(width: 8),
                      Text(
                        'Backend Server Configuration',
                        style: AppTypography.titleMedium(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'FastAPI base URL for jobs, skill assessments, and roadmaps:',
                    style: AppTypography.bodySmall(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      labelText: 'FastAPI Base URL',
                      hintText: 'e.g. http://10.0.2.2:8000 or http://127.0.0.1:8000',
                    ),
                  ),
                  const SizedBox(height: 14),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Reference Preview Fixtures',
                      style: AppTypography.titleMedium(fontSize: 14),
                    ),
                    subtitle: Text(
                      'Load exact prompt reference data offline when FastAPI is not active',
                      style: AppTypography.bodySmall(fontSize: 11.5),
                    ),
                    value: ApiConfig.enableDemoPreviewMode,
                    activeThumbColor: AppColors.antiqueGold,
                    onChanged: (val) {
                      setModalState(() {
                        ApiConfig.enableDemoPreviewMode = val;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ApiConfig.setBaseUrl(textController.text.trim());
                        Navigator.pop(ctx);
                        ref.read(jobNotifierProvider.notifier).loadJobs();
                      },
                      child: const Text('Save & Reconnect'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobState = ref.watch(jobNotifierProvider);
    final jobNotifier = ref.read(jobNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      body: Column(
        children: [
          // Navy Header matching Reference
          Container(
            color: AppColors.primaryNavy,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top User Greeting Row
                    Row(
                      children: [
                        // Avatar with antique gold border
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.antiqueGold,
                              width: 1.5,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.person,
                                color: AppColors.antiqueGold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Namaste,',
                                style: AppTypography.bodySmall(
                                  color: AppColors.antiqueGold,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Arjun',
                                style: AppTypography.titleLarge(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Server Connection / Settings button
                        IconButton(
                          icon: const Icon(
                            Icons.tune_outlined,
                            color: AppColors.antiqueGold,
                            size: 20,
                          ),
                          onPressed: _showServerSettingsModal,
                          tooltip: 'Backend Settings',
                        ),
                        // Notification Bell with badge
                        Stack(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.notifications_none_outlined,
                                color: Colors.white,
                                size: 22,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('No new notifications'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              top: 10,
                              right: 12,
                              child: Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: AppColors.antiqueGold,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Vedic Quote Banner
                    Row(
                      children: [
                        const StarSparkle(size: 15, color: AppColors.antiqueGold),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '"Right opportunities come to those who keep growing."',
                            style: AppTypography.serifQuote(
                              fontSize: 12.5,
                              color: AppColors.textOnNavySecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Search Field and Filter Action
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: TextField(
                              controller: _searchController,
                              onSubmitted: (val) => jobNotifier.setSearchQuery(val),
                              style: AppTypography.bodyMedium(fontSize: 13),
                              decoration: InputDecoration(
                                hintText: 'Search jobs, companies, skills...',
                                prefixIcon: const Icon(Icons.search, size: 20),
                                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear, size: 16),
                                        onPressed: () {
                                          _searchController.clear();
                                          jobNotifier.setSearchQuery('');
                                        },
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryNavy,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.antiqueGold.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.tune,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: _showServerSettingsModal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Filters Row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: FilterChipsRow(
              selectedFilter: jobState.selectedFilter,
              onSelected: (filter) => jobNotifier.setFilter(filter),
            ),
          ),

          // Job Listings Body
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primaryNavy,
              onRefresh: () => jobNotifier.loadJobs(),
              child: Builder(
                builder: (context) {
                  if (jobState.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryNavy,
                        ),
                      ),
                    );
                  }

                  if (jobState.errorMessage != null && jobState.jobs.isEmpty) {
                    return ErrorStateView(
                      message: jobState.errorMessage!,
                      onRetry: () => jobNotifier.loadJobs(),
                      onConfigureServer: _showServerSettingsModal,
                    );
                  }

                  if (jobState.jobs.isEmpty) {
                    return EmptyStateView(
                      title: 'No Opportunities Found',
                      message: 'No jobs match your search or filter criteria. Try adjusting your query or check back later.',
                      actionLabel: 'Reset Filters',
                      onAction: () {
                        _searchController.clear();
                        jobNotifier.setSearchQuery('');
                        jobNotifier.setFilter('For You');
                      },
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: jobState.jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobState.jobs[index];
                      return JobCard(
                        job: job,
                        onTap: () {
                          context.push('/jobs/${job.id}', extra: job);
                        },
                        onToggleSave: () {
                          jobNotifier.toggleSaveJob(job.id);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
