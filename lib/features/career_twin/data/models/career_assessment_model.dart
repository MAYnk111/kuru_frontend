class CareerAssessmentModel {
  final int readinessScore;
  final int demonstratedSkillsCount;
  final int inProgressCount;
  final int toDevelopCount;
  final List<AssessmentCategory> categories;
  final List<SkillModel> skills;
  final List<ConnectedRepository> connectedRepositories;

  CareerAssessmentModel({
    required this.readinessScore,
    required this.demonstratedSkillsCount,
    required this.inProgressCount,
    required this.toDevelopCount,
    required this.categories,
    required this.skills,
    required this.connectedRepositories,
  });

  factory CareerAssessmentModel.fromJson(Map<String, dynamic> json) {
    return CareerAssessmentModel(
      readinessScore: (json['readiness_score'] as num?)?.toInt() ?? 0,
      demonstratedSkillsCount: (json['demonstrated_skills_count'] as num?)?.toInt() ?? 0,
      inProgressCount: (json['in_progress_count'] as num?)?.toInt() ?? 0,
      toDevelopCount: (json['to_develop_count'] as num?)?.toInt() ?? 0,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => AssessmentCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      connectedRepositories: (json['connected_repositories'] as List<dynamic>?)
              ?.map((e) => ConnectedRepository.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class AssessmentCategory {
  final String name;
  final String icon;
  final int level;

  AssessmentCategory({
    required this.name,
    required this.icon,
    required this.level,
  });

  factory AssessmentCategory.fromJson(Map<String, dynamic> json) {
    return AssessmentCategory(
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? 'code',
      level: (json['level'] as num?)?.toInt() ?? 0,
    );
  }
}

class SkillModel {
  final String id;
  final String name;
  final String category;
  final String assessmentStatus; // 'Demonstrated', 'In Progress', 'To Develop'
  final int score;
  final String? repository;
  final String? commitSha;
  final String? analyzedAt;
  final String? evidence;

  SkillModel({
    required this.id,
    required this.name,
    required this.category,
    required this.assessmentStatus,
    required this.score,
    this.repository,
    this.commitSha,
    this.analyzedAt,
    this.evidence,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      assessmentStatus: json['assessment_status'] as String? ?? 'In Progress',
      score: (json['score'] as num?)?.toInt() ?? 0,
      repository: json['repository'] as String?,
      commitSha: json['commit_sha'] as String?,
      analyzedAt: json['analyzed_at'] as String?,
      evidence: json['evidence'] as String?,
    );
  }
}

class ConnectedRepository {
  final String name;
  final String url;
  final String lastCommit;
  final String status;
  final String analyzedAt;

  ConnectedRepository({
    required this.name,
    required this.url,
    required this.lastCommit,
    required this.status,
    required this.analyzedAt,
  });

  factory ConnectedRepository.fromJson(Map<String, dynamic> json) {
    return ConnectedRepository(
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
      lastCommit: json['last_commit'] as String? ?? '',
      status: json['status'] as String? ?? 'Pending',
      analyzedAt: json['analyzed_at'] as String? ?? '',
    );
  }
}
