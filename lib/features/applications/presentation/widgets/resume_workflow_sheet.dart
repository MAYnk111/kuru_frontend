import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

class ResumeWorkflowSheet extends StatefulWidget {
  final bool isAutoApply;

  const ResumeWorkflowSheet({super.key, this.isAutoApply = false});

  @override
  State<ResumeWorkflowSheet> createState() => _ResumeWorkflowSheetState();
}

class _ResumeWorkflowSheetState extends State<ResumeWorkflowSheet> {
  final TextEditingController _roleController =
      TextEditingController(text: 'Software Engineering Intern');
  final TextEditingController _companyController =
      TextEditingController(text: 'Zoho Corporation');
  String _selectedBaseResume = 'Resume_v3_Software_Intern.pdf';

  @override
  void dispose() {
    _roleController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: widget.isAutoApply ? const Color(0xFFFFECEB) : AppColors.statusInReviewBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.isAutoApply ? Icons.send : Icons.description_outlined,
                  color: widget.isAutoApply ? const Color(0xFFE53935) : AppColors.secondaryNavy,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.isAutoApply
                      ? 'Auto Apply (With Approval)'
                      : 'Tailor Resume for a New Role',
                  style: AppTypography.titleMedium(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.isAutoApply
                ? 'Your AI Twin matches jobs and prepares submissions. Nothing is submitted without your explicit manual review.'
                : 'Select your target role and company. The AI Twin will emphasize your verified repository evidence while maintaining complete authenticity.',
            style: AppTypography.bodySmall(
              fontSize: 12.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Target Job Title',
            style: AppTypography.tag(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _roleController,
            decoration: const InputDecoration(
              hintText: 'e.g. Backend Developer Intern',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Target Company',
            style: AppTypography.tag(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _companyController,
            decoration: const InputDecoration(
              hintText: 'e.g. Swiggy, Zoho, Microsoft',
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Source Resume Baseline',
            style: AppTypography.tag(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.cardCream,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderCream),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedBaseResume,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(
                    value: 'Resume_v3_Software_Intern.pdf',
                    child: Text('Resume_v3_Software_Intern.pdf (Verified)'),
                  ),
                  DropdownMenuItem(
                    value: 'Resume_v2_Backend.pdf',
                    child: Text('Resume_v2_Backend.pdf'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedBaseResume = val);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      widget.isAutoApply
                          ? 'Auto-apply criteria updated. Pending matches will require your approval.'
                          : 'Tailored draft generated for ${_companyController.text} based on verified repository evidence.',
                    ),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: Text(
                widget.isAutoApply ? 'Enable Monitored Auto-Apply' : 'Generate Grounded Draft',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
