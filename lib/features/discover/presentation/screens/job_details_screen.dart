import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../core/widgets/skill_chip.dart';
import '../../data/models/job_model.dart';
import '../providers/job_provider.dart';

class JobDetailsScreen extends ConsumerStatefulWidget {
  final String jobId;
  final JobModel? initialJob;

  const JobDetailsScreen({
    super.key,
    required this.jobId,
    this.initialJob,
  });

  @override
  ConsumerState<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends ConsumerState<JobDetailsScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Overview', 'Requirements', 'About', 'Reviews'];
  late bool _isSaved;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.initialJob?.isSaved ?? false;
  }

  void _showApplicationConfirmation(JobModel job) {
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
                      color: AppColors.statusInReviewBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified_user_outlined,
                      color: AppColors.secondaryNavy,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Apply with Approval',
                    style: AppTypography.titleMedium(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Your AI Career Twin will review your verified GitHub skills and matched resume before submitting to ${job.company} via ${job.source}.',
                style: AppTypography.bodySmall(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.chipCream,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.description_outlined, size: 18, color: AppColors.textPrimary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Using: Resume_v3_Software_Intern.pdf',
                        style: AppTypography.tag(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        UrlHelper.launchWebUrl(context, job.sourceUrl);
                      },
                      child: const Text('View Listing'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Application request queued for approval. Check the Applications tab for status.',
                            ),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      child: const Text('Confirm & Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobAsync = ref.watch(jobDetailProvider(widget.jobId));

    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      appBar: AppBar(
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: _isSaved ? AppColors.antiqueGold : AppColors.textPrimary,
            ),
            onPressed: () {
              setState(() {
                _isSaved = !_isSaved;
              });
              ref.read(jobNotifierProvider.notifier).toggleSaveJob(widget.jobId);
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Link copied to clipboard')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: jobAsync.when(
        data: (job) => _buildContent(context, job),
        loading: () {
          if (widget.initialJob != null) {
            return _buildContent(context, widget.initialJob!);
          }
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryNavy),
            ),
          );
        },
        error: (err, stack) {
          if (widget.initialJob != null) {
            return _buildContent(context, widget.initialJob!);
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error, size: 40),
                  const SizedBox(height: 12),
                  Text('Failed to load job details', style: AppTypography.titleMedium()),
                  const SizedBox(height: 8),
                  Text(err.toString(), style: AppTypography.bodySmall(), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.refresh(jobDetailProvider(widget.jobId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, JobModel job) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Source + Posted Time Header
                Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF1E88E5),
                      ),
                      child: const Center(
                        child: Text(
                          'n',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      job.source.toLowerCase(),
                      style: AppTypography.titleMedium(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E88E5),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      job.postedAt,
                      style: AppTypography.bodySmall(
                        fontSize: 11.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Job Title
                Text(
                  job.title,
                  style: AppTypography.titleLarge(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),

                // Company Name + Logo + Location
                Row(
                  children: [
                    _buildCompanyLogo(job),
                    const SizedBox(width: 8),
                    Text(
                      job.company,
                      style: AppTypography.titleMedium(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      job.location,
                      style: AppTypography.bodySmall(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Metadata Badges Row (Internship, Duration, Stipend)
                Row(
                  children: [
                    _buildMetaPill(Icons.work_outline, job.employmentType),
                    const SizedBox(width: 8),
                    if (job.duration != null) ...[
                      _buildMetaPill(Icons.access_time, job.duration!),
                      const SizedBox(width: 8),
                    ],
                    if (job.stipend != null)
                      _buildMetaPill(Icons.currency_rupee, job.stipend!),
                  ],
                ),
                const SizedBox(height: 16),

                // Segmented Tabs: Overview, Requirements, About, Reviews
                Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.chipCream,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: List.generate(_tabs.length, (index) {
                      final isSelected = index == _selectedTabIndex;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTabIndex = index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryNavy : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _tabs[index],
                              style: AppTypography.tag(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 18),

                // Tab Content Based on Selected Tab
                if (_selectedTabIndex == 0) ...[
                  // AI Match Analysis Card
                  _buildAiMatchAnalysisCard(job),
                  const SizedBox(height: 18),

                  // Key Skills from Job Description
                  Text(
                    'Key Skills from Job Description',
                    style: AppTypography.titleMedium(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (job.keySkills.isNotEmpty ? job.keySkills : job.skills)
                        .map((skill) => SkillChip(label: skill))
                        .toList(),
                  ),
                  const SizedBox(height: 22),

                  // Your Skill Fit Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Skill Fit',
                        style: AppTypography.titleMedium(
                          fontSize: 15,
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
                          'See Detailed Analysis',
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
                  _buildSkillFitsList(job),
                ] else if (_selectedTabIndex == 1) ...[
                  // Requirements tab
                  Text(
                    'Job Requirements',
                    style: AppTypography.titleMedium(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  if (job.requirements.isNotEmpty)
                    ...job.requirements.map(
                      (r) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Expanded(child: Text(r, style: AppTypography.bodySmall(fontSize: 13))),
                          ],
                        ),
                      ),
                    )
                  else
                    Text('Requirements provided on source page.', style: AppTypography.bodySmall()),
                ] else if (_selectedTabIndex == 2) ...[
                  // About tab
                  Text(
                    'About ${job.company}',
                    style: AppTypography.titleMedium(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    job.aboutCompany ??
                        '${job.company} is an active employer on ${job.source}. Tap below to view company overview.',
                    style: AppTypography.bodySmall(fontSize: 13, height: 1.5),
                  ),
                ] else ...[
                  // Reviews tab
                  Text(
                    'Company Reviews & Ratings',
                    style: AppTypography.titleMedium(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Employee reviews and salary insights are available directly on ${job.source}.',
                    style: AppTypography.bodySmall(fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Sticky Bottom Action Bar
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            border: Border(top: BorderSide(color: AppColors.borderCream)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Save Button
              OutlinedButton.icon(
                onPressed: () {
                  setState(() => _isSaved = !_isSaved);
                  ref.read(jobNotifierProvider.notifier).toggleSaveJob(job.id);
                },
                icon: Icon(
                  _isSaved ? Icons.bookmark : Icons.bookmark_border,
                  size: 18,
                  color: AppColors.primaryNavy,
                ),
                label: Text(_isSaved ? 'Saved' : 'Save'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.cardCream,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  side: const BorderSide(color: AppColors.borderCream),
                ),
              ),
              const SizedBox(width: 12),
              // Apply with Approval Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showApplicationConfirmation(job),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNavy,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'Apply with Approval',
                    style: AppTypography.titleMedium(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAiMatchAnalysisCard(JobModel job) {
    final analysis = job.aiMatchAnalysis;
    final matchScore = analysis?.matchPercentage ?? job.matchScore;
    final points = analysis?.points ?? [
      'Core technical requirements match',
      'Role aligns with your career path',
      'Good match for internship goals',
    ];

    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: AppColors.antiqueGold, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          'AI Match Analysis',
                          style: AppTypography.titleMedium(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...points.map(
                      (pt) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                pt,
                                style: AppTypography.bodySmall(
                                  fontSize: 12.5,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Circular Match Percentage Ring
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.successLight,
                  border: Border.all(color: AppColors.success, width: 3),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$matchScore%',
                        style: AppTypography.tag(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.success,
                        ),
                      ),
                      Text(
                        'Match',
                        style: AppTypography.tag(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillFitsList(JobModel job) {
    final list = job.skillFits.isNotEmpty
        ? job.skillFits
        : [
            SkillFitItem(skill: 'Python', percentage: 90, matched: true),
            SkillFitItem(skill: 'Data Structures', percentage: 80, matched: true),
            SkillFitItem(skill: 'System Design', percentage: 60, matched: true),
            SkillFitItem(skill: 'Linux', percentage: 40, matched: false),
          ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderCream),
      ),
      child: Column(
        children: list.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 110,
                  child: Text(
                    item.skill,
                    style: AppTypography.bodySmall(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: item.percentage / 100.0,
                      backgroundColor: AppColors.chipCream,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        item.matched ? AppColors.success : AppColors.warning,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 38,
                  child: Text(
                    '${item.percentage}%',
                    textAlign: TextAlign.end,
                    style: AppTypography.tag(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  item.matched ? Icons.check_circle : Icons.cancel,
                  color: item.matched ? AppColors.success : AppColors.error,
                  size: 16,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMetaPill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.chipCream,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.tag(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyLogo(JobModel job) {
    if (job.company.toLowerCase().contains('zoho')) {
      return Container(
        width: 22,
        height: 22,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.borderCream),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          children: const [
            ColoredBox(color: Color(0xFFE53935)),
            ColoredBox(color: Color(0xFF43A047)),
            ColoredBox(color: Color(0xFF1E88E5)),
            ColoredBox(color: Color(0xFFFDD835)),
          ],
        ),
      );
    }
    return const Icon(Icons.business, size: 18, color: AppColors.textSecondary);
  }
}
