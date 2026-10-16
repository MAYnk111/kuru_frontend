class ApplicationModel {
  final String id;
  final String role;
  final String company;
  final String? companyLogo;
  final String appliedDate;
  final String status;
  final String statusType; // 'applied', 'in_review', 'interview', 'shortlisted'
  final String? listingUrl;
  final String? resumeVersion;

  ApplicationModel({
    required this.id,
    required this.role,
    required this.company,
    this.companyLogo,
    required this.appliedDate,
    required this.status,
    required this.statusType,
    this.listingUrl,
    this.resumeVersion,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'] as String? ?? '',
      role: json['role'] as String? ?? '',
      company: json['company'] as String? ?? '',
      companyLogo: json['company_logo'] as String?,
      appliedDate: json['applied_date'] as String? ?? '',
      status: json['status'] as String? ?? 'Applied',
      statusType: json['status_type'] as String? ?? 'applied',
      listingUrl: json['listing_url'] as String?,
      resumeVersion: json['resume_version'] as String?,
    );
  }
}

class ApplicationMetrics {
  final int applied;
  final int inReview;
  final int interviews;
  final int shortlisted;

  ApplicationMetrics({
    required this.applied,
    required this.inReview,
    required this.interviews,
    required this.shortlisted,
  });

  factory ApplicationMetrics.fromJson(Map<String, dynamic> json) {
    return ApplicationMetrics(
      applied: (json['applied'] as num?)?.toInt() ?? 0,
      inReview: (json['in_review'] as num?)?.toInt() ?? 0,
      interviews: (json['interviews'] as num?)?.toInt() ?? 0,
      shortlisted: (json['shortlisted'] as num?)?.toInt() ?? 0,
    );
  }
}

class ApplicationsDataWrapper {
  final ApplicationMetrics metrics;
  final List<ApplicationModel> activeApplications;

  ApplicationsDataWrapper({
    required this.metrics,
    required this.activeApplications,
  });

  factory ApplicationsDataWrapper.fromJson(Map<String, dynamic> json) {
    return ApplicationsDataWrapper(
      metrics: ApplicationMetrics.fromJson(
        (json['metrics'] as Map<String, dynamic>?) ?? {},
      ),
      activeApplications: (json['active_applications'] as List<dynamic>?)
              ?.map((e) => ApplicationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
