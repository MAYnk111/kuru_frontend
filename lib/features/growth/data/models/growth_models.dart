class DailyGoalModel {
  final String id;
  final String title;
  final String description;
  final String skill;
  final String? effort;
  final String priority;
  final bool isCompleted;
  final String? recommendationReason;

  DailyGoalModel({
    required this.id,
    required this.title,
    required this.description,
    required this.skill,
    this.effort,
    this.priority = 'Medium',
    this.isCompleted = false,
    this.recommendationReason,
  });

  factory DailyGoalModel.fromJson(Map<String, dynamic> json) {
    return DailyGoalModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      skill: json['skill'] as String? ?? '',
      effort: json['effort'] as String?,
      priority: json['priority'] as String? ?? 'Medium',
      isCompleted: json['is_completed'] as bool? ?? false,
      recommendationReason: json['recommendation_reason'] as String?,
    );
  }

  DailyGoalModel copyWith({bool? isCompleted}) {
    return DailyGoalModel(
      id: id,
      title: title,
      description: description,
      skill: skill,
      effort: effort,
      priority: priority,
      isCompleted: isCompleted ?? this.isCompleted,
      recommendationReason: recommendationReason,
    );
  }
}

class RoadmapModel {
  final String targetRole;
  final int completionPercentage;
  final List<RoadmapMilestone> milestones;

  RoadmapModel({
    required this.targetRole,
    required this.completionPercentage,
    required this.milestones,
  });

  factory RoadmapModel.fromJson(Map<String, dynamic> json) {
    return RoadmapModel(
      targetRole: json['target_role'] as String? ?? 'Software Engineer',
      completionPercentage: (json['completion_percentage'] as num?)?.toInt() ?? 0,
      milestones: (json['milestones'] as List<dynamic>?)
              ?.map((e) => RoadmapMilestone.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class RoadmapMilestone {
  final String id;
  final String title;
  final String status; // 'Completed', 'In Progress', 'Pending'
  final int progress;
  final String estimatedWeeks;
  final String description;
  final List<String> skills;
  final List<RoadmapProject> projects;

  RoadmapMilestone({
    required this.id,
    required this.title,
    required this.status,
    required this.progress,
    required this.estimatedWeeks,
    required this.description,
    required this.skills,
    required this.projects,
  });

  factory RoadmapMilestone.fromJson(Map<String, dynamic> json) {
    return RoadmapMilestone(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      status: json['status'] as String? ?? 'Pending',
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      estimatedWeeks: json['estimated_weeks'] as String? ?? '',
      description: json['description'] as String? ?? '',
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      projects: (json['projects'] as List<dynamic>?)
              ?.map((e) => RoadmapProject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class RoadmapProject {
  final String title;
  final String objective;
  final String status;

  RoadmapProject({
    required this.title,
    required this.objective,
    required this.status,
  });

  factory RoadmapProject.fromJson(Map<String, dynamic> json) {
    return RoadmapProject(
      title: json['title'] as String? ?? '',
      objective: json['objective'] as String? ?? '',
      status: json['status'] as String? ?? 'Pending',
    );
  }
}

class LearningResourceModel {
  final String id;
  final String title;
  final String provider;
  final String type; // 'Documentation', 'Repository', 'Practice Course', 'Article'
  final String url;
  final String topic;
  final String skill;
  final bool saved;
  final String? estimatedReadTime;

  LearningResourceModel({
    required this.id,
    required this.title,
    required this.provider,
    required this.type,
    required this.url,
    required this.topic,
    required this.skill,
    this.saved = false,
    this.estimatedReadTime,
  });

  factory LearningResourceModel.fromJson(Map<String, dynamic> json) {
    return LearningResourceModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      provider: json['provider'] as String? ?? '',
      type: json['type'] as String? ?? 'Article',
      url: json['url'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      skill: json['skill'] as String? ?? '',
      saved: json['saved'] as bool? ?? false,
      estimatedReadTime: json['estimated_read_time'] as String?,
    );
  }
}

class ProjectRecommendationModel {
  final String id;
  final String title;
  final String objective;
  final String reason;
  final List<String> targetSkills;
  final String difficulty;
  final String duration;
  final String referenceRepo;

  ProjectRecommendationModel({
    required this.id,
    required this.title,
    required this.objective,
    required this.reason,
    required this.targetSkills,
    required this.difficulty,
    required this.duration,
    required this.referenceRepo,
  });

  factory ProjectRecommendationModel.fromJson(Map<String, dynamic> json) {
    return ProjectRecommendationModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      objective: json['objective'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      targetSkills: (json['target_skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      difficulty: json['difficulty'] as String? ?? 'Intermediate',
      duration: json['duration'] as String? ?? '',
      referenceRepo: json['reference_repo'] as String? ?? '',
    );
  }
}
