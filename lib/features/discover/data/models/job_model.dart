class JobModel {
  final String id;
  final String title;
  final String company;
  final String? companyLogo;
  final String location;
  final String workArrangement;
  final String employmentType;
  final String? duration;
  final String? stipend;
  final String postedAt;
  final String source;
  final String sourceUrl;
  final int matchScore;
  final bool isTopMatch;
  final bool isSaved;
  final List<String> skills;
  final int extraSkillsCount;
  final AiMatchAnalysis? aiMatchAnalysis;
  final List<String> keySkills;
  final List<SkillFitItem> skillFits;
  final String? description;
  final List<String> requirements;
  final String? aboutCompany;

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    this.companyLogo,
    required this.location,
    required this.workArrangement,
    required this.employmentType,
    this.duration,
    this.stipend,
    required this.postedAt,
    required this.source,
    required this.sourceUrl,
    required this.matchScore,
    this.isTopMatch = false,
    this.isSaved = false,
    required this.skills,
    this.extraSkillsCount = 0,
    this.aiMatchAnalysis,
    this.keySkills = const [],
    this.skillFits = const [],
    this.description,
    this.requirements = const [],
    this.aboutCompany,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Untitled Role',
      company: json['company'] as String? ?? 'Unknown Company',
      companyLogo: json['company_logo'] as String?,
      location: json['location'] as String? ?? 'Not specified',
      workArrangement: json['work_arrangement'] as String? ?? 'On-site',
      employmentType: json['employment_type'] as String? ?? 'Full Time',
      duration: json['duration'] as String?,
      stipend: json['stipend'] as String?,
      postedAt: json['posted_at'] as String? ?? 'Recently',
      source: json['source'] as String? ?? 'Provider',
      sourceUrl: json['source_url'] as String? ?? '',
      matchScore: (json['match_score'] as num?)?.toInt() ?? 0,
      isTopMatch: json['is_top_match'] as bool? ?? false,
      isSaved: json['is_saved'] as bool? ?? false,
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      extraSkillsCount: (json['extra_skills_count'] as num?)?.toInt() ?? 0,
      aiMatchAnalysis: json['ai_match_analysis'] != null
          ? AiMatchAnalysis.fromJson(
              json['ai_match_analysis'] as Map<String, dynamic>)
          : null,
      keySkills: (json['key_skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      skillFits: (json['skill_fits'] as List<dynamic>?)
              ?.map((e) => SkillFitItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      description: json['description'] as String?,
      requirements: (json['requirements'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      aboutCompany: json['about_company'] as String?,
    );
  }

  JobModel copyWith({bool? isSaved}) {
    return JobModel(
      id: id,
      title: title,
      company: company,
      companyLogo: companyLogo,
      location: location,
      workArrangement: workArrangement,
      employmentType: employmentType,
      duration: duration,
      stipend: stipend,
      postedAt: postedAt,
      source: source,
      sourceUrl: sourceUrl,
      matchScore: matchScore,
      isTopMatch: isTopMatch,
      isSaved: isSaved ?? this.isSaved,
      skills: skills,
      extraSkillsCount: extraSkillsCount,
      aiMatchAnalysis: aiMatchAnalysis,
      keySkills: keySkills,
      skillFits: skillFits,
      description: description,
      requirements: requirements,
      aboutCompany: aboutCompany,
    );
  }
}

class AiMatchAnalysis {
  final int matchPercentage;
  final List<String> points;

  AiMatchAnalysis({
    required this.matchPercentage,
    required this.points,
  });

  factory AiMatchAnalysis.fromJson(Map<String, dynamic> json) {
    return AiMatchAnalysis(
      matchPercentage: (json['match_percentage'] as num?)?.toInt() ?? 0,
      points: (json['points'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class SkillFitItem {
  final String skill;
  final int percentage;
  final bool matched;

  SkillFitItem({
    required this.skill,
    required this.percentage,
    required this.matched,
  });

  factory SkillFitItem.fromJson(Map<String, dynamic> json) {
    return SkillFitItem(
      skill: json['skill'] as String? ?? '',
      percentage: (json['percentage'] as num?)?.toInt() ?? 0,
      matched: json['matched'] as bool? ?? false,
    );
  }
}
