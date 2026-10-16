class ApiConfig {
  ApiConfig._();

  // Configurable base URL with environment variable support
  static String _baseUrl = const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  static String get baseUrl => _baseUrl;

  static void setBaseUrl(String url) {
    _baseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  // Endpoints defined in Section 9 of the prompt
  static const String jobs = '/api/v1/jobs';
  static String jobDetail(String id) => '/api/v1/jobs/$id';
  static const String githubConnect = '/api/v1/github/connect';
  static const String repositoriesAnalyze = '/api/v1/repositories/analyze';
  static const String careerTwin = '/api/v1/career-twin';
  static const String careerTwinAssess = '/api/v1/career-twin/assess';
  static const String growthGoals = '/api/v1/growth/goals';
  static String growthGoal(String id) => '/api/v1/growth/goals/$id';
  static const String growthRoadmap = '/api/v1/growth/roadmap';
  static const String growthResources = '/api/v1/growth/resources';
  static const String growthProjects = '/api/v1/growth/projects';
  static const String applications = '/api/v1/applications';
  static const String resumeTailor = '/api/v1/resumes/tailor';

  // Demo / offline preview mode (can be enabled via Settings or flag)
  // By default, false in production as per Section 10
  static bool enableDemoPreviewMode = false;
}
